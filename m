Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48243 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab3CEWvW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Mar 2013 17:51:22 -0500
Message-ID: <513674B2.9030900@sandeen.net>
Date: Tue, 05 Mar 2013 16:41:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] xfstests: Fix hang when mkfs.btrfs isn't present
References: <512D1E3E.9050907@redhat.com>
In-Reply-To: <512D1E3E.9050907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My earlier patch (xfstests: handle new mkfs.btrfs -f option cleanly)
had a flaw in that if set_prog_path mkfs.btrfs returns nothing,
the grep will hang.

Test for that case to avoid it, and just return the empty string
in that case.

Reported-by: Rich Johnston <rjohnston@sgi.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common.config b/common.config
index c10163a..a0b017d 100644
--- a/common.config
+++ b/common.config
@@ -108,7 +108,7 @@ set_prog_path()
 set_btrfs_mkfs_prog_path_with_opts()
 {
 	p=`set_prog_path mkfs.btrfs`
-	if grep -q 'force overwrite' $p; then
+	if [ "$p" != "" ] && grep -q 'force overwrite' $p; then
 		echo "$p -f"
 	else
 		echo $p


