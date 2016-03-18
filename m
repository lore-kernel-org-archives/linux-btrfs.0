Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:56006 "EHLO
	mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbcCRBaF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 21:30:05 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 56F39AC0173
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 10:29:58 +0900 (JST)
Subject: [PATCH 2/5] btrfs-progs: "qgroup create/destroy" don't work
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56EB5A0E.7020903@jp.fujitsu.com>
Date: Fri, 18 Mar 2016 10:29:50 +0900
MIME-Version: 1.0
In-Reply-To: <56EB5937.8070208@jp.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <56EB5937.8070208@jp.fujitsu.com>

"qgroup create/destroy" don't work from the following commit.

commit 176aeca9a148 ("btrfs-progs: add getopt stubs where needed")

* actual result

   ==================================================
   # ./btrfs qgroup create 1 /btrfs/sub
   btrfs qgroup create: too few arguments
   usage: btrfs qgroup create <qgroupid> <path>

       Create a subvolume quota group.
   ==================================================
   # btrfs qgroup create 1 /btrfs/sub
   # ./btrfs qgroup destroy 1 /btrfs/sub
   btrfs qgroup destroy: too few arguments
   usage: btrfs qgroup destroy <qgroupid> <path>

       Destroy a quota group.

   ==================================================

* expected result

   ==================================================
   # btrfs qgroup create 1 /btrfs/sub
   # btrfs qgroup destroy 1 /btrfs/sub/
   ==================================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
  cmds-qgroup.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index c4a0c6b..7ae2253 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -124,7 +124,7 @@ static int _cmd_qgroup_create(int create, int argc, char **argv)
  	struct btrfs_ioctl_qgroup_create_args args;
  	DIR *dirstream = NULL;

-	if (check_argc_exact(argc - optind, 3))
+	if (check_argc_exact(argc - optind, 2))
  		return -1;

  	memset(&args, 0, sizeof(args));
-- 
2.7.0
