Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:55496 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750938Ab2FMET0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 00:19:26 -0400
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: ceph-on-btrfs inline-cow regression fix for 3.4.3
Date: Wed, 13 Jun 2012 00:46:26 -0300
Message-ID: <orvcivvppp.fsf@livre.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

Hi, Greg,

There's a btrfs regression in 3.4 that's causing a lot of grief to
ceph-on-btrfs users like myself.  This small and nice patch cures it.
It's in Linus' master already.  I've been running it on top of 3.4.2,
and it would be very convenient for me if this could be in 3.4.3.

Although the patch mentions ENOSPC, the fix has nothing to do with disk
full conditions; it's more along the lines of not finding enough room
for inline data contents and/or failing to split the btree nodes to make
room for it.  I don't know that anyone knows for sure, but without this
patch what we get is a horrible error, that can only be fixed with a
reboot.  Yeah, not even umount&&mount will make the filesystem writable
again.  The fix makes us return an error condition in this case, that
callers are prepared to deal with.

I know btrfs hasn't had maintenance fixes in stable series, but Chris
Mason tells me the only reason is that nobody stepped up to do so.
Given my interest, I might as well give it a try ;-)

Thanks,


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Btrfs-fall-back-to-non-inline-if-we-don-t-have-enoug.patch

>From 2adcac1a7331d93a17285804819caa96070b231f Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@redhat.com>
Date: Wed, 23 May 2012 16:10:14 -0400
Subject: [PATCH] Btrfs: fall back to non-inline if we don't have enough space

If cow_file_range_inline fails with ENOSPC we abort the transaction which
isn't very nice.  This really shouldn't be happening anyways but there's no
sense in making it a horrible error when we can easily just go allocate
normal data space for this stuff.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0298928..92df0a5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -257,10 +257,13 @@ static noinline int cow_file_range_inline(struct btrfs_trans_handle *trans,
 	ret = insert_inline_extent(trans, root, inode, start,
 				   inline_len, compressed_size,
 				   compress_type, compressed_pages);
-	if (ret) {
+	if (ret && ret != -ENOSPC) {
 		btrfs_abort_transaction(trans, root, ret);
 		return ret;
+	} else if (ret == -ENOSPC) {
+		return 1;
 	}
+
 	btrfs_delalloc_release_metadata(inode, end + 1 - start);
 	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
 	return 0;
-- 
1.7.7.6


--=-=-=



-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
