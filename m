Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.digint.ch ([92.42.190.51]:43573 "EHLO mail.digint.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbbJMO2h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 10:28:37 -0400
Received: from [10.0.1.10] (77-59-134-149.dclient.hispeed.ch [77.59.134.149])
	by mail.digint.ch (Postfix) with ESMTPSA id 5615B2F70062
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 16:28:35 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Axel Burri <axel@tty0.ch>
Subject: Kernel error in extent-tree, forced readonly
Message-ID: <561D150D.1080609@tty0.ch>
Date: Tue, 13 Oct 2015 16:28:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of my backup disks hit a btrfs bug yesterday, leaving me with a
forced readonly filesystem (see kernel trace below). This error is
reproducible, and happens on first access after mounting. This disk
receives snapshots (incrementally "ssh btrfs send -p | btrfs receive")
from several hosts on a daily schedule, and deletes old ones.

- kernel-4.2.3 (no quota support, no acl support)
- btrfs-progs-4.2.2
- mount: noatime,autodefrag,compress=zlib,subvolid=0

My short analysis reveals that the backref 1044608417792 points to
3231, which is most probably the parent subvolume used by a "btrfs
receive" operation, which was then deleted directly after receive
success (using --commit-after).

I suspect the error could have been triggered by a unmount operation
run directly after serveral (~10) receive and (~10) delete operations.
I enabled this unmounting feature in my cron job two days ago, maybe
this wasn't a good idea after all? Before that, the filesystem was
always mounted and I'm doing backups like this for about one year
without any problems.

Can someone please give me some hints on how I can get rid of the
broken backrefs? How do I find out which file is causing the trouble,
and which subvolume I need to delete? And how can I do this on a
readonly fs?

If you are interested, I could leave this disk untouched for some days
and help debugging.


# btrfs fi df /mnt/btr_backup
Data, single: total=487.29GiB, used=481.65GiB
System, DUP: total=32.00MiB, used=40.00KiB
Metadata, DUP: total=18.50GiB, used=7.33GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


Kernel trace:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 17264 at fs/btrfs/extent-tree.c:6255
__btrfs_free_extent.isra.72+0xab0/0xce0()
Modules linked in: isofs sr_mod cdrom usblp f2fs usb_storage bridge stp
llc tun cpufreq_ondemand vfat fat mmc_block snd_hda_codec_hdmi
nvidia(PO) x86_pkg_temp_thermal iwldvm btusb kvm_intel btrtl btbcm
btintel dell_laptop snd_hda_codec_idt bluetooth kvm dcdbas
snd_hda_codec_generic psmouse dell_smm_hwmon iwlwifi sdhci_pci sdhci
mmc_core snd_hda_intel snd_hda_codec thermal snd_hwdep snd_hda_core
snd_pcm parport_pc snd_timer parport xhci_pci snd xhci_hcd acpi_cpufreq
soundcore dell_rbtn processor battery dell_smo8800 ac
CPU: 0 PID: 17264 Comm: btrfs-cleaner Tainted: P           O
4.2.3-gentoo #1
Hardware name: Dell Inc. Latitude E6430/0H3MT5, BIOS A16 08/19/2014
 0000000000000000 ffffffff81778e68 ffffffff81618a50 0000000000000000
 ffffffff810691e7 ffff88021fad46c0 000000f337835000 00000000fffffffe
 0000000000001000 ffff880138044000 ffffffff811dcfc0 0000000000000000
Call Trace:
 [<ffffffff81618a50>] ? dump_stack+0x47/0x67
 [<ffffffff810691e7>] ? warn_slowpath_common+0x77/0xb0
 [<ffffffff811dcfc0>] ? __btrfs_free_extent.isra.72+0xab0/0xce0
 [<ffffffff811e0150>] ? __btrfs_run_delayed_refs+0x7a0/0xf80
 [<ffffffff812dbe42>] ? __percpu_counter_add+0x52/0x70
 [<ffffffff811e0dd0>] ? btrfs_free_tree_block+0xe0/0x1e0
 [<ffffffff811e328a>] ? btrfs_run_delayed_refs.part.78+0x6a/0x250
 [<ffffffff811e1400>] ? walk_up_tree+0xe0/0x1d0
 [<ffffffff811f5e1e>] ? btrfs_should_end_transaction+0x3e/0x60
 [<ffffffff811e1bcc>] ? btrfs_drop_snapshot+0x41c/0x810
 [<ffffffff811f62ae>] ? btrfs_clean_one_deleted_snapshot+0x9e/0xd0
 [<ffffffff811ee1c1>] ? cleaner_kthread+0x141/0x1d0
 [<ffffffff811ee080>] ? btrfs_destroy_pinned_extent+0xa0/0xa0
 [<ffffffff81080e6c>] ? kthread+0xbc/0xe0
 [<ffffffff81080db0>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff8161f0df>] ? ret_from_fork+0x3f/0x70
 [<ffffffff81080db0>] ? kthread_create_on_node+0x170/0x170
---[ end trace 937617c32053608b ]---
BTRFS info (device sdc1): leaf 1044023648256 total ptrs 55 free space 526
\x09item 0 key (1044608286720 168 4096) itemoff 3944 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 2
\x09\x09tree block key (18446744073709551606 128 190953070592) level 0
\x09\x09tree block backref root 7
\x09item 1 key (1044608290816 168 4096) itemoff 3893 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (3259 12 3215) level 0
\x09\x09tree block backref root 3242
\x09item 2 key (1044608294912 168 4096) itemoff 3842 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (82282 108 0) level 0
\x09\x09shared block backref parent 1045418885120
\x09item 3 key (1044608299008 168 4096) itemoff 3782 itemsize 60
\x09\x09extent refs 2 gen 11983 flags 258
\x09\x09tree block key (770034 12 3265) level 0
\x09\x09tree block backref root 3242
\x09\x09tree block backref root 3231
\x09item 4 key (1044608303104 168 4096) itemoff 3731 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (82306 1 0) level 0
\x09\x09shared block backref parent 1045418885120
\x09item 5 key (1044608311296 168 4096) itemoff 3680 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (446163 1 0) level 0
\x09\x09shared block backref parent 1059954139136
\x09item 6 key (1044608315392 168 4096) itemoff 3629 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 2
\x09\x09tree block key (18446744073709551606 128 190953070592) level 0
\x09\x09tree block backref root 7
\x09item 7 key (1044608319488 168 4096) itemoff 3578 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (3885 108 0) level 0
\x09\x09tree block backref root 3242
\x09item 8 key (1044608323584 168 4096) itemoff 3527 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (446881 108 0) level 0
\x09\x09shared block backref parent 1059954139136
\x09item 9 key (1044608327680 168 4096) itemoff 3485 itemsize 42
\x09\x09extent refs 15 gen 10950 flags 258
\x09\x09tree block key (446846 1 0) level 0
\x09item 10 key (1044608327680 176 3099) itemoff 3485 itemsize 0
\x09\x09tree block backref
\x09item 11 key (1044608327680 182 1051577667584) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 12 key (1044608327680 182 1053742895104) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 13 key (1044608327680 182 1053742903296) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 14 key (1044608327680 182 1053742919680) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 15 key (1044608327680 182 1056071090176) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 16 key (1044608327680 182 1056071106560) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 17 key (1044608327680 182 1056071110656) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 18 key (1044608327680 182 1056071122944) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 19 key (1044608327680 182 1056071135232) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 20 key (1044608327680 182 1056071139328) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 21 key (1044608327680 182 1059954139136) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 22 key (1044608327680 182 1061481111552) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 23 key (1044608327680 182 1061481115648) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 24 key (1044608327680 182 1062132523008) itemoff 3485 itemsize 0
\x09\x09shared block backref
\x09item 25 key (1044608331776 168 4096) itemoff 3434 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (3790 12 3215) level 0
\x09\x09tree block backref root 3242
\x09item 26 key (1044608335872 168 4096) itemoff 3383 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (82315 1 0) level 0
\x09\x09shared block backref parent 1045418885120
\x09item 27 key (1044608339968 168 4096) itemoff 3323 itemsize 60
\x09\x09extent refs 2 gen 11983 flags 258
\x09\x09tree block key (770037 12 3886) level 0
\x09\x09tree block backref root 3242
\x09\x09tree block backref root 3231
\x09item 28 key (1044608344064 168 4096) itemoff 3272 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (82323 108 0) level 0
\x09\x09shared block backref parent 1045418885120
\x09item 29 key (1044608348160 168 4096) itemoff 3221 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (3229 84 3496834493) level 0
\x09\x09tree block backref root 3242
\x09item 30 key (1044608352256 168 4096) itemoff 3170 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (82340 12 82339) level 0
\x09\x09shared block backref parent 1045418885120
\x09item 31 key (1044608356352 168 4096) itemoff 3119 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (82366 1 0) level 0
\x09\x09shared block backref parent 1045418885120
\x09item 32 key (1044608360448 168 4096) itemoff 3068 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (82405 108 0) level 0
\x09\x09shared block backref parent 1045418885120
\x09item 33 key (1044608364544 168 4096) itemoff 3017 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (82371 1 0) level 0
\x09\x09shared block backref parent 1045418885120
\x09item 34 key (1044608368640 168 4096) itemoff 2966 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (82418 12 82409) level 0
\x09\x09shared block backref parent 1045418885120
\x09item 35 key (1044608372736 168 4096) itemoff 2915 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (82384 12 82383) level 0
\x09\x09shared block backref parent 1045418885120
\x09item 36 key (1044608376832 168 4096) itemoff 2864 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (3216 84 2654217855) level 0
\x09\x09tree block backref root 3242
\x09item 37 key (1044608380928 168 4096) itemoff 2813 itemsize 51
\x09\x09extent refs 1 gen 10950 flags 258
\x09\x09tree block key (82477 1 0) level 0
\x09\x09shared block backref parent 1045377671168
\x09item 38 key (1044608385024 168 4096) itemoff 2753 itemsize 60
\x09\x09extent refs 2 gen 11983 flags 258
\x09\x09tree block key (770040 12 3229) level 0
\x09\x09tree block backref root 3242
\x09\x09tree block backref root 3231
\x09item 39 key (1044608389120 168 4096) itemoff 2702 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (3215 96 91) level 0
\x09\x09tree block backref root 3242
\x09item 40 key (1044608393216 168 4096) itemoff 2651 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (4196 96 5) level 0
\x09\x09tree block backref root 3242
\x09item 41 key (1044608397312 168 4096) itemoff 2591 itemsize 60
\x09\x09extent refs 2 gen 11983 flags 258
\x09\x09tree block key (770044 1 0) level 0
\x09\x09tree block backref root 3242
\x09\x09tree block backref root 3231
\x09item 42 key (1044608401408 168 4096) itemoff 2540 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (4010 1 0) level 0
\x09\x09tree block backref root 3242
\x09item 43 key (1044608405504 168 4096) itemoff 2489 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (4344 1 0) level 1
\x09\x09tree block backref root 3242
\x09item 44 key (1044608413696 168 4096) itemoff 2429 itemsize 60
\x09\x09extent refs 2 gen 11983 flags 258
\x09\x09tree block key (770047 12 4020) level 0
\x09\x09tree block backref root 3242
\x09\x09tree block backref root 3231
\x09item 45 key (1044608417792 168 4096) itemoff 2378 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (5053 12 3994) level 1
\x09\x09tree block backref root 3242
\x09item 46 key (1044608421888 168 4096) itemoff 2327 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (5551 1 0) level 0
\x09\x09shared block backref parent 1044608417792
\x09item 47 key (1044608425984 168 4096) itemoff 2267 itemsize 60
\x09\x09extent refs 2 gen 11983 flags 258
\x09\x09tree block key (770050 12 5556) level 0
\x09\x09tree block backref root 3242
\x09\x09tree block backref root 3231
\x09item 48 key (1044608438272 168 4096) itemoff 2216 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (2035 96 10) level 0
\x09\x09tree block backref root 3242
\x09item 49 key (1044608442368 168 4096) itemoff 2165 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (2150 96 5) level 0
\x09\x09tree block backref root 3242
\x09item 50 key (1044608446464 168 4096) itemoff 2114 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (2213 96 10) level 0
\x09\x09tree block backref root 3242
\x09item 51 key (1044608450560 168 4096) itemoff 2063 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (5595 12 5591) level 0
\x09\x09shared block backref parent 1044608417792
\x09item 52 key (1044608454656 168 4096) itemoff 2003 itemsize 60
\x09\x09extent refs 2 gen 11983 flags 258
\x09\x09tree block key (770054 108 0) level 0
\x09\x09tree block backref root 3242
\x09\x09tree block backref root 3231
\x09item 53 key (1044608458752 168 4096) itemoff 1952 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (5581 12 3994) level 0
\x09\x09shared block backref parent 1044608417792
\x09item 54 key (1044608462848 168 4096) itemoff 1901 itemsize 51
\x09\x09extent refs 1 gen 11983 flags 258
\x09\x09tree block key (5045 1 0) level 0
\x09\x09shared block backref parent 1044608405504
BTRFS error (device sdc1): unable to find ref byte nr 1044608405504
parent 0 root 3231  owner 1 offset 0
------------[ cut here ]------------
WARNING: CPU: 0 PID: 17264 at fs/btrfs/extent-tree.c:6261
__btrfs_free_extent.isra.72+0xb1e/0xce0()
BTRFS: Transaction aborted (error -2)
Modules linked in: isofs sr_mod cdrom usblp f2fs usb_storage bridge stp
llc tun cpufreq_ondemand vfat fat mmc_block snd_hda_codec_hdmi
nvidia(PO) x86_pkg_temp_thermal iwldvm btusb kvm_intel btrtl btbcm
btintel dell_laptop snd_hda_codec_idt bluetooth kvm dcdbas
snd_hda_codec_generic psmouse dell_smm_hwmon iwlwifi sdhci_pci sdhci
mmc_core snd_hda_intel snd_hda_codec thermal snd_hwdep snd_hda_core
snd_pcm parport_pc snd_timer parport xhci_pci snd xhci_hcd acpi_cpufreq
soundcore dell_rbtn processor battery dell_smo8800 ac
CPU: 0 PID: 17264 Comm: btrfs-cleaner Tainted: P        W  O
4.2.3-gentoo #1
Hardware name: Dell Inc. Latitude E6430/0H3MT5, BIOS A16 08/19/2014
 0000000000000000 ffffffff81778e68 ffffffff81618a50 ffff880009dd7ae8
 ffffffff810691e7 ffff88021fad46c0 000000f337835000 00000000fffffffe
 0000000000001000 ffff880138044000 ffffffff81069265 ffffffff8177dac8
Call Trace:
 [<ffffffff81618a50>] ? dump_stack+0x47/0x67
 [<ffffffff810691e7>] ? warn_slowpath_common+0x77/0xb0
 [<ffffffff81069265>] ? warn_slowpath_fmt+0x45/0x50
 [<ffffffff811dd02e>] ? __btrfs_free_extent.isra.72+0xb1e/0xce0
 [<ffffffff811e0150>] ? __btrfs_run_delayed_refs+0x7a0/0xf80
 [<ffffffff812dbe42>] ? __percpu_counter_add+0x52/0x70
 [<ffffffff811e0dd0>] ? btrfs_free_tree_block+0xe0/0x1e0
 [<ffffffff811e328a>] ? btrfs_run_delayed_refs.part.78+0x6a/0x250
 [<ffffffff811e1400>] ? walk_up_tree+0xe0/0x1d0
 [<ffffffff811f5e1e>] ? btrfs_should_end_transaction+0x3e/0x60
 [<ffffffff811e1bcc>] ? btrfs_drop_snapshot+0x41c/0x810
 [<ffffffff811f62ae>] ? btrfs_clean_one_deleted_snapshot+0x9e/0xd0
 [<ffffffff811ee1c1>] ? cleaner_kthread+0x141/0x1d0
 [<ffffffff811ee080>] ? btrfs_destroy_pinned_extent+0xa0/0xa0
 [<ffffffff81080e6c>] ? kthread+0xbc/0xe0
 [<ffffffff81080db0>] ? kthread_create_on_node+0x170/0x170
 [<ffffffff8161f0df>] ? ret_from_fork+0x3f/0x70
 [<ffffffff81080db0>] ? kthread_create_on_node+0x170/0x170
---[ end trace 937617c32053608c ]---
BTRFS: error (device sdc1) in __btrfs_free_extent:6261: errno=-2 No such
entry
BTRFS info (device sdc1): forced readonly
BTRFS: error (device sdc1) in btrfs_run_delayed_refs:2781: errno=-2 No
such entry



# btrfs check /dev/sdc1
checking extents
bad metadata [1044437663744, 1044437667840) crossing stripe boundary
ref mismatch on [1044608405504 4096] extent item 0, found 1
Backref 1044608405504 parent 3231 root 3231 not found in extent tree
backpointer mismatch on [1044608405504 4096]
owner ref check failed [1044608405504 4096]
ref mismatch on [1044608417792 4096] extent item 0, found 1
Backref 1044608417792 parent 3231 root 3231 not found in extent tree
backpointer mismatch on [1044608417792 4096]
owner ref check failed [1044608417792 4096]
bad metadata [1044716191744, 1044716195840) crossing stripe boundary
bad metadata [1045117468672, 1045117472768) crossing stripe boundary
[...] skip 76 more of these^^^
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/sdc1
UUID: 7f05d84d-e292-40f1-bdf5-3693f6389aaf
found 524700804685 bytes used err is 0
total csum bytes: 504914736
total tree bytes: 7869063168
total fs tree bytes: 6582300672
total extent tree bytes: 592306176
btree space waste bytes: 1631500675
file data blocks allocated: 725683286016
referenced 647135600640
btrfs-progs v4.2.2

