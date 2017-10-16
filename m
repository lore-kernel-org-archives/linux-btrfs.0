Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:26214 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdJPE4f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 00:56:35 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 0329BAC008D
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 13:56:29 +0900 (JST)
Received: from G01JPEXCHKW14.g01.fujitsu.local (G01JPEXCHKW14.g01.fujitsu.local [10.0.194.53])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 200146923B9
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 13:56:28 +0900 (JST)
Subject: [PATCH v3 1/2] btrfs-progs: device: add description of alias to help
 message
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7dcb7f01-ce39-18a6-9a16-9230b76baf77@jp.fujitsu.com>
Message-ID: <0391ab9e-96ba-5e18-a36e-9269cd40a182@jp.fujitsu.com>
Date: Mon, 16 Oct 2017 13:56:25 +0900
MIME-Version: 1.0
In-Reply-To: <7dcb7f01-ce39-18a6-9a16-9230b76baf77@jp.fujitsu.com>
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

