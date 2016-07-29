Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:35833 "EHLO
	mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbcG2PDn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 11:03:43 -0400
Received: by mail-ua0-f195.google.com with SMTP id 100so3925606uaq.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jul 2016 08:03:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160729124129.GA30795@suse.cz>
References: <20160727195609.GN30795@twin.jikos.cz> <20160728094441.GO30795@twin.jikos.cz>
 <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
 <5cef3bff-a0bf-e4f9-7906-1b784171e266@physik.fu-berlin.de>
 <20160728122439.GW30795@twin.jikos.cz> <CADxRZqyzOtHmpaO9FHhvi0DJjmabRYL0eGYBXBPXSaYa0WcWEw@mail.gmail.com>
 <f56a1b71-cd68-3d83-0650-a10df01f5d5c@physik.fu-berlin.de>
 <b2ac0d76-f2e3-81d7-0ab1-35960426d412@physik.fu-berlin.de>
 <20160728180413.GY30795@suse.cz> <CADxRZqzt8m6j_GktpKYYmDar=hDYy07DhyiuPJ-gMgtGfiGhXQ@mail.gmail.com>
 <20160729124129.GA30795@suse.cz>
From: Anatoly Pugachev <matorola@gmail.com>
Date: Fri, 29 Jul 2016 18:03:41 +0300
Message-ID: <CADxRZqyjjBg7csWsSra8b_rmE1r=eeB8P7ZtaUSs-7hwowNu-g@mail.gmail.com>
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
To: dsterba@suse.cz
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        debian-sparc <debian-sparc@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 29, 2016 at 3:41 PM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Jul 28, 2016 at 11:34:58PM +0300, Anatoly Pugachev wrote:
>> well, I think mkfs.btrfs is fixed, since I just tested it with :
>
> Good news, thanks.
>
> quick stats of the TPC messages:
>
>      23 __btrfs_map_block+0x36c/0x1180
>       9 __remove_rbio_from_cache+0x38/0x140
>       6 lock_stripe_add+0xb0/0x360
>       4 __btrfs_map_block+0x3d4/0x1180
>       3 __btrfs_map_block+0xca0/0x1180
>
> running in 'gdb btrfs.ko' for each of the addresses should tell us what are the
> locations:
>
> gdb> l *(__btrfs_map_block+0x36c)
> ...

installed fresh btrgs-progs from git
mator@nvg5120:~/btrfs-progs$ git describe --long
v4.7-0-g9d2ea01

recompiled kernel with debug info... and run xfstests/check 'btrfs/06?' again

mator@nvg5120:~/linux-2.6$ git describe --long
v4.7-0-g523d939

kernel is patched with [1] to enable btrfs module loading on
big-endian systems (not sure does current linux kernel git includes
this patch or not, used/checkout plain v4.7 tag which is 5 days old)

root@nvg5120:/home/mator/xfstests# ./check 'btrfs/06?'
FSTYP         -- btrfs
PLATFORM      -- Linux/sparc64 nvg5120 4.7.0+
MKFS_OPTIONS  -- /dev/loop0
MOUNT_OPTIONS -- /dev/loop0 /mnt/scratch

btrfs/060        156s
btrfs/061        182s
btrfs/062        312s
btrfs/063        162s
btrfs/064        152s
btrfs/065        61s
btrfs/066        65s
btrfs/067        158s
btrfs/068        74s
btrfs/069        65s
Ran: btrfs/060 btrfs/061 btrfs/062 btrfs/063 btrfs/064 btrfs/065
btrfs/066 btrfs/067 btrfs/068 btrfs/069
Passed all 10 tests

$ journalctl -b -k | awk '/TPC/{print $11}' | sort | uniq -c | sort -n
      4 __btrfs_map_block+0xa10/0x1100
      5 lock_stripe_add+0xb0/0x340
      7 __btrfs_map_block+0x9d4/0x1100
      9 __remove_rbio_from_cache+0x30/0x140
     29 __btrfs_map_block+0x96c/0x1100


$ gdb -q /lib/modules/4.7.0+/kernel/fs/btrfs/btrfs.ko
Reading symbols from /lib/modules/4.7.0+/kernel/fs/btrfs/btrfs.ko...done.
(gdb) l *(__btrfs_map_block+0x96c)
0x8498c is in __btrfs_map_block (fs/btrfs/volumes.c:5615).
5610                    div_u64_rem(stripe_nr, num_stripes, &rot);
5611
5612                    /* Fill in the logical address of each stripe */
5613                    tmp = stripe_nr * nr_data_stripes(map);
5614                    for (i = 0; i < nr_data_stripes(map); i++)
5615                            bbio->raid_map[(i+rot) % num_stripes] =
5616                                    em->start + (tmp + i) * map->stripe_len;
5617
5618                    bbio->raid_map[(i+rot) % map->num_stripes] =
RAID5_P_STRIPE;
5619                    if (map->type & BTRFS_BLOCK_GROUP_RAID6)
(gdb) l *(__btrfs_map_block+0x9d4)
0x849f4 is in __btrfs_map_block (fs/btrfs/volumes.c:5618).
5613                    tmp = stripe_nr * nr_data_stripes(map);
5614                    for (i = 0; i < nr_data_stripes(map); i++)
5615                            bbio->raid_map[(i+rot) % num_stripes] =
5616                                    em->start + (tmp + i) * map->stripe_len;
5617
5618                    bbio->raid_map[(i+rot) % map->num_stripes] =
RAID5_P_STRIPE;
5619                    if (map->type & BTRFS_BLOCK_GROUP_RAID6)
5620                            bbio->raid_map[(i+rot+1) % num_stripes] =
5621                                    RAID6_Q_STRIPE;
5622            }
(gdb) l *(__btrfs_map_block+0xa10)
0x84a30 is in __btrfs_map_block (fs/btrfs/volumes.c:5620).
5615                            bbio->raid_map[(i+rot) % num_stripes] =
5616                                    em->start + (tmp + i) * map->stripe_len;
5617
5618                    bbio->raid_map[(i+rot) % map->num_stripes] =
RAID5_P_STRIPE;
5619                    if (map->type & BTRFS_BLOCK_GROUP_RAID6)
5620                            bbio->raid_map[(i+rot+1) % num_stripes] =
5621                                    RAID6_Q_STRIPE;
5622            }
5623
5624            if (rw & REQ_DISCARD) {
(gdb) l *(lock_stripe_add+0xb0)
0xe0370 is in lock_stripe_add (fs/btrfs/raid56.c:685).
680             int walk = 0;
681
682             spin_lock_irqsave(&h->lock, flags);
683             list_for_each_entry(cur, &h->hash_list, hash_list) {
684                     walk++;
685                     if (cur->bbio->raid_map[0] == rbio->bbio->raid_map[0]) {
686                             spin_lock(&cur->bio_list_lock);
687
688                             /* can we steal this cached rbio's pages? */
689                             if (bio_list_empty(&cur->bio_list) &&
(gdb) l *(__remove_rbio_from_cache+0x30)
0xdfe30 is in __remove_rbio_from_cache (include/linux/spinlock.h:302).
297             raw_spin_lock_init(&(_lock)->rlock);            \
298     } while (0)
299
300     static __always_inline void spin_lock(spinlock_t *lock)
301     {
302             raw_spin_lock(&lock->rlock);
303     }
304
305     static __always_inline void spin_lock_bh(spinlock_t *lock)
306     {


Thanks.

[1]. http://www.spinics.net/lists/linux-btrfs/msg57193.html
