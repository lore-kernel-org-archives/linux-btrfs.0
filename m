Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:26312 "EHLO
	mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbcCNAQQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 20:16:16 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 7BC70AC050B
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2016 09:16:10 +0900 (JST)
Subject: [PATCH 3/4] btrfs-progs: Fix a regression that btrfs filesystem label
 doesn't work
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <56E5FF9A.4020609@jp.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56E602AE.7080203@jp.fujitsu.com>
Date: Mon, 14 Mar 2016 09:15:42 +0900
MIME-Version: 1.0
In-Reply-To: <56E5FF9A.4020609@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The number of arguments which is allowed to pass became wrong
from the following commit.

commit 176aeca9a148c5e29de0 ("btrfs-progs: add getopt stubs where needed")

* actual result

  ===========================================================
  # ./btrfs prop get /btrfs label
  label=foo
  # ./btrfs fi label /btrfs
  btrfs filesystem label: too few arguments
  usage: btrfs filesystem label [<device>|<mount_point>] [<newlabel>]

      Get or change the label of a filesystem

      With one argument, get the label of filesystem on <device>.
      If <newlabel> is passed, set the filesystem label to <newlabel>.

  # ./btrfs fi label /btrfs bar
  foo
  # ./btrfs prop get /btrfs label
  label=foo
  ===========================================================

* expected result

  ===========================================================
  # ./btrfs prop get /btrfs label
  label=foo
  # ./btrfs fi label /btrfs
  foo
  # ./btrfs fi label /btrfs bar
  # ./btrfs prop get /btrfs label
  label=bar
  ===========================================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 cmds-filesystem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 7e74e1b..45c16d2 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1255,11 +1255,11 @@ static int cmd_filesystem_label(int argc, char **argv)
 {
 	clean_args_no_options(argc, argv, cmd_filesystem_label_usage);

-	if (check_argc_min(argc - optind, 2) ||
-			check_argc_max(argc - optind, 3))
+	if (check_argc_min(argc - optind, 1) ||
+			check_argc_max(argc - optind, 2))
 		usage(cmd_filesystem_label_usage);

-	if (argc - optind > 2) {
+	if (argc - optind > 1) {
 		return set_label(argv[optind], argv[optind + 1]);
 	} else {
 		char label[BTRFS_LABEL_SIZE];
-- 
2.7.0
