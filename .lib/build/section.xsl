<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:exsl="http://exslt.org/common" version="1.0"
    exclude-result-prefixes="exsl">
  <xsl:template match="/doc">
    <html>
      <head>
        <link rel="stylesheet" href="/lib/section.css" />
        <link rel="stylesheet">
          <xsl:attribute name="href">
            <xsl:value-of select="concat(@css,'.css')"/>
          </xsl:attribute>
        </link>
        <script src="/lib/gui.js"/>
        <script src="/lib/doc.js"/>
      </head>
      <body><xsl:copy-of select="@class" />
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="doc/title">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="doc/index">
    <sequence select="0">
      <index>
        <xsl:for-each select="section/title">
          <label>
            <xsl:value-of select="text()"/>
          </label>
        </xsl:for-each>
      </index>
      <info>
        <xsl:for-each select="section[index]">
          <xsl:copy><xsl:copy-of select="@*" />
            <xsl:apply-templates select="index"/>
          </xsl:copy>
        </xsl:for-each>
      </info>
    </sequence>
  </xsl:template>
  <xsl:template match="section/title">
    <!-- ignore -->
  </xsl:template>
  <xsl:template match="section/index">
    <xsl:variable name="index" select="."/>
    <xsl:variable name="topics" select="following-sibling::intro | following-sibling::*[name()=current()/@target]"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:for-each select="$topics">
        <topic>
          <xsl:if test="position()=$index/@cols">
            <xsl:copy-of select="$index/@filler"/>
          </xsl:if>
          <xsl:copy-of select="title/text() | title/*"/>
        </topic>
      </xsl:for-each>
    </xsl:copy>
    <topics select="0">
      <xsl:copy-of select="@class | @id"/>
      <xsl:for-each select="$topics">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </topics>
  </xsl:template>
  <xsl:template match="intro">
    <xsl:choose>
      <xsl:when test="title">
        <section>
          <xsl:apply-templates/>
        </section>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="section">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="title"/>
    <xsl:choose>
      <xsl:when test="index">
          <xsl:for-each select="index">
            <xsl:apply-templates select="preceding-sibling::*"/>
            <xsl:apply-templates select="."/>
            <xsl:copy-of select="following-sibling::*[name()!=current()/@target and name()!='intro']"/>
          </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
          <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
        </xsl:copy>
  </xsl:template>
  <xsl:template match="resrc">
    <xsl:variable name="dir" select="ancestor::section[name(..)='index']/@dir" />
    <xsl:for-each select="img">
      <xsl:copy><xsl:copy-of select="@*" />
        <xsl:attribute name="src"><xsl:value-of select="concat($dir,'/',text())" />
        </xsl:attribute>
      </xsl:copy>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="*|text()"/>
    </xsl:copy>
  </xsl:template>
  <!-- == == -->
  <xsl:template match="draw">
  <svg><xsl:copy-of select="frame/@*"/>
    <xsl:copy-of select="style"/>
    <defs>
      <xsl:copy-of select="types/*"/>
      <xsl:for-each select="shapes/shape">
        <xsl:copy-of select="g"/>
      </xsl:for-each>
      <xsl:variable name="shapes" select="shapes/shape"/>
      <xsl:for-each select="links/conn">
        <xsl:call-template name="draw-link">
          <xsl:with-param name="from" select="$shapes[@name=current()/from/@shape]"/>
          <xsl:with-param name="to" select="$shapes[@name=current()/to/@shape]"/>
        </xsl:call-template>
      </xsl:for-each>
      <g id="links">
      <xsl:for-each select="links/conn"><use>
        <xsl:attribute name="href"><xsl:value-of select="concat('#',@id)" /></xsl:attribute>
        </use>
      </xsl:for-each>
      </g>
    </defs>
    <use><xsl:attribute name="href"><xsl:value-of select="concat('#',@shape)"/></xsl:attribute>
    </use>
    <use href="#links"/>
  </svg>
  </xsl:template>
  <xsl:template name="draw-link">
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:variable name="path">
      <xsl:call-template name="svg-link">
        <xsl:with-param name="from">
          <xsl:call-template name="svg-anchor">
            <xsl:with-param name="shape" select="$from"/>
            <xsl:with-param name="an" select="from/@anchor"/>
          </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="to">
          <xsl:call-template name="svg-anchor">
            <xsl:with-param name="shape" select="$to"/>
            <xsl:with-param name="an" select="./to/@anchor"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <g>
      <xsl:copy-of select="@id"/>
      <path>
        <xsl:attribute name="class">
          <xsl:value-of select="@style"/>
        </xsl:attribute>
        <xsl:attribute name="d">
          <xsl:value-of select="$path"/>
        </xsl:attribute>
      </path>
    </g>
  </xsl:template>
  <xsl:template name="svg-anchor">
    <xsl:param name="shape"/>
    <xsl:param name="an"/>
    <xsl:for-each select="$shape/anchors/anchor[@name=$an]">
      <xsl:copy>
        <xsl:copy-of select="@side"/>
        <xsl:attribute name="x">
          <xsl:value-of select="number($shape/@ox) + number(@x)"/>
        </xsl:attribute>
        <xsl:attribute name="y">
          <xsl:value-of select="number($shape/@oy) + number(@y)"/>
        </xsl:attribute>
      </xsl:copy>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="svg-link">
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:call-template name="svg-link-N">
      <xsl:with-param name="from" select="exsl:node-set($from)"/>
      <xsl:with-param name="to" select="exsl:node-set($to)"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="svg-link-N">
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:variable name="Oxy" select="concat($from/anchor/@x,',',$from/anchor/@y)"/>
    <xsl:variable name="FT" select="concat($from/anchor/@side, $to/anchor/@side)" />
    <xsl:variable name="dhv">
      <xsl:choose>
        <xsl:when test="contains('LRL',$FT)">
          <xsl:call-template name="svg-link-h">
            <xsl:with-param name="from" select="$from"/>
            <xsl:with-param name="to" select="$to"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains('BTB',$FT)">
          <xsl:call-template name="svg-link-v">
            <xsl:with-param name="from" select="$from"/>
            <xsl:with-param name="to" select="$to"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$from/anchor/@side='T' and $to/anchor/@side='R'">
          <xsl:call-template name="svg-link-TR">
            <xsl:with-param name="from" select="$from"/>
            <xsl:with-param name="to" select="$to"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$from/anchor/@side='T' and $to/anchor/@side='L'">
          <xsl:call-template name="svg-link-TL">
            <xsl:with-param name="from" select="$from"/>
            <xsl:with-param name="to" select="$to"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$from/anchor/@side='L' and $to/anchor/@side='B'">
          <xsl:call-template name="svg-link-LB">
            <xsl:with-param name="from" select="$from"/>
            <xsl:with-param name="to" select="$to"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$from/anchor/@side='R' and $to/anchor/@side='B'">
          <xsl:call-template name="svg-link-RB">
            <xsl:with-param name="from" select="$from"/>
            <xsl:with-param name="to" select="$to"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat('M',$Oxy,$dhv)"/>
  </xsl:template>
  <xsl:template name="svg-link-h">
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:variable name="dx" select="number($to/anchor/@x) - number($from/anchor/@x)"/>
    <xsl:value-of select="concat('h',$dx)"/>
  </xsl:template>
  <xsl:template name="svg-link-v">
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:variable name="dy" select="number($to/anchor/@y) - number($from/anchor/@y)"/>
    <xsl:value-of select="concat('v',$dy)"/>
  </xsl:template>
  <xsl:template name="svg-link-TR">
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:variable name="dx" select="number($to/anchor/@x) - number($from/anchor/@x)"/>
    <xsl:variable name="dy" select="number($to/anchor/@y) - number($from/anchor/@y)"/>
    <xsl:value-of select="concat('v',$dy,' h',$dx)"/>
  </xsl:template>
  <xsl:template name="svg-link-TL">
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:variable name="dx" select="number($to/anchor/@x) - number($from/anchor/@x)"/>
    <xsl:variable name="dy" select="number($to/anchor/@y) - number($from/anchor/@y)"/>
    <xsl:value-of select="concat('v',$dy,' h',$dx)"/>
  </xsl:template>
  <xsl:template name="svg-link-LB">
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:variable name="dx" select="number($to/anchor/@x) - number($from/anchor/@x)"/>
    <xsl:variable name="dy" select="number($to/anchor/@y) - number($from/anchor/@y)"/>
    <xsl:value-of select="concat('h',$dx, 'v',$dy)"/>
  </xsl:template>
  <xsl:template name="svg-link-RB">
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:variable name="dx" select="number($to/anchor/@x) - number($from/anchor/@x)"/>
    <xsl:variable name="dy" select="number($to/anchor/@y) - number($from/anchor/@y)"/>
    <xsl:value-of select="concat('h',$dx, 'v',$dy)"/>
  </xsl:template>
  <xsl:template name="svg-link-BT">
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:variable name="dx" select="number($to/anchor/@x) - number($from/anchor/@x)"/>
    <xsl:variable name="dy" select="number($to/anchor/@y) - number($from/anchor/@y)"/>
    <xsl:value-of select="concat('v',$dy)"/>
  </xsl:template>
</xsl:stylesheet>
