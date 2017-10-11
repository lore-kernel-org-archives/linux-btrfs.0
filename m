Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:36106 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbdJKCQn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 22:16:43 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id BA167AC011C
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 11:16:35 +0900 (JST)
Received: from G01JPEXCHKW17.g01.fujitsu.local (G01JPEXCHKW17.g01.fujitsu.local [10.0.194.56])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id E31EF69262B
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 11:16:34 +0900 (JST)
Subject: [PATCH v2 1/3] btrfs-progs: device: add description of alias to help
 message
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <bb58e829-77d4-1bd1-4021-2db996809a6e@jp.fujitsu.com>
Message-ID: <20f0e45f-f290-2e5f-adad-21dc8a2adc28@jp.fujitsu.com>
Date: Wed, 11 Oct 2017 11:16:31 +0900
MIME-Version: 1.0
In-Reply-To: <bb58e829-77d4-1bd1-4021-2db996809a6e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

State the 'delete' is the alias of 'remove' as the man page says.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
Reviewed-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
---
 cmds-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-device.c b/cmds-device.c
index 4337eb2..3b6b985 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -237,7 +237,7 @@ static int cmd_device_remove(int argc, char **argv)
 
 static const char * const cmd_device_delete_usage[] = {
 	"btrfs device delete <device>|<devid> [<device>|<devid>...] <path>",
-	"Remove a device from a filesystem",
+	"Remove a device from a filesystem (alias of \"btrfs device remove\")",
 	NULL
 };
 
-- 
2.9.5

