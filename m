Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55021 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755668AbaCSGKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 02:10:20 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2J69wGi013050
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Mar 2014 14:09:59 +0800
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] btrfs-progs: Modify the help string to keep consistent
 with man page.
Date: Wed, 19 Mar 2014 06:10:02 +0000
Message-ID: <1395209466-17042-3-git-send-email-quwenruo@cn.fujitsu.com>
References: <1395209466-17042-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1395209466-17042-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Help string of "btrfs dev scan" is inconsistent with man page,
which lacks the fact that -d|--all-device is conflict with <device>.
This patch fixes the description

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 58a336f..a9b4a38 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -188,9 +188,8 @@ static int cmd_rm_dev(int argc, char **argv)
 }
 
 static const char * const cmd_scan_dev_usage[] = {
-	"btrfs device scan [options] [<device> [<device>...]]",
+	"btrfs device scan [(-d|--all-devices)|<device> [<device>...]]",
 	"Scan devices for a btrfs filesystem",
-	"-d|--all-devices    scan all devices under /dev",
 	NULL
 };
 
-- 
1.9.0
