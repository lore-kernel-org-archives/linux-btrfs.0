Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36123 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbcADRF7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jan 2016 12:05:59 -0500
Received: by mail-wm0-f47.google.com with SMTP id l65so170335095wmf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jan 2016 09:05:58 -0800 (PST)
Received: from localhost ([81.170.89.13])
        by smtp.gmail.com with ESMTPSA id w23sm65837148wmd.1.2016.01.04.09.05.55
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Jan 2016 09:05:55 -0800 (PST)
Date: Mon, 4 Jan 2016 17:05:53 +0000
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Crash, boot mount failure: "corrupt leaf, slot offset bad"
Message-ID: <20160104170553.GA4975@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel 4.4.0-rc7
System is Macbook with 109GB btrfs partition on SSD

System crashed (nothing in syslog, could have been btrfs or possibly GPU fault
shortly after running xrandr). After hard reset the btrfs partition was corrupt
and would not mount. I took an image of the partition (some of the output below
refers to sda5, some to loop0, it is the same image)

# dmesg of mount failure (using kernel 4.2 from an Ubuntu 15.10 recovery drive but same on 4.4.0-rc7): 

[ 1969.425321] BTRFS critical (device sda5): corrupt leaf, slot offset bad: block=67239936,root=1, slot=82
[ 1969.428809] BTRFS critical (device sda5): corrupt leaf, slot offset bad: block=67239936,root=1, slot=82
[ 1969.431981] ------------[ cut here ]------------
[ 1969.432018] WARNING: CPU: 2 PID: 11162 at /build/linux-cRemOf/linux-4.2.0/fs/btrfs/extent-tree.c:6264 __btrfs_free_extent.isra.69+0x2ef/0xd70 [btrfs]()
[ 1969.432028] BTRFS: Transaction aborted (error -5)
[ 1969.432030] Modules linked in: drbg ansi_cprng ctr ccm intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp btrfs arc4 xor coretemp rt2800usb rt2x00usb raid6_pq b43 rt2800lib rt2x00lib kvm_intel mac80211 cfg80211 btusb btrtl btbcm btintel bluetooth uvcvideo kvm ssb crc_ccitt crct10dif_pclmul crc32_pclmul snd_hda_codec_hdmi snd_hda_codec_cirrus snd_hda_codec_generic videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hda_intel snd_hda_codec snd_hda_core aesni_intel aes_x86_64 lrw gf128mul glue_helper applesmc snd_hwdep snd_pcm snd_timer snd soundcore joydev input_polldev media ablk_helper cryptd bcm5974 input_leds lpc_ich bcma mei_me mei thunderbolt sbs sbshc acpi_als kfifo_buf apple_gmux industrialio mac_hid shpchp apple_bl autofs4 hid_generic i915 hid_apple sdhci_pci
[ 1969.432115]  i2c_algo_bit ahci uas drm_kms_helper libahci sdhci usb_storage usbhid drm video hid
[ 1969.432132] CPU: 2 PID: 11162 Comm: mount Tainted: G        W       4.2.0-22-generic #27-Ubuntu
[ 1969.432136] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B07.1501071215 01/07/2015
[ 1969.432139]  0000000000000000 00000000037e909d ffff88026267b5d8 ffffffff817e94c9
[ 1969.432145]  0000000000000000 ffff88026267b630 ffff88026267b618 ffffffff8107b3d6
[ 1969.432152]  ffff88026267b608 0000000e5297c000 00000000fffffffb 0000000000000000
[ 1969.432157] Call Trace:
[ 1969.432167]  [<ffffffff817e94c9>] dump_stack+0x45/0x57
[ 1969.432175]  [<ffffffff8107b3d6>] warn_slowpath_common+0x86/0xc0
[ 1969.432181]  [<ffffffff8107b465>] warn_slowpath_fmt+0x55/0x70
[ 1969.432199]  [<ffffffffc086837f>] __btrfs_free_extent.isra.69+0x2ef/0xd70 [btrfs]
[ 1969.432229]  [<ffffffffc08d1e5a>] ? find_ref_head+0x5a/0x80 [btrfs]
[ 1969.432248]  [<ffffffffc086c718>] __btrfs_run_delayed_refs+0x988/0x1080 [btrfs]
[ 1969.432268]  [<ffffffffc086fb1e>] btrfs_run_delayed_refs.part.73+0x6e/0x270 [btrfs]
[ 1969.432284]  [<ffffffffc0859ec3>] ? btrfs_set_path_blocking+0x43/0x80 [btrfs]
[ 1969.432306]  [<ffffffffc086fd35>] btrfs_run_delayed_refs+0x15/0x20 [btrfs]
[ 1969.432326]  [<ffffffffc0884756>] btrfs_commit_transaction+0x56/0xb20 [btrfs]
[ 1969.432332]  [<ffffffff811dde9f>] ? kmem_cache_free+0x1cf/0x1e0
[ 1969.432356]  [<ffffffffc08c9e0d>] btrfs_recover_log_trees+0x3ed/0x490 [btrfs]
[ 1969.432378]  [<ffffffffc08c5890>] ? replay_one_extent+0x6a0/0x6a0 [btrfs]
[ 1969.432397]  [<ffffffffc0881b21>] open_ctree+0x19b1/0x23e0 [btrfs]
[ 1969.432412]  [<ffffffffc0856fae>] btrfs_mount+0x94e/0xa70 [btrfs]
[ 1969.432420]  [<ffffffff813da845>] ? find_next_bit+0x15/0x20
[ 1969.432427]  [<ffffffff811a5e15>] ? pcpu_alloc+0x385/0x670
[ 1969.432434]  [<ffffffff812011c8>] mount_fs+0x38/0x160
[ 1969.432439]  [<ffffffff811a6135>] ? __alloc_percpu+0x15/0x20
[ 1969.432446]  [<ffffffff8121cfab>] vfs_kern_mount+0x6b/0x120
[ 1969.432463]  [<ffffffffc0856848>] btrfs_mount+0x1e8/0xa70 [btrfs]
[ 1969.432469]  [<ffffffff811a5e15>] ? pcpu_alloc+0x385/0x670
[ 1969.432475]  [<ffffffff812011c8>] mount_fs+0x38/0x160
[ 1969.432481]  [<ffffffff811a6135>] ? __alloc_percpu+0x15/0x20
[ 1969.432486]  [<ffffffff8121cfab>] vfs_kern_mount+0x6b/0x120
[ 1969.432493]  [<ffffffff8121f7b6>] do_mount+0x246/0xd10
[ 1969.432498]  [<ffffffff811a08fe>] ? strndup_user+0x4e/0xb0
[ 1969.432503]  [<ffffffff811a0876>] ? memdup_user+0x46/0x80
[ 1969.432510]  [<ffffffff812205af>] SyS_mount+0x9f/0x100
[ 1969.432519]  [<ffffffff817f02b2>] entry_SYSCALL_64_fastpath+0x16/0x75
[ 1969.432523] ---[ end trace 7a560cc73341e0d1 ]---
[ 1969.432528] BTRFS: error (device sda5) in __btrfs_free_extent:6264: errno=-5 IO failure
[ 1969.436576] BTRFS: error (device sda5) in btrfs_run_delayed_refs:2781: errno=-5 IO failure
[ 1969.442036] BTRFS: error (device sda5) in btrfs_replay_log:2375: errno=-5 IO failure (Failed to recover log tree)
[ 1969.446087] BTRFS error (device sda5): cleaner transaction attach returned -30
[ 1969.486477] BTRFS: open_ctree failed


