Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:43120 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933727AbeEWROS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 13:14:18 -0400
Received: by mail-pl0-f66.google.com with SMTP id c41-v6so13406927plj.10
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 10:14:18 -0700 (PDT)
Date: Wed, 23 May 2018 10:14:14 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>,
        Timofey Titovets <nefelim4ag@gmail.com>
Subject: Re: [PATCH 0/2] Btrfs: fix partly checksummed file races
Message-ID: <20180523171414.GA12533@vader>
References: <cover.1527026445.git.osandov@fb.com>
 <20180523101714.GZ6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180523101714.GZ6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2018 at 12:17:14PM +0200, David Sterba wrote:
> On Tue, May 22, 2018 at 03:02:11PM -0700, Omar Sandoval wrote:
> > Based on kdave/for-next. Note that there's a Fixes: tag in there
> > referencing a commit in the for-next branch, so that would have to be
> > updated if the commit gets rebased. These patches are also available at
> > https://github.com/osandov/linux/tree/btrfs-nodatasum-race.
> 
> If the original patch is not in any released or frozen branch, then the
> fix should be folded to the original patch. The for-next branch is for
> preview, testing and catching bugs that slip past the review. And gets
> reassembled frequently so referencing a patch from there does not make
> sense.
> 
> Sending the fixups as patches is ok, replies to the original thread
> might get lost in the noise.

Ok, let's fold it in. I pushed Timofey's series with the fix folded in
here: https://github.com/osandov/linux/tree/btrfs-ioctl-fixes, based on
misc-next with Timofey's patches removed. The diff vs his original
patches is the same as my patch:

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 65d709002775..75c66ac77fd7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3113,12 +3113,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	if (olen == 0)
 		return 0;
 
-	/* don't make the dst file partly checksummed */
-	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
-	    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM)) {
-		return -EINVAL;
-	}
-
 	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
 	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
 	if (chunk_count == 0)
@@ -3151,6 +3145,13 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	else
 		btrfs_double_inode_lock(src, dst);
 
+	/* don't make the dst file partly checksummed */
+	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
+	    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	for (i = 0; i < chunk_count; i++) {
 		ret = btrfs_extent_same_range(src, loff, BTRFS_MAX_DEDUPE_LEN,
 					      dst, dst_loff, &cmp);

The clone fix and device remove fix are in that branch, too. Let me know
if you'd prefer it as patches.
