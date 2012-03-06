From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [PATCH] Btrfs: hold enough space for global_rsv
Date: Tue, 6 Mar 2012 14:50:32 +0100
Message-ID: <20120306145032.697641a3@fem.tu-ilmenau.de>
References: <1326793919-2712-1-git-send-email-liubo2009@cn.fujitsu.com>
	<20120227142904.18c5df56@fem.tu-ilmenau.de>
	<4F4C3696.8010804@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F4C3696.8010804@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 28 Feb 2012 10:06:14 +0800
schrieb Liu Bo <liubo2009@cn.fujitsu.com>:

> On 02/27/2012 09:29 PM, Johannes Hirte wrote:
> > Am Tue, 17 Jan 2012 17:51:59 +0800
> > schrieb Liu Bo <liubo2009@cn.fujitsu.com>:
> > 
> >> I've kept hitting enospc warnings of global_rsv while running
> >> defragment on files:
> >> btrfs: block rsv returned -28
> >> WARNING: at fs/btrfs/extent-tree.c:5984
> >> btrfs_alloc_free_block+0x333/0x340 [btrfs]() ...
> >>
> >> I used a fio jobs to create a file with lots of fragments:
> >> $ filefrag /mnt/btrfs/foobar
> >> /mnt/btrfs/foobar: 66964 extents found
> >>
> >> and then "btrfs fi defrag /mnt/btrfs/foobar && sync" would pop the
> >> warnings.
> >>
> >> I found that the global_rsv size is just not enough for defragment,
> >> and didn't find any space leak in using global_rsv, so double it
> >> and go ahead.
> >>
> >> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> >> ---
> >>  fs/btrfs/extent-tree.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >> index 8603ee4..77ea23c 100644
> >> --- a/fs/btrfs/extent-tree.c
> >> +++ b/fs/btrfs/extent-tree.c
> >> @@ -3979,7 +3979,7 @@ static u64 calc_global_metadata_size(struct
> >> btrfs_fs_info *fs_info) num_bytes += div64_u64(data_used +
> >> meta_used, 50); 
> >>  	if (num_bytes * 3 > meta_used)
> >> -		num_bytes = div64_u64(meta_used, 3);
> >> +		num_bytes = div64_u64(meta_used, 3) * 2;
> >>  
> >>  	return ALIGN(num_bytes, fs_info->extent_root->leafsize <<
> >> 10); }
> > 
> > This patch breakes my system. With this applied all services fail on
> > boot with "no space left" messages.
> > 
> 
> It's weird since this patch is just aiming to enlarge our metadata
> reservation count.
> 
> so you've tried a revert or a bisect, right?  Can you show me the
> environment or any log messages?
> 
> thanks,
> liubo

Sorry for the long delay. My system was really screwed up and
took time to fix it.
First, it wasn't your patch that made the system fail. At this time, it
was the first revision that didn't work anymore. I don't know why this
one. Short time later also earlier revisions showed that error. I was
able to boot with a live system from USB stick. The filesystem was
mountable and readable, but I couldn't modify or create a single file.
Two or three times I got a

btrfs: fail to dirty inode 256 error -28

but most times nothing was reported in the logs.

The filesystem consists of three subvolumes, the default one, one for
rootfs and one for home. If I did a defrag on the rootfs, I was able to
create files. But after unmounting and remounting the filesystem, the
same error appeared again. Also a balance of the filesystem resulted in
no space error after some time.
I've backed up the filesystem, deleted the subvolumes, recreated them
and copied the data back. Now everything seems to work again. I've also
a full image of the damaged filesystem for further investigation. If
someone has an idea for testing, I'm happy to try it.


regards,
  Johannes
