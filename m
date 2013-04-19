Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52577
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030254Ab3DSNdU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 09:33:20 -0400
Date: Fri, 19 Apr 2013 06:32:50 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>, namhyung@gmail.com,
        agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Message-ID: <20130419133250.GR4816@kernel.dk>
References: <516E5EF8.9090507@cn.fujitsu.com>
 <1366209997.8817.12.camel@pippen.local.home>
 <20130418123738.GV4816@kernel.dk>
 <516FED09.1040008@cn.fujitsu.com>
 <20130418133546.GX4816@kernel.dk>
 <516FFFAC.8040103@cn.fujitsu.com>
 <20130418143014.GZ4816@kernel.dk>
 <5170BB00.8080200@cn.fujitsu.com>
 <20130419055754.GA9691@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130419055754.GA9691@mtj.dyndns.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 18 2013, Tejun Heo wrote:
> (cc'ing btrfs people)
> 
> On Fri, Apr 19, 2013 at 11:33:20AM +0800, Wanlong Gao wrote:
> > RIP: 0010:[<ffffffff812484d3>]  [<ffffffff812484d3>] ftrace_raw_event_block_bio_complete+0x73/0xf0
> ...
> >  [<ffffffff811b6c10>] bio_endio+0x80/0x90
> >  [<ffffffffa0790d26>] btrfs_end_bio+0xf6/0x190 [btrfs]
> >  [<ffffffff811b6bcd>] bio_endio+0x3d/0x90
> >  [<ffffffff81249873>] req_bio_endio+0xa3/0xe0
> 
> Ugh....
> 
> In fs/btrfs/volumes.c
> 
>   static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
>   {
> 	...
> 		bio->bi_bdev = (struct block_device *)
> 			       	       (unsigned long)bbio->mirror_num;
> 	...
>   }
> 
>   static void btrfs_end_bio(struct bio *bio, int err)
>   {
> 	...
> 		bio->bi_bdev = (struct block_device *)
> 					(unsigned long)bbio->mirror_num;
> 									
> 	...
>   }
> 
> In fs/btrfs/extent_io.c
> 
>   static void end_bio_extent_readpage(struct bio *bio, int err)
>   {
> 	int mirror;
> 	...
> 		mirror = (int)(unsigned long)bio->bi_bdev;
> 	...
>   }
> 
> Ewweeeeeeeeeeeeeeeeeehh........
> 
> No wonder this thing crashes.  Chris, can't the original bio carry
> bbio in bi_private and let end_bio_extent_readpage() free the bbio
> instead of abusing bi_bdev like this?

Ugh, wtf.

Chris, time for a swim in the bay :-)

-- 
Jens Axboe

