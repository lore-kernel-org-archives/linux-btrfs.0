Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43491 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab3FSHi5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Jun 2013 03:38:57 -0400
Received: by mail-ie0-f179.google.com with SMTP id c10so12607647ieb.10
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2013 00:38:57 -0700 (PDT)
Message-ID: <51C15FFC.4010303@gmail.com>
Date: Wed, 19 Jun 2013 15:38:36 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: xfstests <xfs@oss.sgi.com>, linux-btrfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Rich Johnston <rjohnston@sgi.com>
Subject: [PATCH] xfstests: add 'check -btrfs' support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently we can specify the testing filesytems like 'check -xfs', but
btrfs is not support in this kind of command option. Add the option
'check -btrfs' support.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  check |    2 ++
  1 file changed, 2 insertions(+)

diff --git a/check b/check
index ff8fbcf..9c40615 100755
--- a/check
+++ b/check
@@ -74,6 +74,7 @@ usage()

  check options
      -xfs                test XFS (default)
+    -btrfs              test Btrfs
      -udf                test UDF
      -nfs                test NFS
      -l			line mode diff
@@ -162,6 +163,7 @@ while [ $# -gt 0 ]; do
  	-udf)	FSTYP=udf ;;
  	-xfs)	FSTYP=xfs ;;
  	-nfs)	FSTYP=nfs ;;
+	-btrfs) FSTYP=btrfs ;;

  	-g)	group=$2 ; shift ;
  		group_list=$(get_group_list $group)
-- 
1.7.10.4

