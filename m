Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:65083 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbcCRBbn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 21:31:43 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 99F8EAC0464
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 10:31:40 +0900 (JST)
Subject: [PATCH 3/5] btrfs-progs: "inspect-internal subvolid-resolve" doesn't
 work
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56EB5A74.6000908@jp.fujitsu.com>
Date: Fri, 18 Mar 2016 10:31:32 +0900
MIME-Version: 1.0
In-Reply-To: <56EB5937.8070208@jp.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <56EB5937.8070208@jp.fujitsu.com>

"inspect-internal subvolid-resolve" doesn't work from the following commit.

commit 176aeca9a148 ("btrfs-progs: add getopt stubs where needed")

It's because 1st argument, subvolid, is also used for the pathname of
filesystem. 2nd argument should be used for this purpose instead.

* actual result

   ==================================================
   # ./btrfs inspect-internal subvolid-resolve 260 /btrfs
   ERROR: cannot access '260': No such file or directory
   ==================================================

* expected result

   ==================================================
   # btrfs inspect-internal subvolid-resolve 260 /btrfs
   snap
   ==================================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
  cmds-inspect.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 04e1ae8..6045985 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -273,7 +273,7 @@ static int cmd_inspect_subvolid_resolve(int argc, char **argv)
  	if (check_argc_exact(argc - optind, 2))
  		usage(cmd_inspect_subvolid_resolve_usage);

-	fd = btrfs_open_dir(argv[optind], &dirstream, 1);
+	fd = btrfs_open_dir(argv[optind + 1], &dirstream, 1);
  	if (fd < 0) {
  		ret = -ENOENT;
  		goto out;
-- 
2.7.0
