Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:24195 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbcC1El3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 00:41:29 -0400
From: "James Johnston" <johnstonj.public@codenest.com>
To: "'Chris Murphy'" <lists@colorremedies.com>
Cc: "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
Subject: Compression causes kernel crashes if there are I/O or checksum errors (was: RE: kernel BUG at fs/btrfs/volumes.c:5519 when hot-removing device in RAID-1)
Date: Mon, 28 Mar 2016 04:41:24 -0000
Message-ID: <001b01d188ac$16740630$435c1290$@codenest.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

After puzzling over the btrfs failure I reported here a week ago, I think there
is a bad incompatibility between compression and RAID-1 (maybe other RAID
levels too?).  I think it is unsafe for users to use compression, at least with
multiple devices until this is fixed/investigated further.  That seems like a
drastic claim, but I know I will not be using it for now.  Otherwise, checksum
errors scattered across multiple devices that *should* be recoverable will
render the file system unusable, even to read data from.  (One alternative
hypothesis might be that defragmentation causes the issue, since I used
defragment to compress existing files.)

I finally was able to simplify this to a hopefully easy to reproduce test case,
described in lengthier detail below.  In summary, suppose we start with an
uncompressed btrfs file system on only one disk containing the root file system,
such as created by a clean install of a Linux distribution.  I then:
(1) enable compress=lzo in fstab, reboot, and then defragment the disk to
compress all the existing files, (2) add a second drive to the array and balance
for RAID-1, (3) reboot for good measure, (4) cause a high level of I/O errors,
such as hot-removal of the second drive, OR simply a high level of bit rot
(i.e. use dd to corrupt most of the disk, while either mounted or unmounted).
This is guaranteed to cause the kernel to crash.

If the compression step is skipped such that the volume is uncompressed, you
get lots of I/O errors logged - as expected.  For hot-removal, as you point out,
patches to auto-degrade the array aren't merged yet.  For bit rot, the file
system should log lots of checksum errors and corrections, but again should
succeed.  Most importantly, the kernel _does not fall over_ and bring the
system down.  I think that's acceptable behavior until the patches you mention
are merged.

> There are a number of things missing from multiple device support,
> including any concept of a device becoming faulty (i.e. persistent
> failures rather than transient which Btrfs seems to handle OK for the
> most part), and then also getting it to go degraded automatically, and
> finally hot spare support. There are patches that could use testing.

I think in general, if the system can't handle a persistent failure, it can't
reliably handle a transient failure either... you're just less likely to
notice...  The permanent failure just stress-tests the failure code - if you
pay attention to the test case when hot removing, you'll note that oftentimes
dozens of I/O errors are mitigated successfully before one of them finally
brings the system down.

What you've described above in the patch series are nice-to-have "fancy
features" and I do hope they eventually get tested and merged, but I also hope
the above patches let you disable them all so that one can stress-test the code
handling I/O failures without having a drive get auto-dropped from the array
before you tested the failure code enough.  The I/O errors in my dmesg I'm OK
with, but I think if the file system crashes the kernel it's bad news.

> I think when testing, it's simpler to not use any additional device
> mapper layers.

The test case eliminates all device mapper layers, and just uses raw
disks/partitions.  Here it is - skip to step #5 for the meat of it:

1.  Set up a new VirtualBox VM with:
    * System: Enable EFI
    * System: 8 GB RAM
    * System: 1 processor
    * Storage: Two SATA hard drives, 8 GB each, backed by dynamic VDI files
    * Storage: Default IDE CD-ROM is fine
    * Storage: The SATA hard drives must be hot-pluggable
    * Network: As you require
    * Serial port for debugging

2.  Boot to http://releases.ubuntu.com/15.10/ubuntu-15.10-server-amd64.iso

3.  Install Ubuntu 15.10 with default settings except as noted below:
    a.  Network/user settings: make up settings/accounts as needed.
    b.  Use Manual partitioning with these partitions on /dev/sda, in the
        following order:
        * 100 MB EFI System Partition
        * 500 MB btrfs, mount point at /boot
        * Remaining space: btrfs: mount point at /

