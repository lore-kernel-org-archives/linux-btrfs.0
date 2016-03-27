Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55795 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbcC0Nz7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 09:55:59 -0400
Subject: Re: csum errors in VirtualBox VDI files
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
 <56F1068E.6050806@cn.fujitsu.com>
 <20160322194854.161e9c4c@jupiter.sol.kaishome.de>
 <56F21898.3020101@cn.fujitsu.com>
 <20160326203035.4b876a04@jupiter.sol.kaishome.de>
 <20160327035038.5ab6e64b@jupiter.sol.kaishome.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56F7E65C.7020300@gmx.com>
Date: Sun, 27 Mar 2016 21:55:40 +0800
MIME-Version: 1.0
In-Reply-To: <20160327035038.5ab6e64b@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/27/2016 09:50 AM, Kai Krakow wrote:
> Am Sat, 26 Mar 2016 20:30:35 +0100
> schrieb Kai Krakow <hurikhan77@gmail.com>:
>
>> Am Wed, 23 Mar 2016 12:16:24 +0800
>> schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:
>>
>>> Kai Krakow wrote on 2016/03/22 19:48 +0100:
>>>> Am Tue, 22 Mar 2016 16:47:10 +0800
>>>> schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:
>>>>
>>   [...]
>>>   [...]
>>   [...]
>>>>
>>>> Apparently, that system does not boot now due to errors in bcache
>>>> b-tree. That being that, it may well be some bcache error and not
>>>> btrfs' fault. Apparently I couldn't catch the output, I've been
>>>> in a hurry. It said "write error" and had some backtrace. I will
>>>> come to this back later.
>>>>
>>>> Let's go to the system I currently care about (that one with the
>>>> always breaking VDI file):
>>>>
>>>   [...]
>>   [...]
>>>>
>>>> After the error occured?
>>>>
>>>> Yes, some text about the extent being compressed and btrfs repair
>>>> doesn't currently handle that case (I tried --repair as I'm
>>>> having a backup). I simply decided not to investigate that
>>>> further at that point but delete and restore the affected file
>>>> from backup. However, this is the message from dmesg (tho, I
>>>> didn't catch the backtrace):
>>>>
>>>> btrfs_run_delayed_refs:2927: errno=-17 Object already exists
>>>
>>> That's nice, at least we have some clue.
>>>
>>> It's almost sure, it's a bug either in btrfs kernel which doesn't
>>> handle delayed refs well(low possibility), or, corrupted fs which
>>> create something kernel can't handle(I bet that's the case).
>>
>> [kernel 4.5.0 gentoo, btrfs-progs 4.4.1]
>>
>> Well, this time it hit me on the USB backup drive which uses no bcache
>> and no other fancy options except compress-force=zlib. Apparently,
>> I've only got a (real) screenshot which I'm going to link here:
>>
>> https://www.dropbox.com/s/9qbc7np23y8lrii/IMG_20160326_200033.jpg?dl=0
>>
>> The same drive has no problems except "bad metadata crossing stripe
>> boundary" - but a lot of them. This drive was never converted, it was
>> freshly generated several months ago.
>> [...]
>
> I finally got copy&paste data:
>
> # before mounting let's check the FS:
>
> $ sudo btrfsck /dev/disk/by-label/usb-backup
> Checking filesystem on /dev/disk/by-label/usb-backup
> UUID: 1318ec21-c421-4e36-a44a-7be3d41f9c3f
> checking extents
> bad metadata [156041216, 156057600) crossing stripe boundary
> bad metadata [181403648, 181420032) crossing stripe boundary
> bad metadata [392167424, 392183808) crossing stripe boundary
> bad metadata [783482880, 783499264) crossing stripe boundary
> bad metadata [784924672, 784941056) crossing stripe boundary
> bad metadata [130151612416, 130151628800) crossing stripe boundary
> bad metadata [162826813440, 162826829824) crossing stripe boundary
> bad metadata [162927083520, 162927099904) crossing stripe boundary
> bad metadata [619740659712, 619740676096) crossing stripe boundary
> bad metadata [619781947392, 619781963776) crossing stripe boundary
> bad metadata [619795644416, 619795660800) crossing stripe boundary
> bad metadata [619816091648, 619816108032) crossing stripe boundary
> bad metadata [620011388928, 620011405312) crossing stripe boundary
> bad metadata [890992459776, 890992476160) crossing stripe boundary
> bad metadata [891022737408, 891022753792) crossing stripe boundary
> bad metadata [891101773824, 891101790208) crossing stripe boundary
> bad metadata [891301199872, 891301216256) crossing stripe boundary
> bad metadata [1012219314176, 1012219330560) crossing stripe boundary
> bad metadata [1017202409472, 1017202425856) crossing stripe boundary
> bad metadata [1017365397504, 1017365413888) crossing stripe boundary
> bad metadata [1020764422144, 1020764438528) crossing stripe boundary
> bad metadata [1251103342592, 1251103358976) crossing stripe boundary
> bad metadata [1251144695808, 1251144712192) crossing stripe boundary
> bad metadata [1251147055104, 1251147071488) crossing stripe boundary
> bad metadata [1259271225344, 1259271241728) crossing stripe boundary
> bad metadata [1266223611904, 1266223628288) crossing stripe boundary
> bad metadata [1304750063616, 1304750080000) crossing stripe boundary
> bad metadata [1304790106112, 1304790122496) crossing stripe boundary
> bad metadata [1304850792448, 1304850808832) crossing stripe boundary
> bad metadata [1304869928960, 1304869945344) crossing stripe boundary
> bad metadata [1305089540096, 1305089556480) crossing stripe boundary
> bad metadata [1309561651200, 1309561667584) crossing stripe boundary
> bad metadata [1309581443072, 1309581459456) crossing stripe boundary
> bad metadata [1309583671296, 1309583687680) crossing stripe boundary
> bad metadata [1309942808576, 1309942824960) crossing stripe boundary
> bad metadata [1310050549760, 1310050566144) crossing stripe boundary
> bad metadata [1313031585792, 1313031602176) crossing stripe boundary
> bad metadata [1313232912384, 1313232928768) crossing stripe boundary
> bad metadata [1555210764288, 1555210780672) crossing stripe boundary
> bad metadata [1555395182592, 1555395198976) crossing stripe boundary
> bad metadata [2050576744448, 2050576760832) crossing stripe boundary
> bad metadata [2050803957760, 2050803974144) crossing stripe boundary
> bad metadata [2050969108480, 2050969124864) crossing stripe boundary

