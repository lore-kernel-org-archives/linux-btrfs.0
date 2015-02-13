Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:38043 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbBMVyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 16:54:45 -0500
Received: by lamq1 with SMTP id q1so18966406lam.5
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 13:54:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGwxe4hBcg2nHDCs8O=bT=2DkqtNzTTJJv0H_NNAK-fCOaaAJg@mail.gmail.com>
References: <CAGwxe4gXPEOTPfNc2=0E0HAfDfTRKRcqqPjVJimbWJr5riz4DA@mail.gmail.com>
 <CAGwxe4gp5O3yRZt=s8ppqyfap0rZmzwSseA709X-C5kkQkODUw@mail.gmail.com>
 <20150212091603.GE2416@localhost.localdomain> <CAGwxe4ji5sDBfm89iJMnF3dKOBKft2up-FZTzQxd0yvqLaV2iA@mail.gmail.com>
 <20150213080600.GD25697@localhost.localdomain> <CAGwxe4hBcg2nHDCs8O=bT=2DkqtNzTTJJv0H_NNAK-fCOaaAJg@mail.gmail.com>
From: Tobias Holst <tobby@tobby.eu>
Date: Fri, 13 Feb 2015 22:54:22 +0100
Message-ID: <CAGwxe4ju4trKoXPD=DpazTUMsvGH9zNs_6jN+2srY3h1t_zwiA@mail.gmail.com>
Subject: Re: Repair broken btrfs raid6?
To: bo.li.liu@oracle.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's me again. I just found out why my system crashed during the back up.

I don't know what it means, but maybe it helps you?

