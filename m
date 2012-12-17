Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:61856 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2LQQRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 11:17:33 -0500
Received: by mail-qc0-f180.google.com with SMTP id v28so3999757qcm.11
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 08:17:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <kanf24$o8e$1@news.dmz-ext.fr.lan>
References: <kanf24$o8e$1@news.dmz-ext.fr.lan>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Mon, 17 Dec 2012 17:17:12 +0100
Message-ID: <CAGy7Uti_4g82gDf_VoVwreMRR5wULv5qWdS6QB6q6U0Ha4=PHA@mail.gmail.com>
Subject: Re: Feeback on RAID1 feature of Btrfs
To: Sebastien Luttringer <sebastien.luttringer@smartjog.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Sebastien,

with btrfs raid1 you get two copies of each extent on separate drives.
That means you can lose one drive only, no matter how many drives are
in the set. It's not traditional raid1, which is probably what you are
confusing it with. Having raid1 with more than 2n-redudancy is not
currently possible with btrfs, though rumour has it this capability
may land in 3.8

Regards,

Bart


On Mon, Dec 17, 2012 at 4:51 PM, Sebastien Luttringer
<sebastien.luttringer@smartjog.com> wrote:
> Hello,
>
> I'm testing Btrfs RAID1 feature on 3 disks of ~10GB. Last one is not
> exactly 10GB (would be too easy).
>
> About the test machine, it's a kvm vm running an up-to-date archlinux
> with linux 3.7 and btrfs-progs 0.19.20121005.
>
> #uname -a
> Linux seblu-btrfs-1 3.7.0-1-ARCH #1 SMP PREEMPT Tue Dec 11 15:05:50 CET
> 2012 x86_64 GNU/Linux
>
> Filesystem was created with :
>
> # mkfs.btrfs -L test -d raid1 -m raid1 /dev/vd[bcd]
>
> I downloaded a lot of linux kernel tarball and untared in into this
> filesystem until it tell me enough:
>
> drwxr-xr-x 1 root root  330 2007-10-09 20:31 linux-2.6.23
> -rw-r--r-- 1 root root  44M 2007-10-09 20:48 linux-2.6.23.tar.bz2
> drwxr-xr-x 1 root root  344 2008-01-24 22:58 linux-2.6.24
> -rw-r--r-- 1 root root  45M 2008-01-24 23:16 linux-2.6.24.tar.bz2
> drwxr-xr-x 1 root root  352 2008-04-17 02:49 linux-2.6.25
>
> Some output of btrfs tools
>
> # btrfs fi sh
> Label: 'test'  uuid: 7d72c625-4dd7-4db0-b4a2-075e26572b99
>         Total devices 3 FS bytes used 11.57GB
>         devid    3 size 10.00GB used 9.76GB path /dev/vdd
>         devid    2 size 10.00GB used 10.00GB path /dev/vdc
>         devid    1 size 9.77GB used 9.77GB path /dev/vdb
>
> # btrfs fi df .
> Data, RAID1: total=13.50GB, used=10.56GB
> Data: total=8.00MB, used=0.00
> System, RAID1: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=1.25GB, used=1.01GB
> Metadata: total=8.00MB, used=0.00
>
> I have choosen a _raid1_ filesystem, so I expect every disk be able to
> die and fs still usuable without data lost.
>
> I used chksfv[1] to make checksum of tarball on disk and check my data
> are safe.
>
> I killed the first disk via libvirt.
> # virsh detach-disk  seblu-btrfs-1 vdb
>
> Btrfs detect missing disk \o/
>
> # btrfs fi sh
> Label: 'test'  uuid: 7d72c625-4dd7-4db0-b4a2-075e26572b99
>         Total devices 3 FS bytes used 11.57GB
>         devid    3 size 10.00GB used 8.01GB path /dev/vdd
>         devid    2 size 10.00GB used 9.26GB path /dev/vdc
>         *** Some devices missing
>
> Listing all files and cksum on tarballs are good.
>
> # cksfv -f ~/checksum
> Everything OK
>
> We have raid1, so we can expect kill one disk (the smaller). Let's go.
>
> # virsh detach-disk  seblu-btrfs-1 vdd
>
> # btrfs fi sh
> Label: 'test'  uuid: 7d72c625-4dd7-4db0-b4a2-075e26572b99
>         Total devices 3 FS bytes used 11.57GB
>         devid    3 size 10.00GB used 8.01GB path /dev/vdd
>         devid    2 size 10.00GB used 9.26GB path /dev/vdc
>         *** Some devices missing
>
> It doesn't see the drive go away... Listing doesn't works.
>
> # find /mnt/test
> .
> ./pkg
> ^C
> # cksfv -f ~/checksum
> linux-2.6.30.tar.bz2                              OK
> linux-2.6.31.tar.bz2                              Input/output error
> linux-2.6.32.tar.bz2                              Input/output error
> linux-2.6.33.tar.bz2                              Input/output error
>
> So data and metada seems broken. Filesystem is become read only
> # touch séb
> touch: cannot touch ‘séb’: Read-only file system
>
> and finally I got a traceback in dmesg
>
> [  804.910405] ------------[ cut here ]------------
> [  804.910491] WARNING: at fs/btrfs/super.c:246
> __btrfs_abort_transaction+0xdf/0x100 [btrfs]()
> [  804.910499] Hardware name: Bochs
> [  804.910501] btrfs: Transaction aborted
> [  804.910502] Modules linked in: cirrus ttm i2c_piix4 drm_kms_helper
> psmouse intel_agp drm evdev intel_gtt serio_raw syscopyarea sysfillrect
> sysimgblt i2c_core processor button pcspkr microcode btrfs crc32c
> libcrc32c zlib_deflate ata_generic pata_acpi virtio_balloon virtio_blk
> virtio_net ata_piix libata uhci_hcd virtio_pci virtio_ring virtio
> usbcore usb_common scsi_mod floppy
> [  804.910575] Pid: 2077, comm: touch Not tainted 3.7.0-1-ARCH #1
> [  804.910577] Call Trace:
> [  804.910606]  [<ffffffff8105742f>] warn_slowpath_common+0x7f/0xc0
> [  804.910610]  [<ffffffff81057526>] warn_slowpath_fmt+0x46/0x50
> [  804.910619]  [<ffffffffa015ff6f>]
> __btrfs_abort_transaction+0xdf/0x100 [btrfs]
> [  804.910635]  [<ffffffffa01802c0>] ? verify_parent_transid+0x170/0x170
> [btrfs]
> [  804.910648]  [<ffffffffa016402a>] __btrfs_cow_block+0x48a/0x510 [btrfs]
> [  804.910661]  [<ffffffffa0164227>] btrfs_cow_block+0xf7/0x230 [btrfs]
> [  804.910672]  [<ffffffffa016752b>] push_leaf_right+0x11b/0x190 [btrfs]
> [  804.910681]  [<ffffffffa0167cb1>] split_leaf+0x621/0x740 [btrfs]
> [  804.910690]  [<ffffffffa0160d52>] ? leaf_space_used+0xd2/0x110 [btrfs]
> [  804.910710]  [<ffffffffa01b9455>] ?
> btrfs_set_lock_blocking_rw+0xb5/0x120 [btrfs]
> [  804.910720]  [<ffffffffa016894c>] btrfs_search_slot+0x89c/0x900 [btrfs]
> [  804.910730]  [<ffffffffa0169fcc>] btrfs_insert_empty_items+0x7c/0xe0
> [btrfs]
> [  804.910742]  [<ffffffffa017c313>] insert_with_overflow+0x43/0x120 [btrfs]
> [  804.910753]  [<ffffffffa017c4ac>] btrfs_insert_dir_item+0xbc/0x200
> [btrfs]
> [  804.910767]  [<ffffffffa0195c6b>] btrfs_add_link+0xeb/0x300 [btrfs]
> [  804.910781]  [<ffffffffa0196f64>] btrfs_create+0x1a4/0x210 [btrfs]
> [  804.910799]  [<ffffffff81217a0c>] ? security_inode_permission+0x1c/0x30
> [  804.910813]  [<ffffffff8118fd56>] vfs_create+0xb6/0x120
> [  804.910833]  [<ffffffff8119281d>] do_last+0xd5d/0xeb0
> [  804.910838]  [<ffffffff8118ed68>] ? link_path_walk+0x78/0x950
> [  804.910841]  [<ffffffff81192a2c>] path_openat+0xbc/0x530
> [  804.910855]  [<ffffffff8114b551>] ? handle_mm_fault+0x261/0x330
> [  804.910871]  [<ffffffff814a6314>] ? __do_page_fault+0x2d4/0x590
> [  804.910875]  [<ffffffff81193211>] do_filp_open+0x41/0xa0
> [  804.910878]  [<ffffffff811a0119>] ? __alloc_fd+0xe9/0x140
> [  804.910887]  [<ffffffff81182fc4>] do_sys_open+0xf4/0x1e0
> [  804.910890]  [<ffffffff814a65de>] ? do_page_fault+0xe/0x10
> [  804.910895]  [<ffffffff811830d1>] sys_open+0x21/0x30
> [  804.910899]  [<ffffffff814aa51d>] system_call_fastpath+0x1a/0x1f
> [  804.910904] ---[ end trace b713d23404f7cc1c ]---
> [  804.910911] BTRFS error (device vdc) in __btrfs_cow_block:1014: IO
> failure
> [  804.912156] btrfs is forced readonly
>
> I get the feeling that RAID1 only allow one disk removing. Which is more
> a RAID5 feature.
> I'm afraid Btrfs raid1 will not be working before the end of the world.
> Sad day.
>
> Cheers,
>
> [1] https://www.archlinux.org/packages/community/i686/cksfv/
>
> --
> Sebastien "Seblu" Luttringer
> Research & Engineering Manager - Smartjog - TDF
> 27 bd Hippolyte Marques, 94200 Ivry sur Seine, France
> Phone: +33.1.58.68.62.32 / Fax: +33.1.58.68.62.05
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
