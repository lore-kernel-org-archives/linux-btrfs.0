Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36191 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753580AbdFSKnR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Jun 2017 06:43:17 -0400
Received: by mail-io0-f169.google.com with SMTP id y77so61721021ioe.3
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jun 2017 03:43:17 -0700 (PDT)
MIME-Version: 1.0
From: Jesse <btrfs_mail_list@mymail.isbest.biz>
Date: Mon, 19 Jun 2017 18:43:16 +0800
Message-ID: <CAAsnU-9FqoT=gFFsJ7paCRgkXXfJJts9K+E-5_cca33yOUJc+w@mail.gmail.com>
Subject: Re: Please help. Repair probably bitflip damage and suspected bug
To: Jesse <btrfs_mail_list@mymail.isbest.biz>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just noticed a series of seemingly btrfs related call traces that
for the first time, did not lock up the system.

I have uploaded dmesg to https://paste.ee/p/An8Qy

Anyone able to help advise on these?

Thanks

Jesse


On 19 June 2017 at 17:19, Jesse <btrfs_mail_list@mymail.isbest.biz> wrote:
> Further to the above message reporting problems, I have been able to
> capture a call trace under the main system rather than live media.
>
> Note this occurred in rsync from btrfs to a separate drive running xfs
> on a local filesystem (both sata drives). So I presume that btrfs is
> only reading the drive at the time of crash, unless rsync is also
> doing some sort of disc caching of the files to btrfs as it is the OS
> filesystem.
>
> The destination drive directories being copied to in this case were
> empty, so I was making a copy of the data off of the btrfs drive (due
> to the btrfs tree errors and problems reported in the post I am here
> replying to).
>
> I am suspecting that there is a direct correlation to using rsync
> while (or subsequent to) touching areas of the btrfs tree that have
> corruption which results in a complete system lockup/crash.
>
> I have also noted that when these crashes while running rsync occur,
> the prior x files (eg: 10 files) show in the rsync log as being
> synced, however, show on the destination drive with filesize of zero.
>
> The trace (/var/log/messages | grep btrfs) I have uploaded to
> https://paste.ee/p/nRcj0
>
> The important part of which is:
>
> Jun 18 23:43:24 Orion vmunix: [38084.183174] BTRFS info (device sda2):
> no csum found for inode 12497 start 0
> Jun 18 23:43:24 Orion vmunix: [38084.183195] BTRFS info (device sda2):
> no csum found for inode 12497 start 0
> Jun 18 23:43:24 Orion vmunix: [38084.183209] BTRFS info (device sda2):
> no csum found for inode 12497 start 0
> Jun 18 23:43:24 Orion vmunix: [38084.183222] BTRFS info (device sda2):
> no csum found for inode 12497 start 0
> Jun 18 23:43:24 Orion vmunix: [38084.217552] BTRFS info (device sda2):
> csum failed ino 12497 extent 1700305813504 csum 1405070872 wanted 0
> mirror 0
> Jun 18 23:43:24 Orion vmunix: [38084.217626] BTRFS info (device sda2):
> no csum found for inode 12497 start 0
> Jun 18 23:43:24 Orion vmunix: [38084.217643] BTRFS info (device sda2):
> no csum found for inode 12497 start 0
> Jun 18 23:43:24 Orion vmunix: [38084.217657] BTRFS info (device sda2):
> no csum found for inode 12497 start 0
> Jun 18 23:43:24 Orion vmunix: [38084.217669] BTRFS info (device sda2):
> no csum found for inode 12497 start 0
> Jun 18 23:43:24 Orion vmunix:  auth_rpcgss nfs_acl nfs lockd grace
> sunrpc fscache zfs(POE) zunicode(POE) zcommon(POE) znvpair(POE)
> spl(OE) zavl(POE) btrfs xor raid6_pq dm_mirror dm_region_hash dm_log
> hid_generic usbhid hid uas usb_storage radeon i2c_algo_bit ttm
> drm_kms_helper drm r8169 ahci mii libahci wmi
> Jun 18 23:43:24 Orion vmunix: [38084.220604] Workqueue: btrfs-endio
> btrfs_endio_helper [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.220812] RIP:
> 0010:[<ffffffffc048804a>]  [<ffffffffc048804a>]
> __btrfs_map_block+0x32a/0x1180 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.222459]  [<ffffffffc0452c00>] ?
> __btrfs_lookup_bio_sums.isra.8+0x3e0/0x540 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.222632]  [<ffffffffc048cf3d>]
> btrfs_map_bio+0x7d/0x2b0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.222781]  [<ffffffffc04aaf64>]
> btrfs_submit_compressed_read+0x484/0x4e0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.222948]  [<ffffffffc04651e1>]
> btrfs_submit_bio_hook+0x1c1/0x1d0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.223198]  [<ffffffffc047fd90>] ?
> btrfs_create_repair_bio+0xf0/0x110 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.223360]  [<ffffffffc047fec7>]
> bio_readpage_error+0x117/0x180 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.223514]  [<ffffffffc04802f0>] ?
> clean_io_failure+0x1b0/0x1b0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.223667]  [<ffffffffc04806ae>]
> end_bio_extent_readpage+0x3be/0x3f0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.223996]  [<ffffffffc0457838>]
> end_workqueue_fn+0x48/0x60 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.224145]  [<ffffffffc0490de2>]
> normal_work_helper+0x82/0x210 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.224297]  [<ffffffffc0491042>]
> btrfs_endio_helper+0x12/0x20 [btrfs]
> Jun 18 23:43:24 Orion vmunix:  auth_rpcgss nfs_acl nfs lockd grace
> sunrpc fscache zfs(POE) zunicode(POE) zcommon(POE) znvpair(POE)
> spl(OE) zavl(POE) btrfs xor raid6_pq dm_mirror dm_region_hash dm_log
> hid_generic usbhid hid uas usb_storage radeon i2c_algo_bit ttm
> drm_kms_helper drm r8169 ahci mii libahci wmi
> Jun 18 23:43:24 Orion vmunix: [38084.330053]  [<ffffffffc048804a>] ?
> __btrfs_map_block+0x32a/0x1180 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.330106]  [<ffffffffc0487fec>] ?
> __btrfs_map_block+0x2cc/0x1180 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.330154]  [<ffffffffc0452c00>] ?
> __btrfs_lookup_bio_sums.isra.8+0x3e0/0x540 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.330205]  [<ffffffffc048cf3d>]
> btrfs_map_bio+0x7d/0x2b0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.330257]  [<ffffffffc04aaf64>]
> btrfs_submit_compressed_read+0x484/0x4e0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.330304]  [<ffffffffc04651e1>]
> btrfs_submit_bio_hook+0x1c1/0x1d0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.330361]  [<ffffffffc047fd90>] ?
> btrfs_create_repair_bio+0xf0/0x110 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.330412]  [<ffffffffc047fec7>]
> bio_readpage_error+0x117/0x180 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.330462]  [<ffffffffc04802f0>] ?
> clean_io_failure+0x1b0/0x1b0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.330513]  [<ffffffffc04806ae>]
> end_bio_extent_readpage+0x3be/0x3f0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.330568]  [<ffffffffc0457838>]
> end_workqueue_fn+0x48/0x60 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.330618]  [<ffffffffc0490de2>]
> normal_work_helper+0x82/0x210 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.330668]  [<ffffffffc0491042>]
> btrfs_endio_helper+0x12/0x20 [btrfs]
> Jun 18 23:43:24 Orion vmunix:  auth_rpcgss nfs_acl nfs lockd grace
> sunrpc fscache zfs(POE) zunicode(POE) zcommon(POE) znvpair(POE)
> spl(OE) zavl(POE) btrfs xor raid6_pq dm_mirror dm_region_hash dm_log
> hid_generic usbhid hid uas usb_storage radeon i2c_algo_bit ttm
> drm_kms_helper drm r8169 ahci mii libahci wmi
> Jun 18 23:43:24 Orion vmunix: [38084.331102]  [<ffffffffc048804a>] ?
> __btrfs_map_block+0x32a/0x1180 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.331152]  [<ffffffffc0487fec>] ?
> __btrfs_map_block+0x2cc/0x1180 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.331202]  [<ffffffffc0452c00>] ?
> __btrfs_lookup_bio_sums.isra.8+0x3e0/0x540 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.331255]  [<ffffffffc048cf3d>]
> btrfs_map_bio+0x7d/0x2b0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.331310]  [<ffffffffc04aaf64>]
> btrfs_submit_compressed_read+0x484/0x4e0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.331360]  [<ffffffffc04651e1>]
> btrfs_submit_bio_hook+0x1c1/0x1d0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.331423]  [<ffffffffc047fd90>] ?
> btrfs_create_repair_bio+0xf0/0x110 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.331477]  [<ffffffffc047fec7>]
> bio_readpage_error+0x117/0x180 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.331530]  [<ffffffffc04802f0>] ?
> clean_io_failure+0x1b0/0x1b0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.331585]  [<ffffffffc04806ae>]
> end_bio_extent_readpage+0x3be/0x3f0 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.331649]  [<ffffffffc0457838>]
> end_workqueue_fn+0x48/0x60 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.331703]  [<ffffffffc0490de2>]
> normal_work_helper+0x82/0x210 [btrfs]
> Jun 18 23:43:24 Orion vmunix: [38084.331757]  [<ffffffffc0491042>]
> btrfs_endio_helper+0x12/0x20 [btrfs]
> Jun 19 07:29:22 Orion vmunix: [    3.107113] Btrfs loaded
> Jun 19 07:29:22 Orion vmunix: [    3.665536] BTRFS: device label
> btrfs1 devid 2 transid 1086759 /dev/sdb2
> Jun 19 07:29:22 Orion vmunix: [    3.665811] BTRFS: device label
> btrfs1 devid 1 transid 1086759 /dev/sda2
> Jun 19 07:29:22 Orion vmunix: [    8.673689] BTRFS info (device sda2):
> disk space caching is enabled
> Jun 19 07:29:22 Orion vmunix: [   28.190962] BTRFS info (device sda2):
> enabling auto defrag
> Jun 19 07:29:22 Orion vmunix: [   28.191039] BTRFS info (device sda2):
> disk space caching is enabled
>
> I notice that this page
> https://btrfs.wiki.kernel.org/index.php/Gotchas mentions "Files with a
> lot of random writes can become heavily fragmented (10000+ extents)
> causing thrashing on HDDs and excessive multi-second spikes" and as
> such I am wondering if this is related to the crashing. AFAIK rsync
> should be creating the temp file in the destination drive (xfs),
> unless there is some part of rsync that I am not understanding that
> would be writing to the file system drive (btrfs)  which is also in
> the case the source hdd (btrfs).
>
> Can someone please help with these btrfs problems.
>
> Thankyou
>
>
>
>> My Linux Mint system is starting up and usable, however, I am unable
>> to complete any scrub as they abort before finished. There are various
>> inode errors in dmesg. Badblocks (readonly) finds no errors. checking
>> extents gives bad block 5123372711936 on both /dev/sda2 and /dev/sda2.
>> A btrfscheck (readonly) results in a 306MB text file of output of root
>> xxx inode errors.
>> There are two drives 3TB each in RAID 1 for sda2/sdb2 for which
>> partition 2 is nearly the entire drive.
>>
>> Currently I am now using a Manjaro Live Boot with btrfs tools
>> btrfs-progs v4.10.1 in an attempt to recover/repair what seems to be
>> bitflip
>> (The original Linux Mint System has btrfs-progs v4.5.3)
>>
>> When doing a scrub on '/', the status of /dev/sdb2 aborts always at ~
>> 383GiB with 0 errors. Whereas the /dev/sda2 and thus the '/' scrub
>> aborts at more diverse values starting at 537.90GiB with 0 errors.
>>
>> btrfs inspect-internal dump-tree -b 5123372711936 has one item
>> evidently out of order:
>> 2551224532992 -> 2551253647360 -> 2551251468288
>>
>> I am currently attempting to copy files off the system while in
>> Manjaro using rsync prior to attempting whatever the knowlegable
>> people here recommend. It has resulting in two files not being able to
>> be read so far, however, a lot of messages in dmesg for btrfs errors
>> https://ptpb.pw/L9Z9
>>
>> Pastebins from original machine:
>> System specs as on original Linux Mint system: https://ptpb.pw/dFz3
>> dmesg btrfs grep from prior to errors starting until scrub attempts:
>> https://ptpb.pw/rTzs
>>
>> Pastebins from subsequent live boot with newer btrfs tools 4.10:
>> LiveBoot Repair (Manjaro Arch) specs: https://ptpb.pw/ikMM
>> Scrub failing/aborting at same place on /dev/sdb: https://ptpb.pw/-vcP
>> badblock_extent_btrfscheck_5123372711936: https://ptpb.pw/T1rD
>> 'btrfs inspect-internal dump-tree -b 5123372711936 /dev/sda2':
>> https://ptpb.pw/zcyI
>> 'btrfs inspect-internal dump-tree -b 5123372711936 /dev/sdb2':
>> https://ptpb.pw/zcyI
>> dmesg on Manjaro attempting to rsync recover files: https://ptpb.pw/L9Z9
>>
>> I have also just noticed that btrfs causes a complete system crash
>> when copying a certain file(s).
>>
>> RTP: [<ffffffffa055b122>] btrfs_check_repairable+0xf2/0x100 [btrfs]
>> BUG: unable to handle kernel paging request at 000000000dealc93
>> IP: [<ffffffff810c3e0b>] __wake_up _common+0x2b/0x80
>> I have taken a photo of the last part of this. As it is in the live
>> DVD boot distro during repair, it did not save the trace to a file
>> that would be accessible later.
>> The photo is at https://pasteboard.co/MTP2OGMK.jpg
>>
>> Could someone please advise the steps to repair this.
>>
>> Thankyou
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
