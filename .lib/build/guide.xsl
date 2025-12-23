<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ht="http://www.w3.org/1999/xhtml" xmlns:us="urn:eridan.net:voyages" xmlns:xs="http://www.w3.org/2001/XMLSchema" expand-text="yes" exclude-result-prefixes="xs us" version="1.0">
  <xsl:include href="index.xsl"/>
  <xsl:output method="html"/>
  <xsl:param name="client" />
  <xsl:param name="select" select="0"/>
  <xsl:template name="bookmark">
    <xsl:variable name="names">
      <sect rank="1" name="section"/>
      <sect rank="2" name="chapter"/>
      <sect rank="3" name="topic"/>
    </xsl:variable>
    <xsl:variable name="list" select="tokenize($select,':')"/>
    <xsl:for-each select="$list"><xsl:variable name="pos" select="position()"></xsl:variable>
      <xsl:element name="{$names/sect[@rank=$pos]/@name}">{.}</xsl:element>
    </xsl:for-each>
    <xsl:for-each select="xs:integer(1+count($list)) to 3">
      <xsl:element name="{$names/sect[@rank=current()]/@name}">0</xsl:element>
    </xsl:for-each>
  </xsl:template>
  <xsl:variable name="bookmark">
    <def>
      <xsl:call-template name="bookmark"/>
    </def>
  </xsl:variable>
  <xsl:template name="head">
      <head>
        <title>{@title}</title>
        <link rel="stylesheet" href="guide.css"/>
        <script src="/lib/gui.js"/>
        <script src="/lib/guide.js"/>
        <script>window.onload= { if (init) then init/text() else 'guideInit' };
        <xsl:if test="@urn">window.name= '{@urn}'</xsl:if>
        </script>
      </head>
  </xsl:template>
  <xsl:template match="/guide">
    <html>  <xsl:call-template name="head" />
  <xsl:comment>select: {$select}</xsl:comment>
  <xsl:comment>section:chapter:topic = {$bookmark/def/section}:{$bookmark/def/chapter}:{$bookmark/def/topic}</xsl:comment>
      <body>
        <xsl:choose>
          <xsl:when test="heading/@index">
            <xsl:call-template name="body"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="frame">
              <xsl:text>yes</xsl:text>
            </xsl:attribute>
            <view>
              <xsl:call-template name="body"/>
            </view>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="body">
    <heading>
      <xsl:call-template name="position"/>
      <label>
        <xsl:value-of select="heading"/>
      </label>
      <xsl:choose>
        <xsl:when test="index"><xsl:copy-of select="index" />
        </xsl:when>
        <xsl:otherwise>
      <index>
        <xsl:for-each select="topics/topic">
          <xsl:copy>
            <xsl:copy-of select="@id"/>
            <xsl:value-of select="@name"/>
          </xsl:copy>
        </xsl:for-each>
      </index>
        </xsl:otherwise>
      </xsl:choose>
    </heading>
    <xsl:apply-templates select="sequence"/>
    <xsl:apply-templates select="topics"/>
    <xsl:apply-templates select="views"/>
  </xsl:template>
  <xsl:template match="sequence"><xsl:copy-of select="." />
  </xsl:template>
  <xsl:template match="topics">
    <xsl:copy>
      <xsl:attribute name="select">{$bookmark/def/section}</xsl:attribute>
      <xsl:for-each select="intro">
        <topic>
          <xsl:apply-templates/>
        </topic>
      </xsl:for-each>
      <xsl:for-each select="topic">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="select">
            <xsl:choose>
              <xsl:when test="position() = $bookmark/def/section">{$bookmark/def/chapter}</xsl:when>
              <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="views">
    <xsl:for-each select="view">
      <iframe allowtransparency="true" src="{@default}">
        <xsl:copy-of select="@name"/>
        <xsl:copy-of select="@width"/>
        <xsl:copy-of select="@height"/>
        <xsl:text>?</xsl:text>
      </iframe>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="position">
    <xsl:param name="p" select="heading/position"/>
    <xsl:choose>
      <xsl:when test="$p">
        <xsl:attribute name="index">
          <xsl:text>list</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="style">
          <xsl:text>position: absolute;</xsl:text>
          <xsl:value-of select="if ($p/@top) then 'top:'||$p/@top||'px;' else '' "/>
          <xsl:value-of select="if ($p/@right) then 'right:'||$p/@right||'px;' else '' "/>
          <xsl:value-of select="if ($p/@width) then 'width:'||$p/@width||'px;' else '' "/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="heading/@index"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="svg">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="defs">
    <!--ignore-->
  </xsl:template>
  <xsl:template match="ref">
    <xsl:copy-of select="ancestor::*[@root=current()/@parent]/defs/def[@id=current()/@id]/*"/>
  </xsl:template>
  <!--= = =-->
  <xsl:variable name="guides">
    <xsl:for-each select="/guide/topics/topic">
      <guides topic="{@name}">
        <xsl:variable name="test" as="xs:boolean" select="position() = $bookmark/def/section"/>
        <xsl:for-each select="guides/guide">
            <xsl:variable name="Nref">
              <xsl:choose>
                <xsl:when test="@route='static'">{@href}</xsl:when>
                <xsl:when test="$test and position() = 1+ $bookmark/def/chapter">/{$client}{@href}/{$bookmark/def/topic}</xsl:when>
                <xsl:otherwise>/{$client}{@href}/0</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
          <xsl:copy>
            <xsl:copy-of select="@name"/>
            <xsl:attribute name="href">{normalize-space($Nref)}</xsl:attribute>
          </xsl:copy>
        </xsl:for-each>
      </guides>
    </xsl:for-each>
  </xsl:variable>
  <!-- = = = -->
  <xsl:template match="*[name()!='anchors']/anchor">
    <xsl:call-template name="anchor" />
  </xsl:template>
  <xsl:template match="topic/info">
    <xsl:copy>
      <xsl:if test="@width">
        <xsl:attribute name="style">width:{@width}px;
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="sequence">
    <xsl:copy><xsl:copy-of select="@*" />
      <xsl:attribute name="select">0</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="img">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="topic/guides">
    <!--ignore-->
  </xsl:template>
  <xsl:template match="anchors">
    <xsl:choose>
      <xsl:when test="@map">
        <img class="map" src="{@map}"/>
      </xsl:when>
      <xsl:when test="svg">
        <xsl:copy-of select="svg"/>
      </xsl:when>
    </xsl:choose>
    <xsl:copy>
      <xsl:for-each select="anchor">
        <xsl:call-template name="anchor" />
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="anchor">
    <xsl:copy>
      <xsl:attribute name="href">{$guides/guides/guide[@name=current()/@target]/@href}</xsl:attribute>
      <xsl:copy-of select="@class"/>
      <xsl:variable name="frame">
        <xsl:value-of select="if (@top) then 'top:'||@top||'px;' else '' "/>
        <xsl:value-of select="if (@left) then 'left:'||@left||'px;' else '' "/>
        <xsl:value-of select="if (@width) then 'width:'||@width||'px;' else '' "/>
        <xsl:value-of select="if (@height) then 'height:'||@height||'px;' else '' "/>
        <xsl:value-of select="if (@border) then 'border:'||@border||'px;' else '' "/>
      </xsl:variable>
      <xsl:if test="string-length($frame) gt 0">
        <xsl:attribute name="style">{$frame}</xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="text()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="us:pics">
    <pics style="width: {@width}px">
      <xsl:copy-of select="@id"/>
      <xsl:copy-of select="@class"/>
      <viewbox style="width: {@viewbox}px; display: block">
        <xsl:for-each select="us:pic">
          <img height="{../@height}" src="{text()}">
            <xsl:attribute name="onclick">window.open('{text()}', '{../@zoom-tab}')</xsl:attribute>
          </img>
        </xsl:for-each>
      </viewbox>
    </pics>
  </xsl:template>
  <xsl:template match="hover">
    <xsl:copy>
      <xsl:copy-of select="text()"/>
      <xsl:for-each select="bookRef">
        <help>
          <xsl:attribute name="target">{/guide/references/@target}</xsl:attribute>
          <xsl:attribute name="href">{/guide/references/@location}/dispatch/{@section}/{@topic}</xsl:attribute>
          <xsl:copy-of select="text()"/>
        </help>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
