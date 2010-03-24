From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix unaligned access at btrfs_csum_final()
Date: Tue, 23 Mar 2010 20:51:55 -0400
Message-ID: <20100324005155.GE5021@think>
References: <1269214268-1151-1-git-send-email-a.beregalov@gmail.com>
 <20100323153420.GC30249@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Alexander Beregalov <a.beregalov@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100323153420.GC30249@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 23, 2010 at 11:34:20AM -0400, Chris Mason wrote:
> On Mon, Mar 22, 2010 at 02:31:08AM +0300, Alexander Beregalov wrote:
> > Btrfs on Sparc64 produces a lot of warnings
> > Kernel unaligned access at TPC[10148c84] btrfs_csum_final+0x44/0x60 [btrfs]
> 
> Great, thanks for trackign this down.
> 
> > 
> > It happens when btrfs_csum_final is called from write_dev_supers():
> > 2195:	btrfs_csum_final(crc, sb->csum);
> > 
> > crc is u32, aligning sb->csum on 4-byte boundary fixes the problem.
> 
> So the size of the csum field is already 4 byte aligned, I'm surprised
> we need this?

Jens did some testing and this patch changes the size of the super
struct, which changes things on disk.

But, the real problem is write_dev_supers operates on a copy of the
super struct and that copy isn't aligned.  So we just need to align the
copy in struct btrfs_fs_info, which Jens should have a neat little patch
for shortly.

So we should finally have this one fixed up shortly.  Thanks again.

-chris

