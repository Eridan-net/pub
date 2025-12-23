<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ht="http://www.w3.org/1999/xhtml" version="1.0">
<xsl:param name="client">urn:eridan.net:voyages</xsl:param>
  <xsl:output method="html"/>
  <xsl:template match="/index">
    <html>
      <head>
        <title>
          <xsl:value-of select="@title"/>
        </title>
        <link rel="stylesheet" href="index.css"/>
        <script src="/lib/gui.js"/>
        <script src="index.js"/>
        <script><xsl:value-of select="concat('window.onload= () =&gt; Dom.init(''', @urn, ''')')"/></script>
      </head>
      <body id="body">
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="/index/heading">
    <xsl:copy>
      <menu>
        <xsl:copy-of select="home/@id"/>
        <xsl:copy-of select="home/*"/>
      </menu>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="topics">
    <xsl:for-each select="area">
      <topic>
        <xsl:for-each select="target">
          <anchor>
            <xsl:attribute name="href">
            <xsl:choose><xsl:when test="@route='static'"><xsl:value-of select="@href"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="concat('/',$client,@href,'/0')"/></xsl:otherwise>
            </xsl:choose>
            </xsl:attribute>
            <xsl:copy-of select="text()"/>
          </anchor>
        </xsl:for-each>
      </topic>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="/index/view">
    <iframe state="min">
      <xsl:copy-of select="@name"/>
      <xsl:copy-of select="@src"/>
      <xsl:text>?</xsl:text>
    </iframe>
  </xsl:template>
  <xsl:template match="/index/maps">
  <sequence select="0">
<info>
  <xsl:apply-templates select="map"/>
    </info>
    <index class="menu">
    <xsl:for-each select="map"><label><xsl:attribute name="key"><xsl:value-of select="@title"/></xsl:attribute>
    <xsl:value-of select="@title"/></label>
    </xsl:for-each>    
    </index>
  </sequence>
  </xsl:template>
  <xsl:template match="maps/map">
  <xsl:copy><xsl:copy-of select="@style"/>
    <xsl:apply-templates/></xsl:copy>
    </xsl:template>
  <xsl:template match="map/info">
  <xsl:copy><xsl:copy-of select="@*"/>
    <xsl:apply-templates/></xsl:copy>
    </xsl:template>
  <xsl:template match="map//spot">
    <img>
      <xsl:copy-of select="@width"/>
      <xsl:copy-of select="@height"/>
      <xsl:attribute name="src">
        <xsl:value-of select="ancestor::map/@href"/>
      </xsl:attribute>
    </img>
    </xsl:template>
<xsl:template match="desc">
<xsl:copy-of select="."/>
</xsl:template>
<xsl:template match="map/layer">
    <div style="position: absolute; top: 0; left: 0">
      <svg>
        <xsl:copy-of select="svg/@*"/>
        <xsl:apply-templates select="*[name()!='desc']"/>
      </svg>
      <index select="0">
      <xsl:attribute name="id">
        <xsl:value-of select="../@title"/>
      </xsl:attribute>
      <xsl:copy-of select="../label"/>
        <xsl:call-template name="topics"/>
      </index>
    </div>
  </xsl:template>
  <xsl:template match="map/label"><!-- ignore --></xsl:template>
  <xsl:template match="layer/intro">
    <g id="intro">
      <xsl:copy-of select="text"/>
      <circle><xsl:call-template name="circle"/>
      </circle>
    </g>
  </xsl:template>
  <xsl:template match="layer/area">
    <g>
      <circle><xsl:call-template name="circle"/>
      </circle>
      <rect>
        <xsl:copy-of select="@width"/>
        <xsl:copy-of select="@height"/><xsl:call-template name="xy"/>
      </rect>
      <text><xsl:call-template name="xy"/>
        <xsl:copy-of select="tspan"/>
        <xsl:apply-templates select="target"/>
      </text>
    </g>
  </xsl:template>
  <xsl:template match="area/target">
    <xsl:if test="@dx">
      <tspan>
        <xsl:copy-of select="@dx"/>
        <xsl:copy-of select="@dy"/>
        <xsl:copy-of select="text()"/>
      </tspan>
    </xsl:if>
  </xsl:template>
      <xsl:template name="circle">
        <xsl:attribute name="cx">
          <xsl:value-of select="location/@x"/>
        </xsl:attribute>
        <xsl:attribute name="cy">
          <xsl:value-of select="location/@y"/>
        </xsl:attribute>
        <xsl:attribute name="r">
          <xsl:value-of select="location/@radius"/>
        </xsl:attribute>
      </xsl:template>
<xsl:template name="xy">
        <xsl:attribute name="x">
          <xsl:value-of select="location/@x - @width div 2"/>
        </xsl:attribute>
        <xsl:attribute name="y">
          <xsl:value-of select="location/@y - @height div 2"/>
        </xsl:attribute>
</xsl:template>
</xsl:stylesheet>
