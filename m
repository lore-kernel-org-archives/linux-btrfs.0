From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Btrfs: take block group fragmentation into account for
	allocation
Date: Sun, 8 Mar 2009 17:37:07 +0100
Message-ID: <20090308163707.GC11787@kernel.dk>
References: <2c259a8f0903080742l6e2f6233g709b036281bf962c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@redhat.com>
To: Yien Zheng <esprout@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2c259a8f0903080742l6e2f6233g709b036281bf962c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 08 2009, Yien Zheng wrote:
> I tried applying this patch, but the fragmentation_percent function is
> giving me:
> 
> WARNING: "__udivdi3"
> [/home/partition6/yien/git/linux-git/fs/btrfs/btrfs.ko] undefined!
> 
> when I compile, and the module fails to load, even though the build
> completes.  I've traced it to the calculation of max_fragments:
> 
> max_fragments = (block_group->key.offset -
> 		btrfs_block_group_used(&block_group->item)) /
> 		block_group->fragment_size;
> 
> It seems that accessing block_group in here is causing a reference to
> __udivdi3 somehow.  Any idea what's going on here?

You can't to 64-bit divides on 32-bit archs. Make that

max_fragments = block_group->key.offset - btrfs_block_group_used(&block_group->item);
do_div(max_fragments, block_group->fragment_size);

and it should work.

-- 
Jens Axboe