WARNING: CPU: 7 PID: 22878 at
/home/kernel/COD/linux/fs/btrfs/extent_io.c:5203
read_extent_buffer+0xe3/0x120 [btrfs]()
Modules linked in: raid0(E) ufs(E) qnx4(E) hfsplus(E) hfs(E) minix(E)
ntfs(E) msdos(E) jfs(E) xfs(E) libcrc32c(E) btrfs(E) xor(E)
raid6_pq(E) iosf_mbi(E) dm_crypt(E) kvm_intel(E) kvm(E)
crct10dif_pclmul(E) ppdev(E) crc32_pclmul(E) ghash_clmulni_intel(E)
aesni_intel(E) aes_x86_64(E) virtio_rng(E) lrw(E) gf128mul(E)
glue_helper(E) ablk_helper(E) cryptd(E) serio_raw(E) 8250_fintek(E)
parport_pc(E) pvpanic(E) i2c_piix4(E) mac_hid(E) lp(E) parport(E)
cirrus(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) mpt2sas(E) ttm(E)
drm_kms_helper(E) raid_class(E) floppy(E) psmouse(E)
scsi_transport_sas(E) drm(E)
 [<ffffffffc05089f3>] read_extent_buffer+0xe3/0x120 [btrfs]
 [<ffffffffc04d7dde>] __btrfs_lookup_bio_sums.isra.8+0x2ce/0x540 [btrfs]
 [<ffffffffc04d82a6>] btrfs_lookup_bio_sums+0x36/0x40 [btrfs]
 [<ffffffffc05301e6>] btrfs_submit_compressed_read+0x316/0x4e0 [btrfs]
 [<ffffffffc04ea031>] btrfs_submit_bio_hook+0x1c1/0x1d0 [btrfs]
 [<ffffffffc05010ca>] submit_one_bio+0x6a/0xa0 [btrfs]
 [<ffffffffc0504958>] submit_extent_page.isra.34+0xe8/0x210 [btrfs]
 [<ffffffffc0506087>] __do_readpage+0x3f7/0x640 [btrfs]
 [<ffffffffc05057a0>] ? clean_io_failure+0x1b0/0x1b0 [btrfs]
 [<ffffffffc04eb400>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
 [<ffffffffc0506606>] __extent_readpages.constprop.45+0x266/0x290 [btrfs]
 [<ffffffffc04eb400>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
 [<ffffffffc050734e>] extent_readpages+0x15e/0x1a0 [btrfs]
 [<ffffffffc04eb400>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
 [<ffffffffc04e771f>] btrfs_readpages+0x1f/0x30 [btrfs]
 [<ffffffffc04dc969>] ? btrfs_congested_fn+0x49/0xb0 [btrfs]
 hfs(E) minix(E) ntfs(E) msdos(E) jfs(E) xfs(E) libcrc32c(E) btrfs(E)
xor(E) raid6_pq(E) iosf_mbi(E) dm_crypt(E) kvm_intel(E) kvm(E)
crct10dif_pclmul(E) ppdev(E) crc32_pclmul(E)
 [<ffffffffc05089ca>] ? read_extent_buffer+0xba/0x120 [btrfs]
 [<ffffffffc04d7dde>] __btrfs_lookup_bio_sums.isra.8+0x2ce/0x540 [btrfs]
 [<ffffffffc04d82a6>] btrfs_lookup_bio_sums+0x36/0x40 [btrfs]
 [<ffffffffc05301e6>] btrfs_submit_compressed_read+0x316/0x4e0 [btrfs]
 [<ffffffffc04ea031>] btrfs_submit_bio_hook+0x1c1/0x1d0 [btrfs]
 [<ffffffffc05010ca>] submit_one_bio+0x6a/0xa0 [btrfs]
 [<ffffffffc0504958>] submit_extent_page.isra.34+0xe8/0x210 [btrfs]
 [<ffffffffc0506087>] __do_readpage+0x3f7/0x640 [btrfs]
 [<ffffffffc05057a0>] ? clean_io_failure+0x1b0/0x1b0 [btrfs]
 [<ffffffffc04eb400>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
 [<ffffffffc0506606>] __extent_readpages.constprop.45+0x266/0x290 [btrfs]
 [<ffffffffc04eb400>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
 [<ffffffffc050734e>] extent_readpages+0x15e/0x1a0 [btrfs]
 [<ffffffffc04eb400>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
 [<ffffffffc04e771f>] btrfs_readpages+0x1f/0x30 [btrfs]
 [<ffffffffc04dc969>] ? btrfs_congested_fn+0x49/0xb0 [btrfs]
Modules linked in: raid0(E) ufs(E) qnx4(E) hfsplus(E) hfs(E) minix(E)
ntfs(E) msdos(E) jfs(E) xfs(E) libcrc32c(E) btrfs(E)
 [<ffffffffc05089ca>] ? read_extent_buffer+0xba/0x120 [btrfs]
 [<ffffffffc04d7dde>] __btrfs_lookup_bio_sums.isra.8+0x2ce/0x540 [btrfs]
 [<ffffffffc04d82a6>] btrfs_lookup_bio_sums+0x36/0x40 [btrfs]
 [<ffffffffc05301e6>] btrfs_submit_compressed_read+0x316/0x4e0 [btrfs]
 [<ffffffffc04ea031>] btrfs_submit_bio_hook+0x1c1/0x1d0 [btrfs]
 [<ffffffffc05010ca>] submit_one_bio+0x6a/0xa0 [btrfs]
 [<ffffffffc0504958>] submit_extent_page.isra.34+0xe8/0x210 [btrfs]
 [<ffffffffc0506087>] __do_readpage+0x3f7/0x640 [btrfs]
 [<ffffffffc05057a0>] ? clean_io_failure+0x1b0/0x1b0 [btrfs]
 [<ffffffffc04eb400>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
 [<ffffffffc0506606>] __extent_readpages.constprop.45+0x266/0x290 [btrfs]
 [<ffffffffc04eb400>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
 [<ffffffffc050734e>] extent_readpages+0x15e/0x1a0 [btrfs]
 [<ffffffffc04eb400>] ? btrfs_submit_direct+0x1b0/0x1b0 [btrfs]
 [<ffffffffc04e771f>] btrfs_readpages+0x1f/0x30 [btrfs]
 [<ffffffffc04dc969>] ? btrfs_congested_fn+0x49/0xb0 [btrfs]

Regards,
Tobias


2015-02-13 19:26 GMT+01:00 Tobias Holst <tobby@tobby.eu>:
> 2015-02-13 9:06 GMT+01:00 Liu Bo <bo.li.liu@oracle.com>:
>> On Fri, Feb 13, 2015 at 12:22:16AM +0100, Tobias Holst wrote:
>>> Hi
>>>
>>> I don't remember the exact mkfs.btrfs options anymore but
>>> > ls /sys/fs/btrfs/[UUID]/features/
>>> shows the following output:
>>> > big_metadata  compress_lzo  extended_iref  mixed_backref  raid56
>>
>> Well... mkfs.btrfs can specify a '-m' for metadata profile and a '-d'
>> for data profile, the default profile for metadata is RAID1,
>> so we're not sure if your metadata is RAID1 or RAID6, if raid1 and both
>> copies are corrupted, then please use your backup.
>
> Ah, I used RAID6 for both, so "btrfs fi df /[mountpoint]" looks like this:
> Data, RAID6: total=13.11TiB, used=13.10TiB
> System, RAID6: total=64.00MiB, used=928.00KiB
> Metadata, RAID6: total=25.00GiB, used=23.29GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
>>>
>>> I also tested my device with a short
>>> > hdparm -tT /dev/dm5
>>> and got
>>> > /dev/mapper/sdc_crypt:
>>> >  Timing cached reads:   30712 MB in  2.00 seconds = 15376.11 MB/sec
>>> >  Timing buffered disk reads: 444 MB in  3.01 seconds = 147.51 MB/sec
>>>
>>> Looks ok to me. Should I test more?
>>
>> Okay, looks good.
>>
>>>
>>> I bought a few new hard drives so currently I am copying all my data
>>> to a second (faster) backup, so I can maybe overwrite the current file
>>> system, if it's not repairable.
>>
>> Another question, have you tried "mount -o recovery", did it work?
>
> Yes and no. At the moment I mounted it with
> "defaults,recovery,ro,compress-force=lzo,nospace_cache,clear_cache". I
> am still getting some errors in the syslog, but less than before. Also
> it doesn't get unreadable after a while like before. But it seems to
> be a little bit slow sometimes and two times the whole system freezed
> until I did a hard reset.
>
>>
>> Thanks,
>>
>> -liubo
>>>
>>> Regards,
>>> Tobias
>>>
>>>
>>> 2015-02-12 10:16 GMT+01:00 Liu Bo <bo.li.liu@oracle.com>:
>>> > On Wed, Feb 11, 2015 at 03:46:33PM +0100, Tobias Holst wrote:
>>> >> Hmm, it looks like it is getting worse... Here are some parts of my
>>> >> syslog, including two crashed btrfs-threads:
>>> >>
>>> >> So I am still getting many of these:
>>> >> > BTRFS (device dm-5): parent transid verify failed on 25033166798848 wanted 108976 found 108958
>>> >> > BTRFS warning (device dm-5): page private not zero on page 25033166798848
>>> >> > BTRFS warning (device dm-5): page private not zero on page 25033166802944
>>> >> > BTRFS warning (device dm-5): page private not zero on page 25033166807040
>>> >> > BTRFS warning (device dm-5): page private not zero on page 25033166811136
>>> >
>>> > First we probably make sure that your device is well setup, since these
>>> > messages usually occur after a drive is removed(the device is somehow droping
>>> > writes), the below -EIO also implies btrfs cannot read/write data from or to that drive.
>>> >
>>> > And in theory, RAID6 can tolerate two drive failures, so what's your mkfs.btrfs option?
>>> >
>>> > Thanks,
>>> >
>>> > -liubo
>>> >
>>> >> > BTRFS info (device dm-5): force lzo compression
>>> >> > BTRFS info (device dm-5): disk space caching is enabled
>>> >> > BTRFS: dm-5 checksum verify failed on 30525304061952 wanted 55270A94 found B18E3934 level 0
>>> >> > BTRFS: dm-5 checksum verify failed on 30525304061952 wanted 55270A94 found B18E3934 level 0
>>> >> > BTRFS: dm-5 checksum verify failed on 30525304061952 wanted 55270A94 found B18E3934 level 0
>>> >> > BTRFS: dm-5 checksum verify failed on 30525304061952 wanted 55270A94 found B18E3934 level 0
>>> >> > BTRFS: dm-5 checksum verify failed on 30525304061952 wanted 55270A94 found B18E3934 level 0
>>> >> > BTRFS: dm-5 checksum verify failed on 30525304061952 wanted 55270A94 found B18E3934 level 0
>>> >>
>>> >> Then there is this crash of "super"/btrfs_abort_transaction:
>>> >> > ------------[ cut here ]------------
>>> >> > WARNING: CPU: 0 PID: 30526 at /home/kernel/COD/linux/fs/btrfs/super.c:260 __btrfs_abort_transaction+0x5f/0x140 [btrfs]()
>>> >> > BTRFS: Transaction aborted (error -5)
>>> >> > Modules linked in: ufs(E) qnx4(E) hfsplus(E) hfs(E) minix(E) ntfs(E) msdos(E) jfs(E) xfs(E) libcrc32c(E) btrfs(E) xor(E) raid6_pq(E) iosf_mbi(E) dm_crypt(E) kvm_intel(E) kvm(E) crct10dif_pclmul(E) crc32_pclmul(E) ppdev(E) ghash_clmulni_intel(E) aesni_intel(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) ablk_helper(E) cryptd(E) 8250_fintek(E) serio_raw(E) virtio_rng(E) parport_pc(E) mac_hid(E) pvpanic(E) i2c_piix4(E) lp(E) parport(E) cirrus(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) ttm(E) mpt2sas(E) drm_kms_helper(E) raid_class(E) floppy(E) psmouse(E) drm(E) scsi_transport_sas(E)
>>> >> > CPU: 0 PID: 30526 Comm: kworker/u16:6 Tainted: G        W   E  3.19.0-031900-generic #201502091451
>>> >> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
>>> >> > Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
>>> >> > 0000000000000104 ffff880002743c18 ffffffff817c4c00 0000000000000007
>>> >> > ffff880002743c68 ffff880002743c58 ffffffff81076e87 ffff880002743c58
>>> >> > ffff88020a8694d0 ffff8801fb715800 00000000fffffffb 0000000000000ae8
>>> >> > Call Trace:
>>> >> > [<ffffffff817c4c00>] dump_stack+0x45/0x57
>>> >> > [<ffffffff81076e87>] warn_slowpath_common+0x97/0xe0
>>> >> > [<ffffffff81076f86>] warn_slowpath_fmt+0x46/0x50
>>> >> > [<ffffffffc06375cf>] __btrfs_abort_transaction+0x5f/0x140 [btrfs]
>>> >> > [<ffffffffc0655105>] btrfs_run_delayed_refs.part.82+0x175/0x290 [btrfs]
>>> >> > [<ffffffffc0655237>] btrfs_run_delayed_refs+0x17/0x20 [btrfs]
>>> >> > [<ffffffffc0655507>] delayed_ref_async_start+0x37/0x90 [btrfs]
>>> >> > [<ffffffffc069720e>] normal_work_helper+0x7e/0x1b0 [btrfs]
>>> >> > [<ffffffffc0697572>] btrfs_extent_refs_helper+0x12/0x20 [btrfs]
>>> >> > [<ffffffff8108f76d>] process_one_work+0x14d/0x460
>>> >> > [<ffffffff8109014b>] worker_thread+0x11b/0x3f0
>>> >> > [<ffffffff81090030>] ? create_worker+0x1e0/0x1e0
>>> >> > [<ffffffff81095d59>] kthread+0xc9/0xe0
>>> >> > [<ffffffff81095c90>] ? flush_kthread_worker+0x90/0x90
>>> >> > [<ffffffff817d1e7c>] ret_from_fork+0x7c/0xb0
>>> >> > [<ffffffff81095c90>] ? flush_kthread_worker+0x90/0x90
>>> >> > ---[ end trace dd65465954546462 ]---
>>> >> > BTRFS: error (device dm-5) in btrfs_run_delayed_refs:2792: errno=-5 IO failure
>>> >> > BTRFS info (device dm-5): forced readonly
>>> >>
>>> >> and this crash of "delayed-ref"/btrfs_select_ref_head:
>>> >> > ------------[ cut here ]------------
>>> >> > WARNING: CPU: 7 PID: 3159 at /home/kernel/COD/linux/fs/btrfs/delayed-ref.c:438 btrfs_select_ref_head+0x120/0x130 [btrfs]()
>>> >> > Modules linked in: ufs(E) qnx4(E) hfsplus(E) hfs(E) minix(E) ntfs(E) msdos(E) jfs(E) xfs(E) libcrc32c(E) btrfs(E) xor(E) raid6_pq(E) iosf_mbi(E) dm_crypt(E) kvm_intel(E) kvm(E) crct10dif_pclmul(E) crc32_pclmul(E) ppdev(E) ghash_clmulni_intel(E) aesni_intel(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) ablk_helper(E) cryptd(E) 8250_fintek(E) serio_raw(E) virtio_rng(E) parport_pc(E) mac_hid(E) pvpanic(E) i2c_piix4(E) lp(E) parport(E) cirrus(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) ttm(E) mpt2sas(E) drm_kms_helper(E) raid_class(E) floppy(E) psmouse(E) drm(E) scsi_transport_sas(E)
>>> >> > CPU: 7 PID: 3159 Comm: btrfs-transacti Tainted: G        W   E  3.19.0-031900-generic #201502091451
>>> >> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
>>> >> > 00000000000001b6 ffff8801cb687c48 ffffffff817c4c00 0000000000000007
>>> >> > 0000000000000000 ffff8801cb687c88 ffffffff81076e87 0000000000000001
>>> >> > ffff8801fe80bf00 0000000000000000 ffff8801fe80bfc8 ffff8802345d8280
>>> >> > Call Trace:
>>> >> > [<ffffffff817c4c00>] dump_stack+0x45/0x57
>>> >> > [<ffffffff81076e87>] warn_slowpath_common+0x97/0xe0
>>> >> > [<ffffffff81076eea>] warn_slowpath_null+0x1a/0x20
>>> >> > [<ffffffffc06b2d40>] btrfs_select_ref_head+0x120/0x130 [btrfs]
>>> >> > [<ffffffffc0652cd1>] __btrfs_run_delayed_refs+0x1e1/0x5f0 [btrfs]
>>> >> > [<ffffffffc0654ffa>] btrfs_run_delayed_refs.part.82+0x6a/0x290 [btrfs]
>>> >> > [<ffffffffc0664e5c>] ? join_transaction.isra.31+0x13c/0x380 [btrfs]
>>> >> > [<ffffffffc0655237>] btrfs_run_delayed_refs+0x17/0x20 [btrfs]
>>> >> > [<ffffffffc0665e50>] btrfs_commit_transaction+0xb0/0xa70 [btrfs]
>>> >> > [<ffffffffc0663d95>] transaction_kthread+0x1d5/0x250 [btrfs]
>>> >> > [<ffffffffc0663bc0>] ? open_ctree+0x1f40/0x1f40 [btrfs]
>>> >> > [<ffffffff81095d59>] kthread+0xc9/0xe0
>>> >> > [<ffffffff81095c90>] ? flush_kthread_worker+0x90/0x90
>>> >> > [<ffffffff817d1e7c>] ret_from_fork+0x7c/0xb0
>>> >> > [<ffffffff81095c90>] ? flush_kthread_worker+0x90/0x90
>>> >> > ---[ end trace dd65465954546463 ]---
>>> >> > BTRFS warning (device dm-5): Skipping commit of aborted transaction.
>>> >> > BTRFS: error (device dm-5) in cleanup_transaction:1670: errno=-5 IO failure
>>> >>
>>> >>
>>> >> Any thoughts? Would it help to unplug the "dm5"-device which seems to
>>> >> be causing this errors and then balance the array?
>>> >>
>>> >> Regards,
>>> >> Tobias
>>> >>
>>> >> 2015-02-09 23:45 GMT+01:00 Tobias Holst <tobby@tobby.eu>:
>>> >> > Hi
>>> >> >
>>> >> > I'm having some trouble with my six-drives btrfs raid6 (each drive
>>> >> > encrypted with LUKS). At first: Yes, I do have backups, but it may
>>> >> > take at least days, maybe weeks or even some month to restore
>>> >> > everything from the (offside) backups. So it is not essential to
>>> >> > recover the data, but would be great ;-)
>>> >> >
>>> >> > OS: Ubuntu 14.04
>>> >> > Kernel: 3.19.0
>>> >> > btrfs-progs: 3.19-rc2
>>> >> >
>>> >> > When booting my server I am getting this in the syslog:
>>> >> >> [    8.026362] BTRFS: device label tobby-btrfs devid 3 transid 108721 /dev/dm-0
>>> >> >> [    8.118896] BTRFS: device label tobby-btrfs devid 6 transid 108721 /dev/dm-1
>>> >> >> [    8.202477] BTRFS: device label tobby-btrfs devid 1 transid 108721 /dev/dm-2
>>> >> >> [    8.520988] BTRFS: device label tobby-btrfs devid 4 transid 108721 /dev/dm-3
>>> >> >> [    8.555570] BTRFS info (device dm-3): force lzo compression
>>> >> >> [    8.555574] BTRFS info (device dm-3): disk space caching is enabled
>>> >> >> [    8.556310] BTRFS: failed to read the system array on dm-3
>>> >> >> [    8.592135] BTRFS: open_ctree failed
>>> >> >> [    9.039187] BTRFS: device label tobby-btrfs devid 2 transid 108721 /dev/dm-4
>>> >> >> [    9.107779] BTRFS: device label tobby-btrfs devid 5 transid 108721 /dev/dm-5
>>> >> > Looks like there is something wrong on drive 3, giving me "open_ctree
>>> >> > failed". I have to press "S" to skip mounting of the btrfs volume. It
>>> >> > boots and with "sudo mount --all" I can successfully mount the btrfs
>>> >> > volume. Sometimes it takes one or two minutes but it will mount.
>>> >> >
>>> >> > After a while I am sometimes/randomly getting this in the syslog:
>>> >> >> [ 1161.283246] BTRFS: dm-5 checksum verify failed on 39099619901440 wanted BB5B0AD5 found 6B6F5040 level 0
>>> >> > Looks like something else is broken on dm-5... But shouldn't this be
>>> >> > repaired with the new raid56-repair-features of kernel 3.19?
>>> >> >
>>> >> > After some more time I am getting this:
>>> >> >> [637017.631044] BTRFS (device dm-4): parent transid verify failed on 39099305132032 wanted 108722 found 108719
>>> >> > Then it is not possible to access the mounted volume anymore. I have
>>> >> > to "umount -l" to unmount it and then I can remount it. Until it
>>> >> > happens again (after some time)...
>>> >> >
>>> >> > I also tried a balance and a scrub but they "crash". Syslog is full of
>>> >> > messages like the following examples:
>>> >> >> [ 3355.523157] csum_tree_block: 53 callbacks suppressed
>>> >> >> [ 3355.523160] BTRFS: dm-5 checksum verify failed on 39099306917888 wanted F90D8231 found 5981C697 level 0
>>> >> >> [ 4006.935632]  BTRFS (device dm-5): parent transid verify failed on 30525418536960 wanted 108975 found 108767
>>> >> > and "btrfs scrub status /[device]" gives me the following output:
>>> >> >> "scrub status for [UUID]
>>> >> >>        scrub started at Mon Feb  9 18:16:38 2015 and was aborted after 2008 seconds
>>> >> >>        total bytes scrubbed: 113.04GiB with 0 errors"
>>> >> >
>>> >> > So a short summary:
>>> >> > - btrfs raid6 on 3.19.0 with btrfs-progs 3.19-rc2
>>> >> > - does not mount at boot up, "open_ctree failed" (disk 3)
>>> >> > - mounts successfully after bootup
>>> >> > - randomly "checksum verify failed" (disk 5)
>>> >> > - balance and scrub crash after some time
>>> >> > - after a while the volume gets unreadable, saying "parent transid
>>> >> > verify failed" (disk 4 or 5)
>>> >> >
>>> >> > And it looks like there still is no way to btrfsck a raid6.
>>> >> >
>>> >> > Any ideas how to repair this filesystem?
>>> >> >
>>> >> > Regards,
>>> >> > Tobias
>>> >> --
>>> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> >> the body of a message to majordomo@vger.kernel.org
>>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