# btrfsck:

checking filesystem on sda5
UUID: b1103526-98a3-4b40-a782-cf66721ed600
checking extents
incorrect offsets 11897 5713478
bad block 67239936
Errors found in extent allocation tree or chunk allocation
checking free space cache
There is no free space entry for 61515563008-62297997312
cache appears valid but isnt 61224255488
found 7839154285 bytes used err is -22
total csum bytes: 0
total tree bytes: 7454720
total fs tree bytes: 0
total extent tree bytes: 7356416
btree space waste bytes: 2454021
file data blocks allocated: 28508160
 referenced 28508160


# btrfs-image (compiled v4.3.1 from git:.../kdave/btrfs-progs) segfaults:

Program received signal SIGSEGV, Segmentation fault.
copy_from_extent_tree (path=0x64e420, metadump=0x7fffffffdf90) at btrfs-image.c:1265
1265                            if (btrfs_extent_flags(leaf, ei) &
(gdb)
(gdb) bt
#0  copy_from_extent_tree (path=0x64e420, metadump=0x7fffffffdf90) at btrfs-image.c:1265
#1  create_metadump (walk_trees=<optimised out>, sanitize=<optimised out>, compress_level=<optimised out>, num_threads=0, out=0x64e010, input=0x7fffffffe3fe "/dev/sda5") at btrfs-image.c:1364
#2  main (argc=2, argv=0x7fffffffe198) at btrfs-image.c:2804


# After btrfs-zero-log the partition mounts but with errors:

[47995.081106] BTRFS: checking UUID tree
[48030.691448] BTRFS critical (device loop0): corrupt leaf, slot offset bad: block=67239936,root=1, slot=82
[48030.794656] BTRFS critical (device loop0): corrupt leaf, slot offset bad: block=67239936,root=1, slot=82
[49304.640667] BTRFS critical (device loop0): corrupt leaf, slot offset bad: block=67239936,root=1, slot=82
[49304.641861] ------------[ cut here ]------------
[49304.641888] WARNING: CPU: 0 PID: 3829 at /build/linux-cRemOf/linux-4.2.0/fs/btrfs/extent-tree.c:6264 __btrfs_free_extent.isra.69+0x2ef/0xd70 [btrfs]()
[49304.641890] BTRFS: Transaction aborted (error -5)
[49304.641892] Modules linked in: btrfs xor raid6_pq arc4 rtl8723be btcoexist intel_rapl rtl8723_common rtl_pci intel_soc_dts_iosf rtlwifi mac80211 intel_powerclamp cfg80211 snd_intel_sst_acpi snd_soc_rt5640 snd_intel_sst_core joydev input_leds snd_hda_codec_hdmi snd_soc_rl6231 snd_hda_codec_conexant snd_soc_sst_mfld_platform snd_hda_codec_generic rtsx_usb_ms coretemp kvm punit_atom_debug snd_soc_core memstick serio_raw crct10dif_pclmul crc32_pclmul cryptd snd_compress dw_dmac snd_hda_intel lpc_ich dw_dmac_core btusb btrtl btbcm btintel bluetooth ac97_bus iosf_mbi uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media snd_hda_codec mei_txe shpchp snd_hda_core mei snd_hwdep snd_pcm_dmaengine rfkill_gpio 8250_fintek ideapad_laptop intel_smartconnect sparse_keymap snd_pcm
[49304.641945]  snd_timer snd soundcore snd_soc_sst_acpi i2c_designware_platform pwm_lpss_platform 8250_dw i2c_designware_core spi_pxa2xx_platform pwm_lpss mac_hid autofs4 rtsx_usb_sdmmc rtsx_usb uas usb_storage psmouse i915 i2c_algo_bit r8169 drm_kms_helper mii drm ahci libahci video i2c_hid hid sdhci_acpi sdhci
[49304.641971] CPU: 0 PID: 3829 Comm: btrfs-transacti Tainted: G        W       4.2.0-22-generic #27-Ubuntu
[49304.641973] Hardware name: LENOVO 80G0/Lancer 5A6, BIOS A7CN43WW 10/21/2014
[49304.641976]  0000000000000000 00000000dfc9f16b ffff880122ddfa98 ffffffff817e94c9
[49304.641980]  0000000000000000 ffff880122ddfaf0 ffff880122ddfad8 ffffffff8107b3d6
[49304.641983]  ffff880122ddfac8 0000000e52860000 00000000fffffffb 0000000000000000
[49304.641987] Call Trace:
[49304.641995]  [<ffffffff817e94c9>] dump_stack+0x45/0x57
[49304.642000]  [<ffffffff8107b3d6>] warn_slowpath_common+0x86/0xc0
[49304.642004]  [<ffffffff8107b465>] warn_slowpath_fmt+0x55/0x70
[49304.642017]  [<ffffffffc07f737f>] __btrfs_free_extent.isra.69+0x2ef/0xd70 [btrfs]
[49304.642035]  [<ffffffffc0860e5a>] ? find_ref_head+0x5a/0x80 [btrfs]
[49304.642049]  [<ffffffffc07fb718>] __btrfs_run_delayed_refs+0x988/0x1080 [btrfs]
[49304.642063]  [<ffffffffc07feb1e>] btrfs_run_delayed_refs.part.73+0x6e/0x270 [btrfs]
[49304.642081]  [<ffffffffc08750a3>] ? btrfs_scrub_pause+0xe3/0x110 [btrfs]
[49304.642094]  [<ffffffffc07fed35>] btrfs_run_delayed_refs+0x15/0x20 [btrfs]
[49304.642109]  [<ffffffffc0813c79>] btrfs_commit_transaction+0x579/0xb20 [btrfs]
[49304.642124]  [<ffffffffc080ee19>] transaction_kthread+0x229/0x240 [btrfs]
[49304.642139]  [<ffffffffc080ebf0>] ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[49304.642143]  [<ffffffff8109a868>] kthread+0xd8/0xf0
[49304.642147]  [<ffffffff8109a790>] ? kthread_create_on_node+0x1f0/0x1f0
[49304.642151]  [<ffffffff817f06df>] ret_from_fork+0x3f/0x70
[49304.642154]  [<ffffffff8109a790>] ? kthread_create_on_node+0x1f0/0x1f0
[49304.642156] ---[ end trace bba14eeb59d201a5 ]---
[49304.642160] BTRFS: error (device loop0) in __btrfs_free_extent:6264: errno=-5 IO failure
[49304.643386] BTRFS info (device loop0): forced readonly
[49304.643391] BTRFS: error (device loop0) in btrfs_run_delayed_refs:2781: errno=-5 IO failure
[49304.644628] BTRFS warning (device loop0): Skipping commit of aborted transaction.
[49304.644632] BTRFS: error (device loop0) in cleanup_transaction:1710: errno=-5 IO failure


# btrfs fi show /mnt/x:

Label: 'LINUX'  uuid: b1103526-98a3-4b40-a782-cf66721ed600
	Total devices 1 FS bytes used 84.16GiB
	devid    1 size 108.80GiB used 108.80GiB path /dev/loop0


# btrfs fi df /mnt/x:

Data, single: total=106.79GiB, used=83.00GiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=2.01GiB, used=1.16GiB
GlobalReserve, single: total=400.00MiB, used=0.00B


# btrfsck --repair:

enabling repair mode
Checking filesystem on /dev/sda5
UUID: b1103526-98a3-4b40-a782-cf66721ed600
checking extents
incorrect offsets 11897 5713478
Deleting bogus item [61515546624,168,16384] at slot 83 on block 4243456
Shifting item nr 83 by 275 bytes in block 4243456
items overlap, can't fix
cmds-check.c:4118: fix_item_offset: Assertion `ret` failed.
btrfs check[0x426e9c]
btrfs check[0x427114]
btrfs check[0x427d2d]
btrfs check(cmd_check+0x15bb)[0x42b203]
btrfs check(main+0x155)[0x409eae]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7ff6aacb2a40]
btrfs check(_start+0x29)[0x409a69]


