Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:42215 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187Ab3DSIeM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 04:34:12 -0400
Message-ID: <5170FF29.2020904@jan-o-sch.net>
Date: Fri, 19 Apr 2013 10:24:09 +0200
From: Jan Schmidt <list.lkml@jan-o-sch.net>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Wanlong Gao <gaowanlong@cn.fujitsu.com>, Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>, namhyung@gmail.com,
        agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
References: <516E5EF8.9090507@cn.fujitsu.com> <1366209997.8817.12.camel@pippen.local.home> <20130418123738.GV4816@kernel.dk> <516FED09.1040008@cn.fujitsu.com> <20130418133546.GX4816@kernel.dk> <516FFFAC.8040103@cn.fujitsu.com> <20130418143014.GZ4816@kernel.dk> <5170BB00.8080200@cn.fujitsu.com> <20130419055754.GA9691@mtj.dyndns.org>
In-Reply-To: <20130419055754.GA9691@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, April 19, 2013 at 07:57 (+0200), Tejun Heo wrote:
> (cc'ing btrfs people)
> 
> On Fri, Apr 19, 2013 at 11:33:20AM +0800, Wanlong Gao wrote:
>> RIP: 0010:[<ffffffff812484d3>]  [<ffffffff812484d3>] ftrace_raw_event_block_bio_complete+0x73/0xf0
> ...
>>  [<ffffffff811b6c10>] bio_endio+0x80/0x90
>>  [<ffffffffa0790d26>] btrfs_end_bio+0xf6/0x190 [btrfs]
>>  [<ffffffff811b6bcd>] bio_endio+0x3d/0x90
>>  [<ffffffff81249873>] req_bio_endio+0xa3/0xe0
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

Oops.

It's been my patch back in 2011 (commit 2774b2ca3), sent as an RFC-Patch and
just slipped in without further discussion of that exact change. Hackish, yes -
my reasoning was because the block layer changed bio->bi_bdev anyway, no one
would want to look into it after the bio returned (and in fact it didn't hurt
for like two years now). Although the block layer changes bi_bdev, it stays a
valid bdev pointer, I admit.

One way around this would be what you suggest, however that would mean the
caller of (btrfs|btree)_submit_bio_hook gets its completion called in the end,
but must know that the private is in fact a bbio which in turn carries the
caller's private. Doesn't sound clean to me, either.

The best idea I currently have is to add a dispatcher function that does the
freeing of bbio and calls the actual completion with mirror_num as a separate
parameter. That would make all the btrfs completions incompatible with
bio_end_io_t, but it shouldn't hurt.

At least now I know I wasn't invited to LSF for a good reason :-)

-Jan
