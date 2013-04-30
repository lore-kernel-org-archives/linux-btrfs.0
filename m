Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:59668 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab3D3Rxz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 13:53:55 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 39A529A0691
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 11:53:55 -0600 (MDT)
Date: Tue, 30 Apr 2013 13:53:51 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:921
 __btrfs_write_out_cache+0x6b9/0x9a0 [btrfs]()
Message-ID: <20130430175351.GF2580@localhost.localdomain>
References: <CADn-QaMao+mtnJVuwjbnqHgFzKhqUfn2uiDgN5hFw_fHP+mGcQ@mail.gmail.com>
 <CVrGRAreCXB@helmut.hullen.de>
 <20130430094131.GA8274@carfax.org.uk>
 <loom.20130430T133556-803@post.gmane.org>
 <20130430135816.GD2580@localhost.localdomain>
 <CADn-QaMFct-5XgMbqiWMG_pa-AzgOQOZLUc-CNTrAPpG7633Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CADn-QaMFct-5XgMbqiWMG_pa-AzgOQOZLUc-CNTrAPpG7633Aw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 30, 2013 at 08:33:38AM -0600, Alexander Skwar wrote:
> Hello Josef
> 
> On Tue, Apr 30, 2013 at 3:58 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> 
> > So we deal with this case fine, but it really shouldn't be happening, it only
> > happens if your block groups are way too large, which again shouldn't be
> > happening.  Can you run fsck on this device and see if it complains?  Thanks,
> 
> 
> a@ewzw032:~$ sudo btrfsck /dev/system/Data
> checking extents
> checking fs roots
> checking root refs
> found 115308904448 bytes used err is 0
> total csum bytes: 112056692
> total tree bytes: 521891840
> total fs tree bytes: 353947648
> btree space waste bytes: 122297974
> file data blocks allocated: 114787012608
>  referenced 114787000320
> Btrfs v0.20-rc1
> 

Can you run this patch and capture the output when you get the warning?  You
should see some mesages before the -- [ cut here ] -- part, make sure to capture
those.  Thanks,

Josef

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ecca6c7..2e8e098 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -921,6 +921,10 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	/* Make sure we can fit our crcs into the first page */
 	if (io_ctl.check_crcs &&
 	    (io_ctl.num_pages * sizeof(u32)) >= PAGE_CACHE_SIZE) {
+		printk(KERN_ERR "num_pages is %d, blockgroup? %s\n",
+		       io_ctl.num_pages, block_group ? "yes" : "no");
+		if (block_group)
+			printk(KERN_ERR "block group offset=%Lu, size=%Lu\n", block_group->key.objectid, block_group->key.offset);
 		WARN_ON(1);
 		goto out_nospc;
 	}
