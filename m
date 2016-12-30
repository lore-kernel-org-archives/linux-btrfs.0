Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 162-144-52-249.unifiedlayer.com ([162.144.52.249]:45540 "EHLO
        cl65.servermonkeys.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbcL3Arl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 19:47:41 -0500
Received: from cpe-104-231-13-247.cinci.res.rr.com ([104.231.13.247]:40190 helo=[10.1.10.13])
        by cl65.servermonkeys.com with esmtpa (Exim 4.87)
        (envelope-from <rich@richgannon.net>)
        id 1cMlUS-0006vU-BE
        for linux-btrfs@vger.kernel.org; Fri, 30 Dec 2016 00:56:12 +0000
To: linux-btrfs@vger.kernel.org
From: Rich Gannon <rich@richgannon.net>
Subject: error (device dm-4) in __btrfs_free_extent:6958: errno=-5 IO failure
Message-ID: <2d9d3b3b-4748-dc7a-2b8f-6a2767cea5e2@richgannon.net>
Date: Thu, 29 Dec 2016 19:47:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As if I wasn't scared enough that my data is in trouble on my larger, 
primary Btrfs filesystem, my backup filesystem, also hit some trouble 
today, likely due to a kernel panic freezing the system and a subsequent 
forced reset during a device remove.

I was running `btrfs dev remove /dev/mapper/backup-1 /mnt/backup-btrfs` 
on my "new-to-me" SuperMicro 2U server.  It has both my primary and 
backup filesystems on it (until the second 2U unit arrives next week).

As mentioned above, I had to forcefully reset the server due to a kernel 
panic for an unknown reason (perhaps due to a failed drive which was 
later identified on the primary filesystem).  The filesystem was still 
in the process of removing this device.

I am able to mount this filesystem with no errors but only some 
seemingly-minor things in dmesg until I try to write anything to the 
only subvolume (@backup) at which point I get a non-freezing kernel 
panic and the filesystem becomes read-only.

I received the following during initial mount:
[   72.197216] BTRFS info (device dm-0): disk space caching is enabled
[   72.474072] BTRFS info (device dm-4): use lzo compression
[   72.474075] BTRFS info (device dm-4): disk space caching is enabled
[   72.474076] BTRFS info (device dm-4): has skinny extents
[   72.600816] BTRFS error (device dm-4): parent transid verify failed 
on 15889484660736 wanted 118090 found 118086
[   72.613872] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889484660736 (dev /dev/mapper/backup-1 sector 12694368)
[   72.614079] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889484664832 (dev /dev/mapper/backup-1 sector 12694376)
[   72.614266] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889484668928 (dev /dev/mapper/backup-1 sector 12694384)
[   72.614458] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889484673024 (dev /dev/mapper/backup-1 sector 12694392)
[   72.638285] BTRFS info (device dm-4): bdev /dev/mapper/backup-1 errs: 
wr 0, rd 4, flush 0, corrupt 0, gen 0
[   72.638640] BTRFS error (device dm-4): parent transid verify failed 
on 15889484808192 wanted 118090 found 118086
[   72.639272] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889484808192 (dev /dev/mapper/backup-1 sector 12694656)
[   72.639466] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889484812288 (dev /dev/mapper/backup-1 sector 12694664)
[   72.639651] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889484816384 (dev /dev/mapper/backup-1 sector 12694672)
[   72.639842] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889484820480 (dev /dev/mapper/backup-1 sector 12694680)
[   75.116151] BTRFS error (device dm-4): parent transid verify failed 
on 15889485250560 wanted 118090 found 118086
[   75.116694] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889485250560 (dev /dev/mapper/backup-1 sector 12695520)
[   75.116880] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889485254656 (dev /dev/mapper/backup-1 sector 12695528)
[   78.198601] usb 6-2: USB disconnect, device number 8
[   80.674748] usb 6-2: new low-speed USB device number 9 using uhci_hcd
[   81.040858] usb 6-2: New USB device found, idVendor=0764, idProduct=0601
[   81.040860] usb 6-2: New USB device strings: Mfr=3, Product=1, 
SerialNumber=0
[   81.040861] usb 6-2: Product: OR1500LCDRM1U
[   81.040862] usb 6-2: Manufacturer: CPS
[   81.263990] hid-generic 0003:0764:0601.000A: hidraw0: USB HID v1.10 
Device [CPS OR1500LCDRM1U] on usb-0000:00:1d.0-2/input0
[   88.447482] usb 6-2: USB disconnect, device number 9
[   90.631604] usb 6-2: new low-speed USB device number 10 using uhci_hcd
[   91.209719] usb 6-2: New USB device found, idVendor=0764, idProduct=0601
[   91.209722] usb 6-2: New USB device strings: Mfr=3, Product=1, 
SerialNumber=0
[   91.209724] usb 6-2: Product: OR1500LCDRM1U
[   91.209725] usb 6-2: Manufacturer: CPS
[   91.433941] hid-generic 0003:0764:0601.000B: hidraw0: USB HID v1.10 
Device [CPS OR1500LCDRM1U] on usb-0000:00:1d.0-2/input0
[   92.117006] BTRFS error (device dm-4): parent transid verify failed 
on 15889484365824 wanted 118090 found 118086
[   92.161961] repair_io_failure: 2 callbacks suppressed
[   92.161964] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889484365824 (dev /dev/mapper/backup-1 sector 12693792)
[   92.162218] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889484369920 (dev /dev/mapper/backup-1 sector 12693800)
[   92.162477] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889484374016 (dev /dev/mapper/backup-1 sector 12693808)
[   92.162726] BTRFS info (device dm-4): read error corrected: ino 1 off 
15889484378112 (dev /dev/mapper/backup-1 sector 12693816)


At this point, the filesystem mounts rw and I can write data to the root 
subvolume, but upon writing to the @backup subvolume) I get the following:
[  738.583219] BTRFS warning (device dm-4): block group 15886207418368 
has wrong amount of free space
[  738.583221] BTRFS warning (device dm-4): failed to load free space 
cache for block group 15886207418368, rebuilding it now
[  739.178453] BTRFS error (device dm-4): parent transid verify failed 
on 15889484267520 wanted 118090 found 118086
[  739.178945] BTRFS error (device dm-4): parent transid verify failed 
on 15889484267520 wanted 118090 found 118086
[  739.178949] ------------[ cut here ]------------
[  739.178974] WARNING: CPU: 3 PID: 1137 at fs/btrfs/extent-tree.c:6958 
__btrfs_free_extent.isra.80+0x14d/0xd50 [btrfs]
[  739.178975] BTRFS: Transaction aborted (error -5)
[  739.178975] Modules linked in: vhost_net vhost macvtap macvlan 
xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 
iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
xt_conntrack nf_conntrack ipt_REJECT tun bridge stp llc ebtables 
ip6table_filter ip6_tables iptable_filter ip_tables nfsd auth_rpcgss 
oid_registry nfs_acl cfg80211 rfkill bonding coretemp kvm_intel kvm 
i2c_i801 irqbypass input_leds pcspkr acpi_cpufreq i2c_smbus i7core_edac 
led_class edac_core ioatdma mousedev i5500_temp aesni_intel glue_helper 
ablk_helper virtio_net sky2 r8169 mii igb hwmon ptp pps_core dca fuse 
nfs lockd grace sunrpc btrfs xor zlib_deflate raid6_pq zlib_inflate ext4 
jbd2 mbcache raid1 md_mod dm_crypt dm_mod hid_microsoft hid_generic 
usbhid xhci_pci xhci_hcd ohci_hcd uhci_hcd usb_storage ehci_pci
[  739.179022]  ehci_hcd usbcore usb_common sr_mod cdrom
[  739.179027] CPU: 3 PID: 1137 Comm: kworker/u48:15 Not tainted 
4.9.0-gentoo #1
[  739.179028] Hardware name: Supermicro X8DTN/X8DTN, BIOS 2.1c       
10/28/2011
[  739.179039] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[  739.179040]  0000000000000000 ffffffff811eefa9 ffffc900006ebb38 
0000000000000000
[  739.179042]  ffffffff81049d1a 00000e738eebc000 ffffc900006ebb90 
ffff880bf5ab80a0
[  739.179045]  ffff880c06c44000 0000000000000000 ffff880c03aace00 
ffffffff81049d9a
[  739.179047] Call Trace:
[  739.179051]  [<ffffffff811eefa9>] ? dump_stack+0x46/0x5d
[  739.179055]  [<ffffffff81049d1a>] ? __warn+0xba/0xe0
[  739.179057]  [<ffffffff81049d9a>] ? warn_slowpath_fmt+0x5a/0x80
[  739.179066]  [<ffffffffa01e738d>] ? 
__btrfs_free_extent.isra.80+0x14d/0xd50 [btrfs]
[  739.179076]  [<ffffffffa0252a71>] ? 
btrfs_merge_delayed_refs+0x61/0x5f0 [btrfs]
[  739.179086]  [<ffffffffa01eba1b>] ? 
__btrfs_run_delayed_refs+0x7eb/0x1050 [btrfs]
[  739.179096]  [<ffffffffa01eef90>] ? btrfs_run_delayed_refs+0x90/0x2b0 
[btrfs]
[  739.179105]  [<ffffffffa01ef234>] ? delayed_ref_async_start+0x84/0xa0 
[btrfs]
[  739.179109]  [<ffffffff8105f265>] ? process_one_work+0x135/0x350
[  739.179110]  [<ffffffff8105f7d5>] ? worker_thread+0x45/0x450
[  739.179112]  [<ffffffff8105f790>] ? rescuer_thread+0x310/0x310
[  739.179114]  [<ffffffff8105c742>] ? 
call_usermodehelper_exec_async+0x112/0x120
[  739.179116]  [<ffffffff81064069>] ? kthread+0xc9/0xe0
[  739.179118]  [<ffffffff81063fa0>] ? kthread_park+0x50/0x50
[  739.179121]  [<ffffffff81523822>] ? ret_from_fork+0x22/0x30
[  739.179122] ---[ end trace 3f7e24b2889c3287 ]---
[  739.179124] BTRFS: error (device dm-4) in __btrfs_free_extent:6958: 
errno=-5 IO failure
[  739.179125] BTRFS info (device dm-4): forced readonly
[  739.179128] BTRFS: error (device dm-4) in 
btrfs_run_delayed_refs:2964: errno=-5 IO failure


I tried with -o clear_cache just in case, to no useful fixes.

I've also tried to zero-log and even btrfs check --repair  both of which 
segfaulted.  I'm running `btrfs rescue chunk-recover` right now, so I am 
unable to get the exact output of the above commands just yet.

Perhaps you have some suggestions based on the dmesg output?

Thanks,

Rich