# btrfsck --repair --init-extent-tree:

[takes a while, over 3 million lines of output... small extract of end follows]

Backref 123269292032 root 257 owner 1089423 offset 17063936 num_refs 0 not found in extent tree
Incorrect local backref count on 123269292032 root 257 owner 1089423 offset 17063936 found 1 wanted 0 back 0x25c5ae0
Backref 123269292032 parent 61250600960 owner 0 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 123269292032 parent 61250600960 owner 0 offset 0 found 1 wanted 0 back 0xdadeb40
backpointer mismatch on [123269292032 4096]
ref mismatch on [123269373952 12288] extent item 0, found 3
adding new data backref on 123269373952 root 257 owner 184332 offset 356352 found 1
adding new data backref on 123269373952 parent 61254959104 owner 0 offset 0 found 1
adding new data backref on 123269373952 parent 63946752 owner 0 offset 0 found 1
Backref 123269373952 root 257 owner 184332 offset 356352 num_refs 0 not found in extent tree
Incorrect local backref count on 123269373952 root 257 owner 184332 offset 356352 found 1 wanted 0 back 0x258a4e0
Backref 123269373952 parent 61254959104 owner 0 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 123269373952 parent 61254959104 owner 0 offset 0 found 1 wanted 0 back 0xdb085a0
Backref 123269373952 parent 63946752 owner 0 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 123269373952 parent 63946752 owner 0 offset 0 found 1 wanted 0 back 0xde73e50
backpointer mismatch on [123269373952 12288]
ref mismatch on [123269513216 28672] extent item 0, found 1
adding new data backref on 123269513216 root 260 owner 407786 offset 559493120 found 1
Backref 123269513216 root 260 owner 407786 offset 559493120 num_refs 0 not found in extent tree
Incorrect local backref count on 123269513216 root 260 owner 407786 offset 559493120 found 1 wanted 0 back 0xca364a0
backpointer mismatch on [123269513216 28672]
repaired damaged extent references
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 1168523045 bytes used err is 0
total csum bytes: 84470212
total tree bytes: 1167949824
total fs tree bytes: 1050476544
total extent tree bytes: 16384
btree space waste bytes: 231805196
file data blocks allocated: 209697452032
 referenced 92010127360


