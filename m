Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33116 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3B0HPc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 02:15:32 -0500
Received: by mail-pa0-f45.google.com with SMTP id kl14so252590pab.32
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 23:15:32 -0800 (PST)
Message-ID: <512DB284.1090806@gmail.com>
Date: Wed, 27 Feb 2013 15:15:16 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: xfstests <xfs@oss.sgi.com>, linux-btrfs@vger.kernel.org,
        list.btrfs@jan-o-sch.net
Subject: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by
-x option of filefrag, and will fail with
	'FIBMAP: Invalid argument'
for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
     'FIEMAP failed with unsupported flags 2'
Remove the '-x' option.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  276 |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/276 b/276
index 082f943..f2b17c9 100755
--- a/276
+++ b/276
@@ -75,7 +75,7 @@ _filter_extents()

  _check_file_extents()
  {
-	cmd="filefrag -vx $1"
+	cmd="filefrag -v $1"
  	echo "# $cmd" >> $seq.full
  	out=`$cmd | _filter_extents`
  	if [ -z "$out" ]; then
-- 
1.7.10.4

