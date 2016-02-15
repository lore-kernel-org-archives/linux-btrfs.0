Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43204 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbcBOUq0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 15:46:26 -0500
Subject: [PATCH 2/3] punch-alternating: use the block size reported by the
 fs for punching
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Mon, 15 Feb 2016 12:46:21 -0800
Message-ID: <20160215204621.7977.91236.stgit@birch.djwong.org>
In-Reply-To: <20160215204608.7977.2802.stgit@birch.djwong.org>
References: <20160215204608.7977.2802.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we're trying to punch alternating blocks out of a file, use the
bsize reported by fstatfs so that we can punch out single blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 src/punch-alternating.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/src/punch-alternating.c b/src/punch-alternating.c
index 9566310..4148622 100644
--- a/src/punch-alternating.c
+++ b/src/punch-alternating.c
@@ -14,6 +14,7 @@
 int main(int argc, char *argv[])
 {
 	struct stat	s;
+	struct statfs	sf;
 	off_t		offset;
 	int		fd;
 	blksize_t	blksz;
@@ -35,8 +36,12 @@ int main(int argc, char *argv[])
 	if (error)
 		goto err;
 
+	error = fstatfs(fd, &sf);
+	if (error)
+		goto err;
+
 	sz = s.st_size;
-	blksz = s.st_blksize;
+	blksz = sf.f_bsize;
 
 	mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 	for (offset = 0; offset < sz; offset += blksz * 2) {

