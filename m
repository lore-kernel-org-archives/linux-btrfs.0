Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:35855 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdJTBmX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 21:42:23 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id E719EAC0171
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 10:42:17 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 1E7D9328846
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 10:42:17 +0900 (JST)
Subject: [PATCH v4 1/2] btrfs-progs: device: add description of alias to help
 message
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <89bcb689-586e-f69b-2f4f-ac5f99765924@jp.fujitsu.com>
Message-ID: <fe47c1cd-7c26-7a94-dc14-0cad692123ea@jp.fujitsu.com>
Date: Fri, 20 Oct 2017 10:42:13 +0900
MIME-Version: 1.0
In-Reply-To: <89bcb689-586e-f69b-2f4f-ac5f99765924@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

State that the 'delete' is the alias of 'remove' as the man page says.

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

