Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:58614 "EHLO
	mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbcCRBgn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 21:36:43 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 9EC67AC00B1
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 10:36:36 +0900 (JST)
Subject: [PATCH 5/5] btrfs-progs: qgroup assign can't handle --no-rescan
 option
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56EB5B9D.2010501@jp.fujitsu.com>
Date: Fri, 18 Mar 2016 10:36:29 +0900
MIME-Version: 1.0
In-Reply-To: <56EB5937.8070208@jp.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <56EB5937.8070208@jp.fujitsu.com>

* actual result

   ==================================================
   # btrfs qgroup assign --no-rescan 0/260 1/261 /btrfs
   btrfs qgroup assign: unrecognized option '--no-rescan'
   usage: btrfs qgroup assign [options] <src> <dst> <path>

       Assign SRC as the child qgroup of DST

       --rescan       schedule qutoa rescan if needed
       --no-rescan

   ==================================================

* expected result

   ==================================================
   # ./btrfs qgroup assign --no-rescan 0/260 1/261 /btrfs
   #
   ==================================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
  cmds-qgroup.c | 11 +++++++++--
  1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index ebd66ef..4b4149d 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -44,9 +44,13 @@ static int _cmd_qgroup_assign(int assign, int argc, char **argv,

  	if (assign) {
  		while (1) {
-			enum { GETOPT_VAL_RESCAN = 256 };
+			enum {
+				GETOPT_VAL_RESCAN = 256,
+				GETOPT_VAL_NO_RESCAN = 257,
+			};
  			static const struct option long_options[] = {
  				{ "rescan", no_argument, NULL, GETOPT_VAL_RESCAN },
+				{ "no-rescan", no_argument, NULL, GETOPT_VAL_NO_RESCAN },
  				{ NULL, 0, NULL, 0 }
  			};
  			int c = getopt_long(argc, argv, "", long_options, NULL);
@@ -57,6 +61,9 @@ static int _cmd_qgroup_assign(int assign, int argc, char **argv,
  			case GETOPT_VAL_RESCAN:
  				rescan = 1;
  				break;
+			case GETOPT_VAL_NO_RESCAN:
+				rescan = 0;
+				break;
  			default:
  				usage(usage_str);
  			}
@@ -206,7 +213,7 @@ static const char * const cmd_qgroup_assign_usage[] = {
  	"Assign SRC as the child qgroup of DST",
  	"",
  	"--rescan       schedule qutoa rescan if needed",
-	"--no-rescan    ",
+	"--no-rescan    don't schedule quota rescan",
  	NULL
  };

-- 
2.7.0