Already mentioned in another reply, this *seems* to be false alert.
Latest btrfs-progs would help.

> checking free space tree cache and super generation don't match, space
> cache will be invalidated checking fs roots
Err, I found a missing '\n' before "checking fs roots".

And it seems that fs roots and extent tree are all OK.

Quite surprising.
The only possible problem seems to be outdated space cache.

Maybe mount with "-o clear_cache" will help, but I don't think that's 
the cause.


> checking csums
> checking root refs
> found 1860217443214 bytes used err is 0
> total csum bytes: 1805105116
> total tree bytes: 11793776640
> total fs tree bytes: 8220835840
> total extent tree bytes: 1443315712
> btree space waste bytes: 2307850845
> file data blocks allocated: 2137151094784
>   referenced 2706830905344
>
> # now let's wait for the backup to mount the FS and look at dmesg:
>
> [21375.606479] BTRFS info (device sde1): force zlib compression
> [21375.606483] BTRFS info (device sde1): using free space tree

Thanks to Chris Murphy, I almost ignored such line.
Not familiar with the new free space cache tree, sorry.

If "clear_cache" doesn't help, then try "nospace_cache" to disable the 
entire space cache.


> [21375.606485] BTRFS: has skinny extents
> [21383.710725] BTRFS: checking UUID tree
> [21388.531267] ------------[ cut here ]------------
> [21388.531279] WARNING: CPU: 0 PID: 27085 at
> fs/btrfs/extent-tree.c:2946 btrfs_run_delayed_refs+0x279/0x2b0()
> [21388.531281] BTRFS: Transaction aborted (error -17) [21388.531282]
> Modules linked in: nvidia_drm(PO) uas usb_storage vboxnetadp(O)
> vboxnetflt(O) vboxdrv(O) nvidia_modeset(PO) nvidia(PO) [21388.531293]
> CPU: 0 PID: 27085 Comm: kworker/u8:3 Tainted: P           O
> 4.5.0-gentoo #1 [21388.531295] Hardware name: To Be Filled By O.E.M. To
> Be Filled By O.E.M./Z68 Pro3, BIOS L2.16A 02/22/2013 [21388.531300]
> Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [21388.531302]
> 0000000000000000 ffffffff8159eaa9 ffff88029d723d68 ffffffff81ea1cf6
> [21388.531306]  ffffffff810c6e37 ffff880407be5960 ffff88029d723db8
> 0000000000000020 [21388.531308]  ffff8802bd886510 ffff8803cc846d00
> ffffffff810c6eb7 ffffffff81e8a088 [21388.531311] Call Trace:
> [21388.531317]  [<ffffffff8159eaa9>] ? dump_stack+0x46/0x5d
> [21388.531322]  [<ffffffff810c6e37>] ? warn_slowpath_common+0x77/0xb0
> [21388.531326]  [<ffffffff810c6eb7>] ? warn_slowpath_fmt+0x47/0x50
> [21388.531329]  [<ffffffff814923d9>] ?
> btrfs_run_delayed_refs+0x279/0x2b0 [21388.531332]
> [<ffffffff8149243d>] ? delayed_ref_async_start+0x2d/0x70
> [21388.531337]  [<ffffffff810da8c3>] ? process_one_work+0x133/0x350
> [21388.531340]  [<ffffffff810dae25>] ? worker_thread+0x45/0x450
> [21388.531343]  [<ffffffff810dade0>] ? rescuer_thread+0x300/0x300
> [21388.531347]  [<ffffffff810df3f8>] ? kthread+0xb8/0xd0
> [21388.531350]  [<ffffffff810e301f>] ? finish_task_switch+0x6f/0x1f0
> [21388.531352]  [<ffffffff810df340>] ? kthread_park+0x50/0x50
> [21388.531356]  [<ffffffff81bdb31f>] ? ret_from_fork+0x3f/0x70
> [21388.531359]  [<ffffffff810df340>] ? kthread_park+0x50/0x50
> [21388.531361] ---[ end trace 69a4c78997ef63b2 ]--- [21388.531364]
> BTRFS: error (device sde1) in btrfs_run_delayed_refs:2946: errno=-17
> Object already exists [21388.531367] BTRFS info (device sde1): forced
> readonly
>
> This FS has been okay just a few reboots earlier (except the stripe
> boundary thing).
>
> History of kernel versions used on the system (back to the date when I
> think the FS was still clean/not corrupted):
>
>       Wed Aug  5 08:12:01 2015 >>> sys-kernel/gentoo-sources-4.1.4
>       Sat Aug 15 19:04:34 2015 >>> sys-kernel/gentoo-sources-4.1.5
>       Sat Aug 22 11:10:53 2015 >>> sys-kernel/gentoo-sources-4.1.6
>       Tue Sep  1 00:03:38 2015 >>> sys-kernel/gentoo-sources-4.2.0
>       Sat Sep  5 17:45:11 2015 >>> sys-kernel/gentoo-sources-4.2.0-r1
>       Wed Sep 30 04:55:55 2015 >>> sys-kernel/gentoo-sources-4.2.2
>       Tue Oct  6 22:55:19 2015 >>> sys-kernel/gentoo-sources-4.2.3
>       Sun Oct 25 03:45:03 2015 >>> sys-kernel/gentoo-sources-4.2.4
>       Wed Nov  4 04:21:38 2015 >>> sys-kernel/gentoo-sources-4.2.5
>       Mon Nov  9 21:36:31 2015 >>> sys-kernel/gentoo-sources-4.3.0
>       Sat Nov 14 10:48:03 2015 >>> sys-kernel/gentoo-sources-4.2.6
>       Sun Dec 13 13:03:12 2015 >>> sys-kernel/gentoo-sources-4.2.7
>       Tue Dec 15 22:37:53 2015 >>> sys-kernel/gentoo-sources-4.2.8
>       Tue Dec 22 14:37:01 2015 >>> sys-kernel/gentoo-sources-4.3.3
>       Fri Jan 22 20:38:32 2016 >>> sys-kernel/gentoo-sources-4.3.3-r1
>       Wed Jan 27 09:27:57 2016 >>> sys-kernel/gentoo-sources-4.3.4
>       Sun Jan 31 10:25:00 2016 >>> sys-kernel/gentoo-sources-4.4.0-r1
>       Mon Feb  1 20:40:17 2016 >>> sys-kernel/gentoo-sources-4.4.1
>       Fri Feb 19 22:11:45 2016 >>> sys-kernel/gentoo-sources-4.4.2
>       Sat Feb 27 15:10:45 2016 >>> sys-kernel/gentoo-sources-4.4.3
>       Sun Mar  6 14:58:05 2016 >>> sys-kernel/gentoo-sources-4.4.4
>       Sat Mar 12 19:21:15 2016 >>> sys-kernel/gentoo-sources-4.4.5
>       Sat Mar 19 06:13:09 2016 >>> sys-kernel/gentoo-sources-4.4.6
>       Sun Mar 20 20:45:21 2016 >>> sys-kernel/gentoo-sources-4.5.0
>
> I only saw unreliable behavior with 4.4.5, 4.4.6, and 4.5.0 tho the
> problem may exist longer in my FS.
>
> $ sudo btrfs-show-super /dev/sde1
> superblock: bytenr=65536, device=/dev/sde1
> ---------------------------------------------------------
> csum                    0xcc976d97 [match]
> bytenr                  65536
> flags                   0x1
>                          ( WRITTEN )
> magic                   _BHRfS_M [match]
> fsid                    1318ec21-c421-4e36-a44a-7be3d41f9c3f
> label                   usb-backup
> generation              50814
> root                    1251250159616
> sys_array_size          129
> chunk_root_generation   50784
> root_level              1
> chunk_root              2516518567936
> chunk_root_level        1
> log_root                0
> log_root_transid        0
> log_root_level          0
> total_bytes             2000397864960
> bytes_used              1860398493696
> sectorsize              4096
> nodesize                16384
> leafsize                16384
> stripesize              4096
> root_dir                6
> num_devices             1
> compat_flags            0x0
> compat_ro_flags         0x1

OK, you're using the new free space cache tree option, update 
btrfs-progs to latest version will help further debugging.

> incompat_flags          0x169
>                          ( MIXED_BACKREF |
>                            COMPRESS_LZO |
>                            BIG_METADATA |
>                            EXTENDED_IREF |
>                            SKINNY_METADATA )
> csum_type               0
> csum_size               4
> cache_generation        50208
> uuid_tree_generation    50742
> dev_item.uuid           9008d5a0-ac7b-4505-8193-27428429f953
> dev_item.fsid           1318ec21-c421-4e36-a44a-7be3d41f9c3f [match]
> dev_item.type           0
> dev_item.total_bytes    2000397864960
> dev_item.bytes_used     1912308039680
> dev_item.io_align       4096
> dev_item.io_width       4096
> dev_item.sector_size    4096
> dev_item.devid          1
> dev_item.dev_group      0
> dev_item.seek_speed     0
> dev_item.bandwidth      0
> dev_item.generation     0
>
>
>
> BTW: btrfsck thinks that the space tree is invalid every time it is
> run, no matter if cleanly unmounted, uncleanly unmounted, or "btrfsck
> --repair" and then ran a second time.
>
Because your btrfs-progs is too old to understand the new free space 
cache tree.

Thanks,
Qu