4.  Install and boot into 4.6 rc-1 mainline kernel:

    wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.6-rc1-wily/linux-image-4.6.0-040600rc1-generic_4.6.0-040600rc1.201603261930_amd64.deb
    dpkg -i linux-image-4.6.0-040600rc1-generic_4.6.0-040600rc1.201603261930_amd64.deb
    reboot

5.  Set up compression and RAID-1 for root partition onto /dev/sdb:

    # Add "compress=lzo" to all btrfs mounts:
    vim /etc/fstab
    reboot   # to take effect
    # Add second drive
    btrfs device add /dev/sdb /
    # Defragment to compress files
    btrfs filesystem defragment -v -c -r /home
    btrfs filesystem defragment -v -c -r /
    # Balance to RAID-1
    btrfs balance start -dconvert=raid1 -mconvert=raid1 -v /
    # btrfs fi usage says there was some single data until I did this, too:
    btrfs balance start -dconvert=raid1 -mconvert=raid1 -v /home
    # Make sure everything is RAID-1:
    btrfs filesystem usage /
    shutdown -P now

6.  Take a snapshot of the VM...  Then boot it again.  After the system is done
    booting, log in.  Then, using VirtualBox, remove the second hard drive from
    the system (that is, hot removal of /dev/sdb).

7.  ATA driver reports a problem with the device, shortly followed by some btrfs
    I/O errors that soon start showing up, but that's ok (since the patches for
    marking failed devices as missing aren't merged yet).  But the system will
    soon crash - hard.  If the system doesn't crash soon after you see some
    btrfs I/O errors show up, this will kill it very, very quickly:

    cd /usr
    find | xargs cat > /dev/null

8.  To demonstrate that the file system cannot even handle disk errors
    introduced offline, roll back to the snapshot in #6 you took before removing
    /dev/sdb.  Then:

    a.  Boot to the Ubuntu ISO DVD again, and go to a recovery prompt.  Use
        "mount" to make sure that your btrfs isn't mounted, then wipe most of
        the data from the second drive, leaving the first few MB untouched so
        as to leave file system headers intact:

        dd if=/dev/zero of=/dev/sdb bs=1M seek=10

        This simulates a massive amount of bitrot.  Unrealistic?  Maybe, but
        it's RAID-1 so it should survive; checksums will catch it.

    b.  Remove the DVD and reboot back into your installed grub on /dev/sda.
        Try to boot your system.  The kernel will crash with the same errors as
        previous when hot-removing the drive.  (Note that if your volume was
        uncompressed, you'll get some checksum errors logged from btrfs but
        the system otherwise would boot fine.)

The snippet below was captured from my virtual machine while attempting to boot
after zeroing most of /dev/sdb so as to cause lots of checksum errors.  Again
this is from the Ubuntu 15.10 mainline Linux 4.6 rc-1 kernel. 

Scanning for Btrfs filesystems
[   10.567428] BTRFS: device fsid ea9f0a9a-24f7-4e3c-9024-ed9c445a838d devid 2 transid 149 /dev/sdb
[   10.632885] BTRFS: device fsid ea9f0a9a-24f7-4e3c-9024-ed9c445a838d devid 1 transid 149 /dev/sda3
[   10.671767] BTRFS: device fsid 8a78480a-2c46-41be-a8aa-35bb5b626e07 devid 1 transid 25 /dev/sda2
done.
Begin: Checking root file system ... fsck from util-linux 2.26.2
done.[   10.760787] BTRFS info (device sda3): disk space caching is enabled

[   10.789275] BTRFS: has skinny extents
done.[   10.821080] BTRFS error (device sda3): bad tree block start 0 7879147520

