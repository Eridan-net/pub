<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/doc"><html><head><xsl:copy-of select="title"></xsl:copy-of>
  </head><body><h1><xsl:copy-of select="title/text()"></xsl:copy-of></h1></body></html>
  </xsl:template>
</xsl:stylesheet>
