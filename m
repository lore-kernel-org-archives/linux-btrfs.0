Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 162-144-52-249.unifiedlayer.com ([162.144.52.249]:54395 "EHLO
	cl65.servermonkeys.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbCCDsF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Mar 2015 22:48:05 -0500
Received: from [204.187.101.237] (port=60186 helo=zenith.richgannon.net)
	by cl65.servermonkeys.com with esmtpa (Exim 4.85)
	(envelope-from <rich@richgannon.net>)
	id 1YScnd-0008Kt-I3
	for linux-btrfs@vger.kernel.org; Tue, 03 Mar 2015 02:43:09 +0000
Message-ID: <54F51FB8.5080704@richgannon.net>
Date: Mon, 02 Mar 2015 21:43:04 -0500
From: Rich Gannon <rich@richgannon.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: rsync causes kernel oops
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is on a Dell Poweredge 2650 with dual Xeons.  Running Gentoo x86.  
Kernel 3.18.7 with GRSecurity patches (gentoo's hardened-sources).  
btrfs-progs version 3.18.2

I originally had the drives setup as raid5 with kernel 3.19 and no 
GRSecurity patches (and tried 4.0-rc1)., but kept having these issues so 
I balanced the system to raid10 and this did not help. That's when I 
switched to 3.18.7 kernel as it's been running fine on all of my x86_64 
Gentoo systems in various raid1, 5, and single arrays.

This is the trace I get in dmesg whenever I try to run rsync from the 
local server or remote server that touches any Btrfs filesystem:

[  167.008334]  sdb: unknown partition table
[  176.930717]  sdb: unknown partition table
[  177.319257]  sdb: unknown partition table
[  177.473818] BTRFS: device label secure devid 1 transid 7581 /dev/dm-0
[  189.894615]  sdc: unknown partition table
[  190.266313]  sdc: unknown partition table
[  190.408711] BTRFS: device label secure devid 2 transid 7581 /dev/dm-1
[  203.946583]  sdd: unknown partition table
[  204.312035]  sdd: unknown partition table
[  204.544243] BTRFS: device label secure devid 3 transid 7581 /dev/dm-2
[  217.446332]  sde: unknown partition table
[  227.263168]  sde: unknown partition table
[  227.652513]  sde: unknown partition table
[  227.836720] BTRFS: device label secure devid 4 transid 7581 /dev/dm-3
[  247.868115] BTRFS info (device dm-3): enabling auto defrag
[  247.868121] BTRFS info (device dm-3): disk space caching is enabled
[  247.868123] BTRFS: has skinny extents
[  319.495462] PAX: size overflow detected in function __do_readpage 
fs/btrfs/extent_io.c:2967 cicus.740_242 max, count: 1
[  319.495471] CPU: 0 PID: 3600 Comm: rsync Not tainted 
3.18.7-hardened-r1 #1
[  319.495473] Hardware name: Dell Computer Corporation PowerEdge 
2650             /0D4921, BIOS A21 10/05/2006
[  319.495476]  00001000 0046b116 c1ef799b 000ec30f c1ee6dd4 c1ef798d 
c1ef78ee 00000b97
[  319.495484]  c1ef799b 00001000 001e6dc9 c1ef799b 00000000 00001000 
00000000 00000000
[  319.495491]  0c000000 0000262b 00000000 ed905bac 00000000 00000000 
00000000 f4eff168
[  319.495499] Call Trace:
[  319.495511]  [<0046b116>] ? dump_stack+0x3e/0x4e
[  319.495518]  [<000ec30f>] ? report_size_overflow+0x29/0x33
[  319.495524]  [<001e6dc9>] ? __do_readpage+0xa01/0xa08
[  319.495530]  [<0000262b>] ? prot_inuse+0xcb/0x100
[  319.495536]  [<00020001>] ? mce_chrdev_read+0x13d/0x46a
[  319.495542]  [<001c7edc>] ? btrfs_writepage_start_hook+0xb9/0xb9
[  319.495546]  [<001e71bb>] ? __extent_readpages.constprop.45+0x302/0x31c
[  319.495550]  [<001e8592>] ? extent_readpages+0x13a/0x14b
[  319.495554]  [<001c7edc>] ? btrfs_writepage_start_hook+0xb9/0xb9
[  319.495558]  [<00637465>] ? 0x637465
[  319.495562]  [<000200da>] ? mce_chrdev_read+0x216/0x46a
[  319.495565]  [<00637465>] ? 0x637465
[  319.495569]  [<001c4d80>] ? btrfs_readpages+0x20/0x25
[  319.495572]  [<001c7edc>] ? btrfs_writepage_start_hook+0xb9/0xb9
[  319.495576]  [<001c4d60>] ? btrfs_set_page_dirty+0x5/0x5
[  319.495582]  [<000b44dc>] ? __do_page_cache_readahead+0x172/0x1e7
[  319.495586]  [<000b485c>] ? page_cache_sync_readahead+0x38/0x4e
[  319.495590]  [<000ad119>] ? generic_file_read_iter+0x47b/0x6a8
[  319.495595]  [<000caf66>] ? handle_mm_fault+0x44e/0xfb7
[  319.495602]  [<00030357>] ? __do_page_fault+0x367/0x69e
[  319.495607]  [<000e6cf9>] ? new_sync_read+0x6c/0x93
[  319.495611]  [<000e6c8d>] ? do_sync_readv_writev+0x84/0x84
[  319.495614]  [<000e777e>] ? vfs_read+0xe9/0x1b5
[  319.495618]  [<0046f5ff>] ? restore_all_pax+0x7/0x7
[  319.495622]  [<000e7e62>] ? SyS_read+0x41/0x81
[  319.495625]  [<0046f5e4>] ? syscall_call+0x7/0x7
[  319.495631]  [<0046007b>] ? rpc_kill_sb+0x61/0x67
[  324.282761] PAX: size overflow detected in function __do_readpage 
fs/btrfs/extent_io.c:2967 cicus.740_242 max, count: 1
[  324.282769] CPU: 1 PID: 3632 Comm: rsync Not tainted 
3.18.7-hardened-r1 #1
[  324.282772] Hardware name: Dell Computer Corporation PowerEdge 
2650             /0D4921, BIOS A21 10/05/2006
[  324.282774]  00001000 0046b116 c1ef799b 000ec30f c1ee6dd4 c1ef798d 
c1ef78ee 00000b97
[  324.282782]  c1ef799b 00001000 001e6dc9 c1ef799b 00000000 00001000 
00000000 00000000
[  324.282789]  00000000 00000000 001e64d0 ed9816ac 00000000 00000000 
00000000 f4fb1780
[  324.282796] Call Trace:
[  324.282810]  [<0046b116>] ? dump_stack+0x3e/0x4e
[  324.282816]  [<000ec30f>] ? report_size_overflow+0x29/0x33
[  324.282822]  [<001e6dc9>] ? __do_readpage+0xa01/0xa08
[  324.282826]  [<001e64d0>] ? __do_readpage+0x108/0xa08
[  324.282832]  [<00020001>] ? mce_chrdev_read+0x13d/0x46a
[  324.282838]  [<001c7edc>] ? btrfs_writepage_start_hook+0xb9/0xb9
[  324.282844]  [<000be619>] ? __mod_zone_page_state+0x38/0x3c
[  324.282848]  [<001e71bb>] ? __extent_readpages.constprop.45+0x302/0x31c
[  324.282852]  [<001e8592>] ? extent_readpages+0x13a/0x14b
[  324.282856]  [<001c7edc>] ? btrfs_writepage_start_hook+0xb9/0xb9
[  324.282861]  [<000041e0>] ? do_simd_coprocessor_error+0x3/0xa
[  324.282866]  [<000ef9d8>] ? generic_permission+0xc8/0x186
[  324.282871]  [<000fdb69>] ? __d_lookup+0x63/0x174
[  324.282875]  [<001c4d80>] ? btrfs_readpages+0x20/0x25
[  324.282878]  [<001c7edc>] ? btrfs_writepage_start_hook+0xb9/0xb9
[  324.282882]  [<001c4d60>] ? btrfs_set_page_dirty+0x5/0x5
[  324.282888]  [<000b44dc>] ? __do_page_cache_readahead+0x172/0x1e7
[  324.282892]  [<000b485c>] ? page_cache_sync_readahead+0x38/0x4e
[  324.282896]  [<000ad119>] ? generic_file_read_iter+0x47b/0x6a8
[  324.282901]  [<00014d69>] ? x86_event_sysfs_show+0x12b/0x185
[  324.282906]  [<000081a0>] ? quirk_intel_irqbalance+0x50/0xb1
[  324.282911]  [<000e6cf9>] ? new_sync_read+0x6c/0x93
[  324.282915]  [<000e6c8d>] ? do_sync_readv_writev+0x84/0x84
[  324.282918]  [<000e777e>] ? vfs_read+0xe9/0x1b5
[  324.282922]  [<000e7e62>] ? SyS_read+0x41/0x81
[  324.282926]  [<0046f5e4>] ? syscall_call+0x7/0x7



The filesystem is on 4 SCSI drives and encrypted using LUKS/dm-crypt.  
Never had any issues before with the encryption, so I don't think that's 
the issue.

supernova ~ # btrfs fi df /backup/
Data, RAID10: total=358.00GiB, used=357.84GiB
System, RAID10: total=64.00MiB, used=80.00KiB
Metadata, RAID10: total=1.00GiB, used=539.89MiB
supernova ~ # btrfs fi show /backup/
Label: 'secure'  uuid: 580defd3-c4d5-4ecc-b75b-852d26e81287
         Total devices 4 FS bytes used 358.37GiB
         devid    1 size 279.39GiB used 179.53GiB path /dev/mapper/1
         devid    2 size 279.39GiB used 179.53GiB path /dev/mapper/2
         devid    3 size 279.39GiB used 179.53GiB path /dev/mapper/3
         devid    4 size 279.39GiB used 179.53GiB path /dev/mapper/4

Btrfs v3.18.2

Any ideas to solve this?  What other information will help?

Thanks,
Rich