[   10.868372] BTRFS error (device sda3): bad tree block start 0 7774093312
[   10.928190] BTRFS error (device sda3): bad tree block start 0 7755956224
[   10.971386] BTRFS error (device sda3): bad tree block start 0 7756431360
[   11.008786] BTRFS error (device sda3): bad tree block start 0 7756398592
Begin: Running /scripts/local-bo[   11.060932] BTRFS error (device sda3): bad tree block start 0 7881998336
ttom ... done.
Begin: Running /scripts/init-bottom ... done.
[   11.131834] BTRFS error (device sda3): bad tree block start 0 7880556544
[   11.183365] BTRFS warning (device sda3): csum failed ino 1390 off 0 csum 2566472073 expected csum 3255664415
[   11.210541] BTRFS warning (device sda3): csum failed ino 1390 off 4096 csum 2566472073 expected csum 4214559832
[   11.220571] BTRFS warning (device sda3): csum failed ino 1390 off 8192 csum 2566472073 expected csum 480458051
[   11.247389] BTRFS warning (device sda3): csum failed ino 1390 off 4096 csum 2566472073 expected csum 4214559832
[   11.301305] BTRFS warning (device sda3): csum failed ino 1390 off 12288 csum 2566472073 expected csum 2350310827
[   11.326303] BTRFS warning (device sda3): csum failed ino 1390 off 0 csum 2566472073 expected csum 3255664415
[   11.337395] BTRFS warning (device sda3): csum failed ino 1390 off 12288 csum 2566472073 expected csum 2350310827
[   11.368353] random: nonblocking pool is initialized
[   11.376003] BTRFS warning (device sda3): csum failed ino 1390 off 8192 csum 2566472073 expected csum 480458051
[   11.405067] BTRFS error (device sda3): bad tree block start 0 7756693504
[   11.439856] BTRFS error (device sda3): bad tree block start 0 7756709888
[   11.474957] BTRFS warning (device sda3): csum failed ino 1547 off 0 csum 2566472073 expected csum 2456395887
[   11.564869] BTRFS warning (device sda3): csum failed ino 1547 off 4096 csum 2566472073 expected csum 1646416170
[   11.633791] BTRFS error (device sda3): bad tree block start 0 7756267520
[   11.659413] BTRFS info (device sda3): csum failed ino 71484 extent 2603868160 csum 2566472073 wanted 1049865625 mirror 0
[   11.673459] ------------[ cut here ]------------
[   11.677450] kernel BUG at /home/kernel/COD/linux/fs/btrfs/volumes.c:5522!
[   11.711284] invalid opcode: 0000 [#1] SMP
[   11.713253] Modules linked in: btrfs xor raid6_pq hid_generic usbhid hid ahci psmouse libahci e1000 video pata_acpi fjes
[   11.765725] CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 4.6.0-040600rc1-generic #201603261930
[   11.824228] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   11.850704] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[   11.865689] task: ffff8802161d4740 ti: ffff880216224000 task.ti: ffff880216224000
[   11.905000] RIP: 0010:[<ffffffffc0166ed6>]  [<ffffffffc0166ed6>] __btrfs_map_block+0xe36/0x11c0 [btrfs]
[   11.918735] RSP: 0000:ffff880216227a80  EFLAGS: 00010282
[   11.933331] RAX: 0000000000001b23 RBX: 0000000000000002 RCX: 0000000000000002
[   11.954117] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800360f4e40
[   11.980734] RBP: ffff880216227b68 R08: 000000021d8f0000 R09: 00000000dd801000
[   11.986452] R10: 0000000000010000 R11: 000000001b240000 R12: 00000000dd800fff
[   12.017683] R13: 000000000000d000 R14: ffff880216227bb0 R15: 0000000000010000
[   12.053965] FS:  0000000000000000(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
[   12.068187] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.070529] CR2: 00007fd993116000 CR3: 0000000215aca000 CR4: 00000000000406f0
[   12.127336] Stack:
[   12.127720]  0000000000001000 00000000efaea33e ffff8800df5d6000 0000000000000001
[   12.172375]  ffff880216227ac8 ffffffffc015716d 0000000000000000 0000000000001b24
[   12.199764]  0000000000001b23 ffff880200000000 0000000000000000 ffff8800360b8ee0
[   12.209815] Call Trace:
[   12.218802]  [<ffffffffc015716d>] ? release_extent_buffer+0x2d/0xc0 [btrfs]
[   12.263082]  [<ffffffffc01677d8>] btrfs_map_bio+0x88/0x350 [btrfs]
[   12.291316]  [<ffffffffc0185628>] btrfs_submit_compressed_read+0x468/0x4b0 [btrfs]
[   12.318768]  [<ffffffffc013ad81>] btrfs_submit_bio_hook+0x1a1/0x1b0 [btrfs]
[   12.351884]  [<ffffffffc015a2bc>] ? btrfs_create_repair_bio+0xdc/0x100 [btrfs]
[   12.357366]  [<ffffffffc015a7a6>] end_bio_extent_readpage+0x4c6/0x5c0 [btrfs]
[   12.362801]  [<ffffffffc015a2e0>] ? btrfs_create_repair_bio+0x100/0x100 [btrfs]
[   12.376990]  [<ffffffff813b5617>] bio_endio+0x57/0x60
[   12.388096]  [<ffffffffc012ed3c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[   12.409567]  [<ffffffffc016c11a>] btrfs_scrubparity_helper+0xca/0x2e0 [btrfs]
[   12.411505]  [<ffffffffc016c41e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[   12.425833]  [<ffffffff8109c845>] process_one_work+0x165/0x480
[   12.435196]  [<ffffffff8109cbab>] worker_thread+0x4b/0x500
[   12.449821]  [<ffffffff8109cb60>] ? process_one_work+0x480/0x480
[   12.452473]  [<ffffffff810a2df8>] kthread+0xd8/0xf0
[   12.454110]  [<ffffffff8183a122>] ret_from_fork+0x22/0x40
[   12.455496]  [<ffffffff810a2d20>] ? kthread_create_on_node+0x1a0/0x1a0
[   12.463845] Code: 50 ff ff ff 48 2b 55 b8 48 0f af c2 48 63 d3 48 39 d0 48 0f 46 d0 48 89 55 88 89 d9 c7 85 60 ff ff ff 00 00 00 00 e9 de f3 ff ff <0f> 0b bb f4 ff ff ff e9 59 fb ff ff be 77 16 00 00 48 c7 c7 90
[   12.557348] RIP  [<ffffffffc0166ed6>] __btrfs_map_block+0xe36/0x11c0 [btrfs]
[   12.590478]  RSP <ffff880216227a80>
[   12.599251] ---[ end trace 90172929edc1cb9b ]---
[   12.615185] BUG: unable to handle kernel paging request at ffffffffffffffd8
[   12.664311] IP: [<ffffffff810a34b0>] kthread_data+0x10/0x20
[   12.668463] PGD 3e09067 PUD 3e0b067 PMD 0
[   12.690490] Oops: 0000 [#2] SMP
[   12.700111] Modules linked in: btrfs xor raid6_pq hid_generic usbhid hid ahci psmouse libahci e1000 video pata_acpi fjes
[   12.757005] CPU: 0 PID: 6 Comm: kworker/u2:0 Tainted: G      D         4.6.0-040600rc1-generic #201603261930
[   12.786552] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   12.829870] task: ffff8802161d4740 ti: ffff880216224000 task.ti: ffff880216224000
[   12.853873] RIP: 0010:[<ffffffff810a34b0>]  [<ffffffff810a34b0>] kthread_data+0x10/0x20
[   12.891065] RSP: 0000:ffff880216227768  EFLAGS: 00010002
[   12.910124] RAX: 0000000000000000 RBX: ffff88021fc16c80 RCX: ffffffff8210b000
[   12.911936] RDX: 0000000000000000 RSI: ffff8802161d47c0 RDI: ffff8802161d4740
[   12.913719] RBP: ffff880216227768 R08: 00000000ffffffff R09: 0000000000000000
[   12.949494] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000016c80
[   12.965945] R13: 0000000000000000 R14: ffff88021fc16c80 R15: ffff8802161d4740
[   12.967492] FS:  0000000000000000(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
[   12.969621] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.986957] CR2: 0000000000000028 CR3: 0000000215aca000 CR4: 00000000000406f0
[   13.006393] Stack:
[   13.009209]  ffff880216227778 ffffffff8109dc0e ffff8802162277c8 ffffffff81835baa
[   13.020081]  ffff8800dd2e4078 ffff8802162277c0 ffff8802161d4740 ffff880216228000
[   13.045368]  0000000000000000 ffff880216227338 0000000000000000 0000000000000000
[   13.057369] Call Trace:
[   13.057883]  [<ffffffff8109dc0e>] wq_worker_sleeping+0xe/0x90
[   13.059069]  [<ffffffff81835baa>] __schedule+0x52a/0x790
[   13.072862]  [<ffffffff81835e45>] schedule+0x35/0x80
[   13.089262]  [<ffffffff81086974>] do_exit+0x7b4/0xb50
[   13.097663]  [<ffffffff81031d93>] oops_end+0xa3/0xd0
[   13.107790]  [<ffffffff8103224b>] die+0x4b/0x70
[   13.130895]  [<ffffffff8102f1c3>] do_trap+0xb3/0x140
[   13.134548]  [<ffffffff8102f5b9>] do_error_trap+0x89/0x110
[   13.136240]  [<ffffffffc0166ed6>] ? __btrfs_map_block+0xe36/0x11c0 [btrfs]
[   13.161570]  [<ffffffffc0132453>] ? btrfs_buffer_uptodate+0x53/0x70 [btrfs]
[   13.166816]  [<ffffffffc010f2c1>] ? generic_bin_search.constprop.37+0x91/0x1a0 [btrfs]
[   13.175639]  [<ffffffff8102fb60>] do_invalid_op+0x20/0x30
[   13.177160]  [<ffffffff8183b88e>] invalid_op+0x1e/0x30
[   13.193004]  [<ffffffffc0166ed6>] ? __btrfs_map_block+0xe36/0x11c0 [btrfs]
[   13.213146]  [<ffffffffc015716d>] ? release_extent_buffer+0x2d/0xc0 [btrfs]
[   13.229069]  [<ffffffffc01677d8>] btrfs_map_bio+0x88/0x350 [btrfs]
[   13.231534]  [<ffffffffc0185628>] btrfs_submit_compressed_read+0x468/0x4b0 [btrfs]
[   13.237415]  [<ffffffffc013ad81>] btrfs_submit_bio_hook+0x1a1/0x1b0 [btrfs]
[   13.268544]  [<ffffffffc015a2bc>] ? btrfs_create_repair_bio+0xdc/0x100 [btrfs]
[   13.280976]  [<ffffffffc015a7a6>] end_bio_extent_readpage+0x4c6/0x5c0 [btrfs]
[   13.291688]  [<ffffffffc015a2e0>] ? btrfs_create_repair_bio+0x100/0x100 [btrfs]
[   13.305346]  [<ffffffff813b5617>] bio_endio+0x57/0x60
[   13.319591]  [<ffffffffc012ed3c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[   13.339111]  [<ffffffffc016c11a>] btrfs_scrubparity_helper+0xca/0x2e0 [btrfs]
[   13.387961]  [<ffffffffc016c41e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[   13.406163]  [<ffffffff8109c845>] process_one_work+0x165/0x480
[   13.416087]  [<ffffffff8109cbab>] worker_thread+0x4b/0x500
[   13.478463]  [<ffffffff8109cb60>] ? process_one_work+0x480/0x480
[   13.481838]  [<ffffffff810a2df8>] kthread+0xd8/0xf0
[   13.556946]  [<ffffffff8183a122>] ret_from_fork+0x22/0x40
[   13.561131]  [<ffffffff810a2d20>] ? kthread_create_on_node+0x1a0/0x1a0
[   13.577065] Code: c4 c7 81 e8 e3 f3 fd ff e9 a2 fe ff ff 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 50 05 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
[   13.625921] RIP  [<ffffffff810a34b0>] kthread_data+0x10/0x20
[   13.649015]  RSP <ffff880216227768>
[   13.653637] CR2: ffffffffffffffd8
[   13.654328] ---[ end trace 90172929edc1cb9c ]---
[   13.672040] Fixing recursive fault but reboot is needed!

Best regards,

James Johnston


