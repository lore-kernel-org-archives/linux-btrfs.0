Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:56877 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3JUN6L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 09:58:11 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 04EBC7C041C
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 07:58:11 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id GphsoQBO5CQeRDfV (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 07:58:10 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make sure we return an error when we can't add a device
Date: Mon, 21 Oct 2013 09:58:08 -0400
Message-ID: <1382363888-22588-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed xfstests was failing in a weird way but it was because our device add
was failing but not actually returning an error so we were failing further down
the test.  Fix this by making sure we return an error if we fail the mkfs tests.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-device.c b/cmds-device.c
index 6f32356..bc4a8dc 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -98,6 +98,7 @@ static int cmd_add_dev(int argc, char **argv)
 		res = test_dev_for_mkfs(argv[i], force, estr);
 		if (res) {
 			fprintf(stderr, "%s", estr);
+			ret++;
 			continue;
 		}
 
-- 
1.8.3.1

