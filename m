Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:59548 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726330AbeHWTir (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 15:38:47 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20180823155955.GO24025@suse.cz>
References: <20180823155955.GO24025@suse.cz> <22614.1535039351@warthog.procyon.org.uk>
To: dsterba@suse.cz
Cc: dhowells@redhat.com, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        WenRuo Qu <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        nborisov@suse.com
Subject: Re: fs/btrfs/volumes.c:6114 suspicious rcu_dereference_check() usage!
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 23 Aug 2018 17:08:25 +0100
Message-ID: <26325.1535040505@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba <dsterba@suse.cz> wrote:

> The code previously had explicit rcu_lock/unlock, now it uses the
> btrfs_debug_in_rcu helper which is supposed to provide that. It's
> possible that the helper is missing it due to some #ifdef mess, but I
> don't see it.

I preprocessed the function and extracted submit_stripe_bio() (see attached).

The problem is that btrfs_no_printk() is being called, but not within an RCU
section.

#define btrfs_debug_in_rcu(fs_info, fmt, args...) \
	btrfs_printk_in_rcu(fs_info, KERN_DEBUG fmt, ##args)

David
---
static void submit_stripe_bio(struct btrfs_bio *bbio, struct bio *bio,
         u64 physical, int dev_nr, int async)
{
 struct btrfs_device *dev = bbio->stripes[dev_nr].dev;
 struct btrfs_fs_info *fs_info = bbio->fs_info;

 bio->bi_private = bbio;
 btrfs_io_bio(bio)->stripe_index = dev_nr;
 bio->bi_end_io = btrfs_end_bio;
 bio->bi_iter.bi_sector = physical >> 9;
 btrfs_no_printk(fs_info, "\001" "7" "btrfs_map_bio: rw %d 0x%x, sector=%llu, dev=%lu (%s id %llu), size=%u", ((bio)->bi_opf & ((1 << 8) - 1)), bio->bi_opf, (u64)bio->bi_iter.bi_sector, (u_long)dev->bdev->bd_dev, ({ struct rcu_string *__str = ({ typeof(*(dev->name)) *________p1 = (typeof(*(dev->name)) *)({ union { typeof((dev->name)) __val; char __c[1]; } __u; if (1) __read_once_size(&((dev->name)), __u.__c, sizeof((dev->name))); else __read_once_size_nocheck(&((dev->name)), __u.__c, sizeof((dev->name))); do { } while (0); __u.__val; }); do { static bool __attribute__ ((__section__(".data.unlikely"))) __warned; if (debug_lockdep_rcu_enabled() && !__warned && (!((0) || rcu_read_lock_held()))) { __warned = true; lockdep_rcu_suspicious(



                      "fs/btrfs/volumes.c"
# 6110 "../fs/btrfs/volumes.c"
 ,



                      6114
# 6110 "../fs/btrfs/volumes.c"
 , "suspicious rcu_dereference_check() usage"); } } while (0); ; ((typeof(*(dev->name)) *)(________p1)); }); __str->str; }), dev->devid, bio->bi_iter.bi_size)



                       ;
 do { if ((bio)->bi_disk != (dev->bdev)->bd_disk) bio_clear_flag(bio, 9); (bio)->bi_disk = (dev->bdev)->bd_disk; (bio)->bi_partno = (dev->bdev)->bd_partno; } while (0);

 btrfs_bio_counter_inc_noblocked(fs_info);

 if (async)
  btrfs_schedule_bio(dev, bio);
 else
  btrfsic_submit_bio(bio);
}
