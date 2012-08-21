Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35246 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab2HUGnv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Aug 2012 02:43:51 -0400
Message-ID: <50332993.1000902@cn.fujitsu.com>
Date: Tue, 21 Aug 2012 14:24:19 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dave@jikos.cz>
Subject: Re: [RFC PATCH] Btrfs: fix full backref problem when inserting shared
 block reference
References: <50232A19.2010704@cn.fujitsu.com> <20120809064802.GB17430@twin.jikos.cz> <20120809072129.GC17430@twin.jikos.cz>
In-Reply-To: <20120809072129.GC17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 9 Aug 2012 09:21:29 +0200, David Sterba wrote:
> On Thu, Aug 09, 2012 at 08:48:02AM +0200, David Sterba wrote:
>> and down, no problems so far, and the "wikipedia" test-subvol stresstest
>> that caused trouble to one of your patches is also ok. I'll do some more
>> testing on other machines and will report problems eventually.
> 
> So it won't be so easy :)
> 
> The test generated 15+ G of data, ~500 snapshots, then umount and fsck:
> 
> lots of
> 
> ref mismatch on [9655283712 4096] extent item 1, found 0
> Incorrect local backref count on 9655283712 root 5 owner 589776 offset 110592 found 0 wanted 1 back 0x86badf0
> backpointer mismatch on [9655283712 4096]
> owner ref check failed [9655283712 4096]

By debuging, I found it should be a bug of btrfsck.
Could you try this patch?

Thanks
Miao

>From 77e9bcaae464354c0b0176631ba51374e3d31cfc Mon Sep 17 00:00:00 2001
From: Miao Xie <miaox@cn.fujitsu.com>
Date: Tue, 21 Aug 2012 14:16:27 +0800
Subject: [PATCH] Btrfs-progs: fix wrong return value of check_owner_ref()

If we find the block by seach corresponding fs tree, we should return 0,
and tell the caller we pass the check.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfsck.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 4e91769..57e7b57 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -1954,7 +1954,7 @@ static int check_owner_ref(struct btrfs_root *root,
 
 	if (buf->start == btrfs_node_blockptr(path.nodes[level + 1],
 					      path.slots[level + 1]))
-		rec->owner_ref_checked = 1;
+		found = 1;
 
 	btrfs_release_path(ref_root, &path);
 	return found ? 0 : 1;
-- 
1.7.6.5

> and then
> 
> checking fs roots
> root 2854 inode 233882 errors 2500
> root 2880 inode 271639 errors 2200
> 
> and it's not finished yet, other types of error may pop up.