# btrfs scrub then showed only a few files with bad checksums:

       - 5.8GB @jessie/var/log/syslog.1
       - 308MB @jessie/var/log/syslog.1.gz
       - 815MB @tmp/linux/.git/objects/pack/tmp_pack_M544ZX 

The timestamps show these files are several months old so were probably not
open at the time of the crash.

After removing these files no other errors are reported.

The recovered partition then successfully booted, but the next boot failed with
drive full errors. It looks like a btrfs metadata issue:

Data, single: total=106.79GiB, used=82.01GiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=2.01GiB, used=1.51GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Even though the original pre-recovery crashed paritition showed 1.16GiB/2.01GiB
metadata used, it appears used metadata can quickly grow. 

Deleting some subvolumes brought the metadata used down to 1.02GiB but:

# btrfs balance start -dlimit=5 results in "ERROR: error during balancing '/' - No space left on device"

Suggests that even with a used/total metadata of 1.02GiB/2.01GiB there are
still issues. Perhaps the used portion can quickly grow to the point where it
causes problems?

Repeating balance again, starting with dlimit=1 then dlimit=2 then dlimit=5,
was successful with 8 chunks reallocated and "btrfs fi show /" showing
103.02GiB/108.80GiB allocated.

I have an image of the crashed partition so let me know if any further analysis
would be useful. I would guess that the low free metadata may have been a
factor in the crash; it was enough of an issue to cause the post-recovery
system to be unable to boot properly.

FWIW I found several other reports of unbootable btrfs with the same "corrupt
leaf, slot offset bad" error, some also reporting that it occurred after a
crash that required a hard reset:

https://bugzilla.kernel.org/show_bug.cgi?id=74611
http://unix.stackexchange.com/questions/195888/how-to-repair-a-btrfs-block
http://www.spinics.net/lists/linux-btrfs/msg48167.html
http://ubuntuforums.org/showthread.php?t=2301288
https://lists.archlinux.org/pipermail/arch-general/2014-April/035885.html
http://comments.gmane.org/gmane.comp.file-systems.btrfs/34190
