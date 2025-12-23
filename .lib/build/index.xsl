<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ht="http://www.w3.org/1999/xhtml" version="1.0" expand-text="yes">
  <xsl:template match="/index">
    <html><xsl:call-template name="head"/>
      <body id="body">
        <xsl:apply-templates select="heading|maps|view"/>
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
            <xsl:choose><xsl:when test="@route='static'">{@href}</xsl:when>
            <xsl:otherwise>/{/index/@urn}{@href}/0</xsl:otherwise>
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
    <xsl:for-each select="map"><label key="{@title}">{@title}</label>
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
    <img src="{ancestor::map/@href}">
      <xsl:copy-of select="@width"/>
      <xsl:copy-of select="@height"/>
    </img>
    </xsl:template>
<xsl:template match="map//desc">
<xsl:copy-of select="."/>
</xsl:template>
<xsl:template match="map/layer">
    <div style="position: absolute; top: 0; left: 0">
      <svg>
        <xsl:copy-of select="svg/@*"/>
        <xsl:apply-templates select="*[name()!='desc']"/>
      </svg>
      <index select="0" id="{../@title}">
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
        <xsl:attribute name="cx">{location/@x}
        </xsl:attribute>
        <xsl:attribute name="cy">{location/@y}
        </xsl:attribute>
        <xsl:attribute name="r">{location/@radius}
        </xsl:attribute>
      </xsl:template>
<xsl:template name="xy">
        <xsl:attribute name="x">{location/@x - @width div 2}
        </xsl:attribute>
        <xsl:attribute name="y">{location/@y - @height div 2}
        </xsl:attribute>
</xsl:template>
</xsl:stylesheet>
