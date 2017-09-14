Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50218 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdINKLt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 06:11:49 -0400
Subject: [PATCH 2/2] btrfs: build: omit unnecessary -MD flag
From: Naohiro Aota <naohiro.aota@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Date: Thu, 14 Sep 2017 19:10:56 +0900
Message-ID: <150538385685.24503.15875606860945494531.stgit@naota.dhcp.fujisawa.hgst.com>
In-Reply-To: <150538384653.24503.41288304442819820.stgit@naota.dhcp.fujisawa.hgst.com>
References: <150538384653.24503.41288304442819820.stgit@naota.dhcp.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

According to gcc(1), "-MD is equivalent to -M -MF file, except that -E is not
implied." Since the rule in the Makefile is just generating dependency file
and not building object file, it is no use to have "-MD" here. Also, it's
overridden and conflicting with the following "-MM" flag. I guess we can drop
it.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c00dff6..60c802a 100644
--- a/Makefile
+++ b/Makefile
@@ -264,7 +264,7 @@ else
 endif
 
 %.o.d: %.c
-	$(Q)$(CC) -MD -MM -MG -MF $@ -MT $(@:.o.d=.o) -MT $(@:.o.d=.static.o) -MT $@ $(CFLAGS) $<
+	$(Q)$(CC) -MM -MG -MF $@ -MT $(@:.o.d=.o) -MT $(@:.o.d=.static.o) -MT $@ $(CFLAGS) $<
 
 #
 # Pick from per-file variables, btrfs_*_cflags

