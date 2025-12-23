<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ht="http://www.w3.org/1999/xhtml">
  <xsl:template match="/topic">
    <html>
      <head>
        <script>
          <xsl:attribute name="src">
            <xsl:value-of select="script/@using" />
          </xsl:attribute>
        </script>
        <script>
          <xsl:copy-of select="script/@src" />
        </script>
        <script>window.onload= () =&gt; {<xsl:value-of select="concat(transform/@call, &quot;('&quot;, @src, &quot;', '&quot;, transform/@xsl, &quot;', '&quot;, @select, &quot;')&quot;)" />}</script>
      </head>
      <body />
    </html>
  </xsl:template>
</xsl:stylesheet>