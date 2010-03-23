From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix unaligned access at btrfs_csum_final()
Date: Tue, 23 Mar 2010 11:34:20 -0400
Message-ID: <20100323153420.GC30249@think>
References: <1269214268-1151-1-git-send-email-a.beregalov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1269214268-1151-1-git-send-email-a.beregalov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 22, 2010 at 02:31:08AM +0300, Alexander Beregalov wrote:
> Btrfs on Sparc64 produces a lot of warnings
> Kernel unaligned access at TPC[10148c84] btrfs_csum_final+0x44/0x60 [btrfs]

Great, thanks for trackign this down.

> 
> It happens when btrfs_csum_final is called from write_dev_supers():
> 2195:	btrfs_csum_final(crc, sb->csum);
> 
> crc is u32, aligning sb->csum on 4-byte boundary fixes the problem.

So the size of the csum field is already 4 byte aligned, I'm surprised
we need this?

-chris
