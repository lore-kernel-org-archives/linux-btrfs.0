Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:21135 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2JQP1n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Oct 2012 11:27:43 -0400
Message-ID: <507ECE60.7090309@oracle.com>
Date: Wed, 17 Oct 2012 23:27:28 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [BUG] __tree_mod_log_rewind  makes extent buffers larger than leafsize
Content-Type: multipart/mixed;
 boundary="------------060301030907060000020906"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060301030907060000020906
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Jan,

Here is the steps,

1. apply the three patches onto the latest btrfs
2. run the script 'debug.sh'[1]
   (NOTE: edit the script and the fio job file[2] to get device and mount point right before running it)

3. it will crash after a few seconds. [3]


thanks,
liubo


[1]:
$ cat debug.sh 
#!/bin/bash

D=/dev/sda5
M=/mnt/btrfs

umount $M $D
mkfs.btrfs $D

mount $D $M -o autodefrag

fio fio_sync_random_write_4k_config &

for ((i=0; i<20; i++))
do
	btrfs sub snap $M $M/s_$i
	sleep 2
done &

[2]
$ cat fio_sync_random_write_4k_config 
[global]
direct=0
ioengine=sync
size=800M
bs=4k
numjobs=1
group_reporting
invalidate=0
end_fsync=1
overwrite=0
directory=/mnt/btrfs


[job_sub0]
startdelay=0
rw=randwrite
filename=foo

[3]
[   71.980881] device fsid bc47c36a-7e90-453d-aa6b-8c4a12e30dc0 devid 1 transid 4 /dev/sda5
[   71.984162] btrfs: enabling auto defrag
[   71.984168] btrfs: disk space caching is enabled
[   72.051464] root last_snapshot 5
[   95.789404] root last_snapshot 6
[  100.229357] root last_snapshot 7
[  103.252999] record_old_file_extents: ino 257 new file_pos 38273024 len 1048576 bytenr 2387300352 disk_len 1048576
[  103.255989] record_extent_backrefs file_pos 38273024 len 1048576
[  103.348648] eb->start 66080768 eb->len 4096 eb->level 1 nritems 66 n 176 rm 110 add 0
[  103.348718] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348743] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348764] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348788] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348807] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348826] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348847] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348869] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348887] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348904] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348924] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348944] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348965] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.348985] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349008] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349030] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349051] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349071] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349096] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349123] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349143] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349163] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349183] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349203] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349223] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349242] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349267] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349285] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349305] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349326] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349358] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349381] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349404] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349424] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349446] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349470] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349496] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349516] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349537] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349555] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349574] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349594] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349616] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349636] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349659] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349680] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349700] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349718] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349739] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.349759] eb->start 66080768 eb->len 4096 eb->level 1 nritems 121 n 176 rm 110 add 0
[  103.351367] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351398] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351430] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351462] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351494] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351522] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351551] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351584] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351613] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351641] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351669] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351700] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351730] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351759] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351785] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351814] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.351840] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.352817] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.352844] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.352871] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.352900] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.352930] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.352958] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.352985] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353013] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353043] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353071] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353107] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353138] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353166] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353195] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353223] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353251] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353279] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353307] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353335] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353370] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353401] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353431] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353460] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353493] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353524] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353552] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353580] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353608] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353634] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353664] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353698] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353728] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353755] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353783] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353811] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353840] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353869] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353896] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353926] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353953] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.353981] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.354010] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.354037] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.354066] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.354093] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.354123] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.354151] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.354177] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.354208] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.354237] eb->start 66080768 eb->len 4096 eb->level 1 nritems 62 n 235 rm 228 add 0
[  103.354239] offset 5909 min_len 17 eb->start 66080768 eb->len 4096, eb->level 1 p 101 mid 176 low 118 high 235 item 33 max 235
[  103.354258] ------------[ cut here ]------------
[  103.354284] kernel BUG at fs/btrfs/ctree.c:1582!
[  103.354305] invalid opcode: 0000 [#1] SMP 
[  103.354326] Modules linked in: btrfs(O) tcp_lp zlib_deflate libcrc32c fuse lockd rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack i915 arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant btusb bluetooth snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iwlwifi snd_timer cfg80211 thinkpad_acpi snd soundcore wmi e1000e iTCO_wdt iTCO_vendor_support lpc_ich mfd_core uinput snd_page_alloc rfkill pcspkr coretemp crc32c_intel ghash_clmulni_intel drm_kms_helper drm joydev i2c_i801 microcode tpm_tis tpm tpm_bios i2c_algo_bit i2c_core video sunrpc sdhci_pci sdhci mmc_core [last unloaded: btrfs]
[  103.354703] CPU 1 
[  103.354715] Pid: 1866, comm: btrfs-endio-wri Tainted: G           O 3.6.0+ #4 LENOVO 4291HA6/4291HA6
[  103.354753] RIP: 0010:[<ffffffffa05d3721>]  [<ffffffffa05d3721>] generic_bin_search.constprop.9+0x1f1/0x200 [btrfs]
[  103.354814] RSP: 0018:ffff8801e6771750  EFLAGS: 00010286
[  103.354838] RAX: 0000000000000072 RBX: 00000000000000eb RCX: 0000000000000f79
[  103.354869] RDX: 00000000000029ea RSI: 0000000000000046 RDI: 0000000000000246
[  103.354899] RBP: ffff8801e6771800 R08: 206d657469203533 R09: 322078616d203333
[  103.354934] R10: 0000000000000441 R11: 3533322078616d20 R12: 0000000000001715
[  103.354966] R13: 0000000000000076 R14: ffff8801cc609d90 R15: 0000000000000021
[  103.354996] FS:  0000000000000000(0000) GS:ffff88021e240000(0000) knlGS:0000000000000000
[  103.355029] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  103.355054] CR2: 00000000014e32b1 CR3: 0000000211e05000 CR4: 00000000000407e0
[  103.355085] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  103.355116] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  103.355148] Process btrfs-endio-wri (pid: 1866, threadinfo ffff8801e6770000, task ffff8801e6749700)
[  103.355185] Stack:
[  103.355196]  0000000000000065 ffffffff000000b0 ffff880100000076 00000000000000eb
[  103.355234]  ffff880100000021 ffff8801000000eb ffff8801e67717d0 ffff8801e677186c
[  103.355271]  00000021000000eb ffff8801e67718e6 000000000000003e 00000000000000eb
[  103.355307] Call Trace:
[  103.355326]  [<ffffffffa05d3779>] bin_search+0x49/0x80 [btrfs]
[  103.355357]  [<ffffffffa05d6c63>] btrfs_search_old_slot+0x2d3/0x7c0 [btrfs]
[  103.355396]  [<ffffffffa05d96ad>] btrfs_next_old_leaf+0xed/0x470 [btrfs]
[  103.355434]  [<ffffffffa064809d>] __resolve_indirect_refs+0x34d/0x6b0 [btrfs]
[  103.355474]  [<ffffffffa0648f04>] find_parent_nodes+0x784/0xf20 [btrfs]
[  103.355515]  [<ffffffffa05fa5f0>] ? btrfs_submit_direct+0x5c0/0x5c0 [btrfs]
[  103.355553]  [<ffffffffa0649e75>] iterate_extent_inodes+0x135/0x370 [btrfs]
[  103.355589]  [<ffffffffa064a142>] iterate_inodes_from_logical+0x92/0xb0 [btrfs]
[  103.355627]  [<ffffffffa05fa5f0>] ? btrfs_submit_direct+0x5c0/0x5c0 [btrfs]
[  103.355664]  [<ffffffffa05f7d9d>] record_extent_backrefs+0xad/0x160 [btrfs]
[  103.355704]  [<ffffffffa060212e>] btrfs_finish_ordered_io+0x11e/0xb80 [btrfs]
[  103.355740]  [<ffffffffa0602ba5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  103.355776]  [<ffffffffa061fb98>] worker_loop+0x148/0x580 [btrfs]
[  103.355810]  [<ffffffffa061fa50>] ? btrfs_queue_worker+0x2e0/0x2e0 [btrfs]
[  103.355841]  [<ffffffff8107ff73>] kthread+0x93/0xa0
[  103.355865]  [<ffffffff8161ae04>] kernel_thread_helper+0x4/0x10
[  103.355890]  [<ffffffff8107fee0>] ? flush_kthread_worker+0xb0/0xb0
[  103.355922]  [<ffffffff8161ae00>] ? gs_change+0x13/0x13
[  103.355947] Code: 00 00 00 89 74 24 08 44 89 7c 24 20 4c 89 e6 89 5c 24 18 44 89 6c 24 10 89 44 24 28 48 c7 04 24 65 00 00 00 31 c0 e8 1d 3d 03 e1 <0f> 0b 89 de 45 31 ed 8b 5d 90 eb 8e 0f 1f 00 55 48 89 e5 66 66 
[  103.357362] RIP  [<ffffffffa05d3721>] generic_bin_search.constprop.9+0x1f1/0x200 [btrfs]
[  103.358666]  RSP <ffff8801e6771750>
[  103.379933] ---[ end trace a7d7755ca5895558 ]---
[  135.823880] ------------[ cut here ]------------
[  135.824938] WARNING: at lib/list_debug.c:33 __list_add+0xc8/0xd0()
[  135.826222] Hardware name: 4291HA6
[  135.827210] list_add corruption. prev->next should be next (ffff8801fd5f27e0), but was           (null). (prev=ffff8801e6771bc8).
[  135.828569] Modules linked in: btrfs(O) tcp_lp zlib_deflate libcrc32c fuse lockd rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack i915 arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant btusb bluetooth snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iwlwifi snd_timer cfg80211 thinkpad_acpi snd soundcore wmi e1000e iTCO_wdt iTCO_vendor_support lpc_ich mfd_core uinput snd_page_alloc rfkill pcspkr coretemp crc32c_intel ghash_clmulni_intel drm_kms_helper drm joydev i2c_i801 microcode tpm_tis tpm tpm_bios i2c_algo_bit i2c_core video sunrpc sdhci_pci sdhci mmc_core [last unloaded: btrfs]
[  135.837173] Pid: 1884, comm: btrfs-endio-wri Tainted: G      D    O 3.6.0+ #4
[  135.839005] Call Trace:
[  135.840579]  [<ffffffff8105c6cf>] warn_slowpath_common+0x7f/0xc0
[  135.842254]  [<ffffffff8105c7c6>] warn_slowpath_fmt+0x46/0x50
[  135.843940]  [<ffffffffa05d352c>] ? comp_keys+0x2c/0x30 [btrfs]
[  135.845638]  [<ffffffff812df9b8>] __list_add+0xc8/0xd0
[  135.847393]  [<ffffffffa05d16a8>] btrfs_get_tree_mod_seq+0xa8/0xc0 [btrfs]
[  135.849214]  [<ffffffffa0635f71>] add_delayed_data_ref+0x161/0x1d0 [btrfs]
[  135.851055]  [<ffffffffa0636aa4>] btrfs_add_delayed_data_ref+0x114/0x1b0 [btrfs]
[  135.852940]  [<ffffffffa05e2a5d>] btrfs_free_extent+0x6d/0x100 [btrfs]
[  135.854861]  [<ffffffffa060927c>] __btrfs_drop_extents+0x9bc/0xb00 [btrfs]
[  135.856812]  [<ffffffffa05d0dca>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  135.858822]  [<ffffffffa0609dce>] btrfs_drop_extents+0x6e/0xa0 [btrfs]
[  135.860856]  [<ffffffffa05f909b>] insert_reserved_file_extent.constprop.13+0x7b/0x2c0 [btrfs]
[  135.862969]  [<ffffffffa0602695>] btrfs_finish_ordered_io+0x685/0xb80 [btrfs]
[  135.865105]  [<ffffffff8106d1da>] ? del_timer_sync+0x3a/0x60
[  135.867280]  [<ffffffff8160f25b>] ? schedule_timeout+0x13b/0x250
[  135.869475]  [<ffffffff8106bea0>] ? lock_timer_base+0x70/0x70
[  135.871737]  [<ffffffffa0602ba5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  135.874046]  [<ffffffffa061fb98>] worker_loop+0x148/0x580 [btrfs]
[  135.876377]  [<ffffffffa061fa50>] ? btrfs_queue_worker+0x2e0/0x2e0 [btrfs]
[  135.878735]  [<ffffffff8107ff73>] kthread+0x93/0xa0
[  135.881124]  [<ffffffff8161ae04>] kernel_thread_helper+0x4/0x10
[  135.883555]  [<ffffffff8107fee0>] ? flush_kthread_worker+0xb0/0xb0
[  135.886032]  [<ffffffff8161ae00>] ? gs_change+0x13/0x13
[  135.888531] ---[ end trace a7d7755ca5895559 ]---
[  165.568096] ------------[ cut here ]------------
[  165.568157] WARNING: at lib/list_debug.c:33 __list_add+0xc8/0xd0()
[  165.568183] Hardware name: 4291HA6
[  165.568196] list_add corruption. prev->next should be next (ffff8801fd5f27e0), but was           (null). (prev=ffff8801e6771bc8).
[  165.568242] Modules linked in: btrfs(O) tcp_lp zlib_deflate libcrc32c fuse lockd rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack i915 arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant btusb bluetooth snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iwlwifi snd_timer cfg80211 thinkpad_acpi snd soundcore wmi e1000e iTCO_wdt iTCO_vendor_support lpc_ich mfd_core uinput snd_page_alloc rfkill pcspkr coretemp crc32c_intel ghash_clmulni_intel drm_kms_helper drm joydev i2c_i801 microcode tpm_tis tpm tpm_bios i2c_algo_bit i2c_core video sunrpc sdhci_pci sdhci mmc_core [last unloaded: btrfs]
[  165.568578] Pid: 1852, comm: btrfs-endio-wri Tainted: G      D W  O 3.6.0+ #4
[  165.568600] Call Trace:
[  165.568615]  [<ffffffff8105c6cf>] warn_slowpath_common+0x7f/0xc0
[  165.568635]  [<ffffffff8105c7c6>] warn_slowpath_fmt+0x46/0x50
[  165.568654]  [<ffffffff812df9b8>] __list_add+0xc8/0xd0
[  165.568679]  [<ffffffffa05d16a8>] btrfs_get_tree_mod_seq+0xa8/0xc0 [btrfs]
[  165.568709]  [<ffffffffa0635f71>] add_delayed_data_ref+0x161/0x1d0 [btrfs]
[  165.568737]  [<ffffffffa0636aa4>] btrfs_add_delayed_data_ref+0x114/0x1b0 [btrfs]
[  165.568765]  [<ffffffffa05db313>] btrfs_inc_extent_ref+0x53/0x90 [btrfs]
[  165.568793]  [<ffffffffa06091f0>] __btrfs_drop_extents+0x930/0xb00 [btrfs]
[  165.568821]  [<ffffffffa0609dce>] btrfs_drop_extents+0x6e/0xa0 [btrfs]
[  165.568848]  [<ffffffffa05f909b>] insert_reserved_file_extent.constprop.13+0x7b/0x2c0 [btrfs]
[  165.568880]  [<ffffffffa0602695>] btrfs_finish_ordered_io+0x685/0xb80 [btrfs]
[  165.568903]  [<ffffffff8106d1da>] ? del_timer_sync+0x3a/0x60
[  165.568924]  [<ffffffff8160f25b>] ? schedule_timeout+0x13b/0x250
[  165.568950]  [<ffffffffa060ced1>] ? btrfs_put_ordered_extent+0x61/0xe0 [btrfs]
[  165.568973]  [<ffffffff8106bea0>] ? lock_timer_base+0x70/0x70
[  165.568997]  [<ffffffffa0602ba5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  165.569023]  [<ffffffffa061fb98>] worker_loop+0x148/0x580 [btrfs]
[  165.569048]  [<ffffffffa061fa50>] ? btrfs_queue_worker+0x2e0/0x2e0 [btrfs]
[  165.569070]  [<ffffffff8107ff73>] kthread+0x93/0xa0
[  165.569088]  [<ffffffff8161ae04>] kernel_thread_helper+0x4/0x10
[  165.569113]  [<ffffffff8107fee0>] ? flush_kthread_worker+0xb0/0xb0
[  165.569142]  [<ffffffff8161ae00>] ? gs_change+0x13/0x13
[  165.569170] ---[ end trace a7d7755ca589555a ]---

--------------060301030907060000020906
Content-Type: application/x-tar;
 name="for-jan.tar"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="for-jan.tar"

Zm9yLWphbi8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAwMDA3NTUA
MDAwMDAwMAAwMDAwMDAwADAwMDAwMDAwMDAwADEyMDM3NTQ1MzcxADAxMTExNwAgNQAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB1c3RhciAgAHJvb3QA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcm9vdAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABmb3ItamFuL2RlYnVnLnNoAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAMDAwMDc1NQAwMDAwMDAwADAwMDAwMDAAMDAwMDAwMDAzMTIA
MTIwMzc1NDUyMjcAMDEyNTQwACAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAHVzdGFyICAAcm9vdAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABy
b290AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACMh
L2Jpbi9iYXNoCgpEPS9kZXYvc2RhNQpNPS9tbnQvYnRyZnMKCnVtb3VudCAkTSAkRApta2Zz
LmJ0cmZzICRECgptb3VudCAkRCAkTSAtbyBhdXRvZGVmcmFnCgpmaW8gZmlvX3N5bmNfcmFu
ZG9tX3dyaXRlXzRrX2NvbmZpZyAmCgpmb3IgKChpPTA7IGk8MjA7IGkrKykpCmRvCglidHJm
cyBzdWIgc25hcCAkTSAkTS9zXyRpCglzbGVlcCAyCmRvbmUgJgoAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZm9yLWphbi9maW9fc3luY19yYW5kb21fd3JpdGVf
NGtfY29uZmlnAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAADAwMDA2NDQAMDAwMDAwMAAwMDAwMDAwADAwMDAwMDAwMjcwADEy
MDM3NTQ1MjczADAxNzM1MAAgMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAB1c3RhciAgAHJvb3QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcm9v
dAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABbZ2xv
YmFsXQpkaXJlY3Q9MAppb2VuZ2luZT1zeW5jCnNpemU9ODAwTQpicz00awpudW1qb2JzPTEK
Z3JvdXBfcmVwb3J0aW5nCmludmFsaWRhdGU9MAplbmRfZnN5bmM9MQpvdmVyd3JpdGU9MApk
aXJlY3Rvcnk9L21udC9idHJmcwoKCltqb2Jfc3ViMF0Kc3RhcnRkZWxheT0wCnJ3PXJhbmR3
cml0ZQpmaWxlbmFtZT1mb28KAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAGZvci1qYW4vMDAwMi1CdHJmcy1zbmFwc2hvdC1hd2Fy
ZS1kZWZyYWcucGF0Y2gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAwMDAwNjQ0ADAwMDAwMDAAMDAwMDAwMAAwMDAwMDA0MjE1NgAxMjAz
NzU0NTE3NAAwMTc3NzAAIDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAdXN0YXIgIAByb290AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHJvb3QA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARnJvbSA0
MjlkZDRjMjBlMTUyNTgyZTA2ODljZTRhZDhkZDVkZDkwOWIyZDYyIE1vbiBTZXAgMTcgMDA6
MDA6MDAgMjAwMQpGcm9tOiBMaXUgQm8gPGJvLmxpLmxpdUBvcmFjbGUuY29tPgpEYXRlOiBN
b24sIDE3IFNlcCAyMDEyIDA5OjU4OjU2ICswMDAwClN1YmplY3Q6IFtQQVRDSCAyLzJdIEJ0
cmZzOiBzbmFwc2hvdC1hd2FyZSBkZWZyYWcKClRoaXMgY29tZXMgZnJvbSBvbmUgb2YgYnRy
ZnMncyBwcm9qZWN0IGlkZWFzLApBcyB3ZSBkZWZyYWdtZW50IGZpbGVzLCB3ZSBicmVhayBh
bnkgc2hhcmluZyBmcm9tIG90aGVyIHNuYXBzaG90cy4KVGhlIGJhbGFuY2luZyBjb2RlIHdp
bGwgcHJlc2VydmUgdGhlIHNoYXJpbmcsIGFuZCBkZWZyYWcgbmVlZHMgdG8gZ3JvdyB0aGlz
CmFzIHdlbGwuCgpOb3cgd2UncmUgYWJsZSB0byBmaWxsIHRoZSBibGFuayB3aXRoIHRoaXMg
cGF0Y2gsIGluIHdoaWNoIHdlIG1ha2UgZnVsbCB1c2Ugb2YKYmFja3JlZiB3YWxraW5nIHN0
dWZmLgoKSGVyZSBpcyB0aGUgYmFzaWMgaWRlYSwKbyAgc2V0IHRoZSB3cml0ZWJhY2sgcmFu
Z2VzIHN0YXJ0ZWQgYnkgZGVmcmFnbWVudCB3aXRoIGZsYWcgRVhURU5UX0RFRlJBRwpvICBh
dCBlbmRpbywgYWZ0ZXIgd2UgZmluaXNoIHVwZGF0aW5nIGZzIHRyZWUsIHdlIHVzZSBiYWNr
cmVmIHdhbGtpbmcgdG8gZmluZAogICBhbGwgcGFyZW50cyBvZiB0aGUgcmFuZ2VzIGFuZCBy
ZS1saW5rIHRoZW0gd2l0aCB0aGUgbmV3IENPV2VkIGZpbGUgbGF5b3V0IGJ5CiAgIGFkZGlu
ZyBjb3JyZXNwb25kaW5nIGJhY2tyZWZzLgoKT3JpZ2luYWxseSBwYXRjaCBieSBMaSBaZWZh
biA8bGl6ZkBjbi5mdWppdHN1LmNvbT4KU2lnbmVkLW9mZi1ieTogTGl1IEJvIDxiby5saS5s
aXVAb3JhY2xlLmNvbT4KLS0tCiBmcy9idHJmcy9pbm9kZS5jIHwgIDYxNyArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDEgZmlsZXMg
Y2hhbmdlZCwgNjE3IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZnMvYnRyZnMvaW5vZGUuYyBiL2ZzL2J0cmZzL2lub2RlLmMKaW5kZXggZTQ1NjVhNS4u
NTc2ZDBhMCAxMDA2NDQKLS0tIGEvZnMvYnRyZnMvaW5vZGUuYworKysgYi9mcy9idHJmcy9p
bm9kZS5jCkBAIC01NCw2ICs1NCw3IEBACiAjaW5jbHVkZSAibG9ja2luZy5oIgogI2luY2x1
ZGUgImZyZWUtc3BhY2UtY2FjaGUuaCIKICNpbmNsdWRlICJpbm9kZS1tYXAuaCIKKyNpbmNs
dWRlICJiYWNrcmVmLmgiCiAKIHN0cnVjdCBidHJmc19pZ2V0X2FyZ3MgewogCXU2NCBpbm87
CkBAIC0xODQ3LDYgKzE4NDgsNjA4IEBAIG91dDoKIAlyZXR1cm4gcmV0OwogfQogCisvKiBz
bmFwc2hvdC1hd2FyZSBkZWZyYWcgKi8KK3N0cnVjdCBzYV9kZWZyYWdfZXh0ZW50X2JhY2ty
ZWYgeworCXN0cnVjdCByYl9ub2RlIG5vZGU7CisJc3RydWN0IG9sZF9zYV9kZWZyYWdfZXh0
ZW50ICpvbGQ7CisJdTY0IHJvb3RfaWQ7CisJdTY0IGludW07CisJdTY0IGZpbGVfcG9zOwor
CXU2NCBleHRlbnRfb2Zmc2V0OworCXU2NCBudW1fYnl0ZXM7CisJdTY0IGdlbmVyYXRpb247
Cit9OworCitzdHJ1Y3Qgb2xkX3NhX2RlZnJhZ19leHRlbnQgeworCXN0cnVjdCBsaXN0X2hl
YWQgbGlzdDsKKwlzdHJ1Y3QgbmV3X3NhX2RlZnJhZ19leHRlbnQgKm5ldzsKKworCXU2NCBl
eHRlbnRfb2Zmc2V0OworCXU2NCBieXRlbnI7CisJdTY0IG9mZnNldDsKKwl1NjQgbGVuOwor
CWludCBjb3VudDsKK307CisKK3N0cnVjdCBuZXdfc2FfZGVmcmFnX2V4dGVudCB7CisJc3Ry
dWN0IHJiX3Jvb3Qgcm9vdDsKKwlzdHJ1Y3QgbGlzdF9oZWFkIGhlYWQ7CisJc3RydWN0IGJ0
cmZzX3BhdGggKnBhdGg7CisJc3RydWN0IGlub2RlICppbm9kZTsKKwl1NjQgZmlsZV9wb3M7
CisJdTY0IGxlbjsKKwl1NjQgYnl0ZW5yOworCXU2NCBkaXNrX2xlbjsKKwl1OCBjb21wcmVz
c190eXBlOworfTsKKworc3RhdGljIGludCBiYWNrcmVmX2NvbXAoc3RydWN0IHNhX2RlZnJh
Z19leHRlbnRfYmFja3JlZiAqYjEsCisJCQlzdHJ1Y3Qgc2FfZGVmcmFnX2V4dGVudF9iYWNr
cmVmICpiMikKK3sKKwlpZiAoYjEtPnJvb3RfaWQgPCBiMi0+cm9vdF9pZCkKKwkJcmV0dXJu
IC0xOworCWVsc2UgaWYgKGIxLT5yb290X2lkID4gYjItPnJvb3RfaWQpCisJCXJldHVybiAx
OworCisJaWYgKGIxLT5pbnVtIDwgYjItPmludW0pCisJCXJldHVybiAtMTsKKwllbHNlIGlm
IChiMS0+aW51bSA+IGIyLT5pbnVtKQorCQlyZXR1cm4gMTsKKworCWlmIChiMS0+ZmlsZV9w
b3MgPCBiMi0+ZmlsZV9wb3MpCisJCXJldHVybiAtMTsKKwllbHNlIGlmIChiMS0+ZmlsZV9w
b3MgPiBiMi0+ZmlsZV9wb3MpCisJCXJldHVybiAxOworCisJV0FSTl9PTigxKTsKKwlyZXR1
cm4gMDsKK30KKworc3RhdGljIHZvaWQgYmFja3JlZl9pbnNlcnQoc3RydWN0IHJiX3Jvb3Qg
KnJvb3QsCisJCQkgICBzdHJ1Y3Qgc2FfZGVmcmFnX2V4dGVudF9iYWNrcmVmICpiYWNrcmVm
KQoreworCXN0cnVjdCByYl9ub2RlICoqcCA9ICZyb290LT5yYl9ub2RlOworCXN0cnVjdCBy
Yl9ub2RlICpwYXJlbnQgPSBOVUxMOworCXN0cnVjdCBzYV9kZWZyYWdfZXh0ZW50X2JhY2ty
ZWYgKmVudHJ5OworCWludCByZXQ7CisKKwl3aGlsZSAoKnApIHsKKwkJcGFyZW50ID0gKnA7
CisJCWVudHJ5ID0gcmJfZW50cnkocGFyZW50LCBzdHJ1Y3Qgc2FfZGVmcmFnX2V4dGVudF9i
YWNrcmVmLCBub2RlKTsKKworCQlyZXQgPSBiYWNrcmVmX2NvbXAoYmFja3JlZiwgZW50cnkp
OworCQlpZiAocmV0IDwgMCkKKwkJCXAgPSAmKCpwKS0+cmJfbGVmdDsKKwkJZWxzZSBpZiAo
cmV0ID4gMCkKKwkJCXAgPSAmKCpwKS0+cmJfcmlnaHQ7CisJCWVsc2UKKwkJCUJVR19PTigx
KTsKKwl9CisKKwlyYl9saW5rX25vZGUoJmJhY2tyZWYtPm5vZGUsIHBhcmVudCwgcCk7CisJ
cmJfaW5zZXJ0X2NvbG9yKCZiYWNrcmVmLT5ub2RlLCByb290KTsKK30KKworLyoKKyAqIE5v
dGUgdGhlIGJhY2tyZWYgbWlnaHQgaGFzIGNoYW5nZWQsIGFuZCBpbiB0aGlzIGNhc2Ugd2Ug
anVzdCByZXR1cm4gMC4KKyAqLworc3RhdGljIG5vaW5saW5lIGludCByZWNvcmRfb25lX2Jh
Y2tyZWYodTY0IGludW0sIHU2NCBvZmZzZXQsIHU2NCByb290X2lkLAorCQkJCSAgICAgICB2
b2lkICpjdHgpCit7CisJc3RydWN0IGJ0cmZzX2ZpbGVfZXh0ZW50X2l0ZW0gKmV4dGVudDsK
KwlzdHJ1Y3QgYnRyZnNfZnNfaW5mbyAqZnNfaW5mbzsKKwlzdHJ1Y3Qgb2xkX3NhX2RlZnJh
Z19leHRlbnQgKm9sZCA9IGN0eDsKKwlzdHJ1Y3QgbmV3X3NhX2RlZnJhZ19leHRlbnQgKm5l
dyA9IG9sZC0+bmV3OworCXN0cnVjdCBidHJmc19wYXRoICpwYXRoID0gbmV3LT5wYXRoOwor
CXN0cnVjdCBidHJmc19rZXkga2V5OworCXN0cnVjdCBidHJmc19yb290ICpyb290OworCXN0
cnVjdCBzYV9kZWZyYWdfZXh0ZW50X2JhY2tyZWYgKmJhY2tyZWY7CisJc3RydWN0IGV4dGVu
dF9idWZmZXIgKmxlYWY7CisJc3RydWN0IGlub2RlICppbm9kZSA9IG5ldy0+aW5vZGU7CisJ
aW50IHNsb3Q7CisJaW50IHJldDsKKwl1NjQgZXh0ZW50X29mZnNldDsKKwl1NjQgbnVtX2J5
dGVzOworCisJaWYgKEJUUkZTX0koaW5vZGUpLT5yb290LT5yb290X2tleS5vYmplY3RpZCA9
PSByb290X2lkICYmCisJICAgIGludW0gPT0gYnRyZnNfaW5vKGlub2RlKSkKKwkJcmV0dXJu
IDA7CisKKwlrZXkub2JqZWN0aWQgPSByb290X2lkOworCWtleS50eXBlID0gQlRSRlNfUk9P
VF9JVEVNX0tFWTsKKwlrZXkub2Zmc2V0ID0gKHU2NCktMTsKKworCWZzX2luZm8gPSBCVFJG
U19JKGlub2RlKS0+cm9vdC0+ZnNfaW5mbzsKKwlyb290ID0gYnRyZnNfcmVhZF9mc19yb290
X25vX25hbWUoZnNfaW5mbywgJmtleSk7CisJaWYgKElTX0VSUihyb290KSkgeworCQlpZiAo
UFRSX0VSUihyb290KSA9PSAtRU5PRU5UKQorCQkJcmV0dXJuIDA7CisJCVdBUk5fT04oMSk7
CisJCXByX2RlYnVnKCJpbnVtPSVsbHUsIG9mZnNldD0lbGx1LCByb290X2lkPSVsbHVcbiIs
CisJCQkgaW51bSwgb2Zmc2V0LCByb290X2lkKTsKKwkJcmV0dXJuIFBUUl9FUlIocm9vdCk7
CisJfQorCisJa2V5Lm9iamVjdGlkID0gaW51bTsKKwlrZXkudHlwZSA9IEJUUkZTX0VYVEVO
VF9EQVRBX0tFWTsKKwlpZiAob2Zmc2V0ID4gKHU2NCktMSA8PCAzMikKKwkJa2V5Lm9mZnNl
dCA9IDA7CisJZWxzZQorCQlrZXkub2Zmc2V0ID0gb2Zmc2V0OworCisJcmV0ID0gYnRyZnNf
c2VhcmNoX3Nsb3QoTlVMTCwgcm9vdCwgJmtleSwgcGF0aCwgMCwgMCk7CisJaWYgKHJldCA8
IDApIHsKKwkJV0FSTl9PTigxKTsKKwkJcmV0dXJuIHJldDsKKwl9CisKKwl3aGlsZSAoMSkg
eworCQljb25kX3Jlc2NoZWQoKTsKKworCQlsZWFmID0gcGF0aC0+bm9kZXNbMF07CisJCXNs
b3QgPSBwYXRoLT5zbG90c1swXTsKKworCQlpZiAoc2xvdCA+PSBidHJmc19oZWFkZXJfbnJp
dGVtcyhsZWFmKSkgeworCQkJcmV0ID0gYnRyZnNfbmV4dF9sZWFmKHJvb3QsIHBhdGgpOwor
CQkJaWYgKHJldCA8IDApIHsKKwkJCQlnb3RvIG91dDsKKwkJCX0gZWxzZSBpZiAocmV0ID4g
MCkgeworCQkJCXJldCA9IDA7CisJCQkJZ290byBvdXQ7CisJCQl9CisJCQljb250aW51ZTsK
KwkJfQorCisJCXBhdGgtPnNsb3RzWzBdKys7CisKKwkJYnRyZnNfaXRlbV9rZXlfdG9fY3B1
KGxlYWYsICZrZXksIHNsb3QpOworCisJCWlmIChrZXkub2JqZWN0aWQgIT0gaW51bSB8fCBr
ZXkudHlwZSAhPSBCVFJGU19FWFRFTlRfREFUQV9LRVkpCisJCQljb250aW51ZTsKKworCQll
eHRlbnQgPSBidHJmc19pdGVtX3B0cihsZWFmLCBzbG90LAorCQkJCQlzdHJ1Y3QgYnRyZnNf
ZmlsZV9leHRlbnRfaXRlbSk7CisKKwkJaWYgKGJ0cmZzX2ZpbGVfZXh0ZW50X2Rpc2tfYnl0
ZW5yKGxlYWYsIGV4dGVudCkgIT0gb2xkLT5ieXRlbnIpCisJCQljb250aW51ZTsKKworCQlp
ZiAoa2V5Lm9mZnNldCAtIGJ0cmZzX2ZpbGVfZXh0ZW50X29mZnNldChsZWFmLCBleHRlbnQp
ICE9CisJCSAgICBvZmZzZXQpCisJCQljb250aW51ZTsKKworCQlicmVhazsKKwl9CisKKwll
eHRlbnRfb2Zmc2V0ID0gYnRyZnNfZmlsZV9leHRlbnRfb2Zmc2V0KGxlYWYsIGV4dGVudCk7
CisJbnVtX2J5dGVzID0gYnRyZnNfZmlsZV9leHRlbnRfbnVtX2J5dGVzKGxlYWYsIGV4dGVu
dCk7CisKKwlpZiAoZXh0ZW50X29mZnNldCA+PSBvbGQtPmV4dGVudF9vZmZzZXQgKyBvbGQt
Pm9mZnNldCArIG9sZC0+bGVuIHx8CisJICAgIGV4dGVudF9vZmZzZXQgKyBudW1fYnl0ZXMg
PCBvbGQtPmV4dGVudF9vZmZzZXQgKyBvbGQtPm9mZnNldCkKKwkJZ290byBvdXQ7CisKKwli
YWNrcmVmID0ga21hbGxvYyhzaXplb2YoKmJhY2tyZWYpLCBHRlBfTk9GUyk7CisJaWYgKCFi
YWNrcmVmKSB7CisJCXJldCA9IC1FTk9FTlQ7CisJCWdvdG8gb3V0OworCX0KKworCWJhY2ty
ZWYtPnJvb3RfaWQgPSByb290X2lkOworCWJhY2tyZWYtPmludW0gPSBpbnVtOworCWJhY2ty
ZWYtPmZpbGVfcG9zID0gb2Zmc2V0ICsgZXh0ZW50X29mZnNldDsKKwliYWNrcmVmLT5udW1f
Ynl0ZXMgPSBudW1fYnl0ZXM7CisJYmFja3JlZi0+ZXh0ZW50X29mZnNldCA9IGV4dGVudF9v
ZmZzZXQ7CisJYmFja3JlZi0+Z2VuZXJhdGlvbiA9IGJ0cmZzX2ZpbGVfZXh0ZW50X2dlbmVy
YXRpb24obGVhZiwgZXh0ZW50KTsKKwliYWNrcmVmLT5vbGQgPSBvbGQ7CisJYmFja3JlZl9p
bnNlcnQoJm5ldy0+cm9vdCwgYmFja3JlZik7CisJb2xkLT5jb3VudCsrOworb3V0OgorCWJ0
cmZzX3JlbGVhc2VfcGF0aChwYXRoKTsKKwlXQVJOX09OKHJldCk7CisJcmV0dXJuIHJldDsK
K30KKworc3RhdGljIG5vaW5saW5lIGJvb2wgcmVjb3JkX2V4dGVudF9iYWNrcmVmcyhzdHJ1
Y3QgYnRyZnNfcGF0aCAqcGF0aCwKKwkJCQkgICBzdHJ1Y3QgbmV3X3NhX2RlZnJhZ19leHRl
bnQgKm5ldykKK3sKKwlzdHJ1Y3QgYnRyZnNfZnNfaW5mbyAqZnNfaW5mbyA9IEJUUkZTX0ko
bmV3LT5pbm9kZSktPnJvb3QtPmZzX2luZm87CisJc3RydWN0IG9sZF9zYV9kZWZyYWdfZXh0
ZW50ICpvbGQsICp0bXA7CisJaW50IHJldDsKKworCW5ldy0+cGF0aCA9IHBhdGg7CisKKwls
aXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUob2xkLCB0bXAsICZuZXctPmhlYWQsIGxpc3QpIHsK
KwkJcmV0ID0gaXRlcmF0ZV9pbm9kZXNfZnJvbV9sb2dpY2FsKG9sZC0+Ynl0ZW5yLCBmc19p
bmZvLAorCQkJCQkJICBwYXRoLCByZWNvcmRfb25lX2JhY2tyZWYsCisJCQkJCQkgIG9sZCk7
CisJCVdBUk5fT04ocmV0IDwgMCk7CisKKwkJLyogbm8gYmFja3JlZiB0byBiZSBwcm9jZXNz
ZWQgZm9yIHRoaXMgZXh0ZW50ICovCisJCWlmICghb2xkLT5jb3VudCkgeworCQkJbGlzdF9k
ZWwoJm9sZC0+bGlzdCk7CisJCQlrZnJlZShvbGQpOworCQl9CisJfQorCisJaWYgKGxpc3Rf
ZW1wdHkoJm5ldy0+aGVhZCkpCisJCXJldHVybiBmYWxzZTsKKworCXJldHVybiB0cnVlOwor
fQorCisvKgorICogTm90ZSB0aGUgYmFja3JlZiBtaWdodCBoYXMgY2hhbmdlZCwgYW5kIGlu
IHRoaXMgY2FzZSB3ZSBqdXN0IHJldHVybiAwLgorICovCitzdGF0aWMgbm9pbmxpbmUgaW50
IHJlbGlua19leHRlbnRfYmFja3JlZihzdHJ1Y3QgYnRyZnNfcGF0aCAqcGF0aCwKKwkJCQkg
c3RydWN0IHNhX2RlZnJhZ19leHRlbnRfYmFja3JlZiAqcHJldiwKKwkJCQkgc3RydWN0IHNh
X2RlZnJhZ19leHRlbnRfYmFja3JlZiAqYmFja3JlZikKK3sKKwlzdHJ1Y3QgYnRyZnNfZmls
ZV9leHRlbnRfaXRlbSAqZXh0ZW50OworCXN0cnVjdCBidHJmc19maWxlX2V4dGVudF9pdGVt
ICppdGVtOworCXN0cnVjdCBidHJmc19vcmRlcmVkX2V4dGVudCAqb3JkZXJlZDsKKwlzdHJ1
Y3QgYnRyZnNfdHJhbnNfaGFuZGxlICp0cmFuczsKKwlzdHJ1Y3QgYnRyZnNfZnNfaW5mbyAq
ZnNfaW5mbzsKKwlzdHJ1Y3QgYnRyZnNfcm9vdCAqcm9vdDsKKwlzdHJ1Y3QgYnRyZnNfa2V5
IGtleTsKKwlzdHJ1Y3QgZXh0ZW50X2J1ZmZlciAqbGVhZjsKKwlzdHJ1Y3Qgb2xkX3NhX2Rl
ZnJhZ19leHRlbnQgKm9sZCA9IGJhY2tyZWYtPm9sZDsKKwlzdHJ1Y3QgbmV3X3NhX2RlZnJh
Z19leHRlbnQgKm5ldyA9IG9sZC0+bmV3OworCXN0cnVjdCBpbm9kZSAqc3JjX2lub2RlID0g
bmV3LT5pbm9kZTsKKwlzdHJ1Y3QgaW5vZGUgKmlub2RlOworCXN0cnVjdCBleHRlbnRfc3Rh
dGUgKmNhY2hlZCA9IE5VTEw7CisJaW50IHJldCA9IDA7CisJdTY0IGhpbnRfYnl0ZTsKKwl1
NjQgc3RhcnQ7CisJdTY0IGxlbjsKKwlib29sIG1lcmdlID0gZmFsc2U7CisKKwlpZiAocHJl
diAmJiBwcmV2LT5yb290X2lkID09IGJhY2tyZWYtPnJvb3RfaWQgJiYKKwkgICAgcHJldi0+
aW51bSA9PSBiYWNrcmVmLT5pbnVtICYmCisJICAgIHByZXYtPmV4dGVudF9vZmZzZXQgPT0g
YmFja3JlZi0+ZXh0ZW50X29mZnNldCAmJgorCSAgICBwcmV2LT5maWxlX3BvcyArIHByZXYt
Pm51bV9ieXRlcyA9PSBiYWNrcmVmLT5maWxlX3BvcykKKwkJbWVyZ2UgPSB0cnVlOworCisJ
a2V5Lm9iamVjdGlkID0gYmFja3JlZi0+cm9vdF9pZDsKKwlrZXkudHlwZSA9IEJUUkZTX1JP
T1RfSVRFTV9LRVk7CisJa2V5Lm9mZnNldCA9ICh1NjQpLTE7CisKKwlmc19pbmZvID0gQlRS
RlNfSShzcmNfaW5vZGUpLT5yb290LT5mc19pbmZvOworCXJvb3QgPSBidHJmc19yZWFkX2Zz
X3Jvb3Rfbm9fbmFtZShmc19pbmZvLCAma2V5KTsKKwlpZiAoSVNfRVJSKHJvb3QpKSB7CisJ
CWlmIChQVFJfRVJSKHJvb3QpID09IC1FTk9FTlQpCisJCQlyZXR1cm4gMDsKKwkJcmV0dXJu
IFBUUl9FUlIocm9vdCk7CisJfQorCisJa2V5Lm9iamVjdGlkID0gYmFja3JlZi0+aW51bTsK
KwlrZXkudHlwZSA9IEJUUkZTX0lOT0RFX0lURU1fS0VZOworCWtleS5vZmZzZXQgPSAwOwor
CisJaW5vZGUgPSBidHJmc19pZ2V0KGZzX2luZm8tPnNiLCAma2V5LCByb290LCBOVUxMKTsK
KwlpZiAoSVNfRVJSX09SX05VTEwoaW5vZGUpIHx8IGlzX2JhZF9pbm9kZShpbm9kZSkpIHsK
KwkJaWYgKGlub2RlICYmICFJU19FUlIoaW5vZGUpKQorCQkJaXB1dChpbm9kZSk7CisJCXJl
dHVybiAwOworCX0KKworCWxvY2tfZXh0ZW50X2JpdHMoJkJUUkZTX0koaW5vZGUpLT5pb190
cmVlLCBiYWNrcmVmLT5maWxlX3BvcywKKwkJCSBiYWNrcmVmLT5maWxlX3BvcyArIGJhY2ty
ZWYtPm51bV9ieXRlcywgMCwgJmNhY2hlZCk7CisKKwlvcmRlcmVkID0gYnRyZnNfbG9va3Vw
X2ZpcnN0X29yZGVyZWRfZXh0ZW50KGlub2RlLAorCQkJCQkJICAgIGJhY2tyZWYtPmZpbGVf
cG9zICsKKwkJCQkJCSAgICBiYWNrcmVmLT5udW1fYnl0ZXMpOworCWlmIChvcmRlcmVkKSB7
CisJCWJ0cmZzX3B1dF9vcmRlcmVkX2V4dGVudChvcmRlcmVkKTsKKwkJZ290byBvdXRfdW5s
b2NrOworCX0KKworCS8qCisJICogMSBmb3IgZHJvcF9leHRlbnRzCisJICogMSBmb3IgbWVy
Z2UgY2xhdXNlJ3Mgc2VhcmNoX3Nsb3QKKwkgKiAxIGZvciBpbnNlcnQgaXRlbXMKKwkgKi8K
Kwl0cmFucyA9IGJ0cmZzX3N0YXJ0X3RyYW5zYWN0aW9uKHJvb3QsIDMpOworCWlmIChJU19F
UlIodHJhbnMpKSB7CisJCXJldCA9IFBUUl9FUlIodHJhbnMpOworCQlnb3RvIG91dF91bmxv
Y2s7CisJfQorCisJa2V5Lm9iamVjdGlkID0gYmFja3JlZi0+aW51bTsKKwlrZXkudHlwZSA9
IEJUUkZTX0VYVEVOVF9EQVRBX0tFWTsKKwlrZXkub2Zmc2V0ID0gYmFja3JlZi0+ZmlsZV9w
b3M7CisKKwlyZXQgPSBidHJmc19zZWFyY2hfc2xvdChOVUxMLCByb290LCAma2V5LCBwYXRo
LCAwLCAwKTsKKwlpZiAocmV0IDwgMCkgeworCQlnb3RvIG91dF9mcmVlX3BhdGg7CisJfSBl
bHNlIGlmIChyZXQgPiAwKSB7CisJCXJldCA9IDA7CisJCWdvdG8gb3V0X2ZyZWVfcGF0aDsK
Kwl9CisKKwlleHRlbnQgPSBidHJmc19pdGVtX3B0cihwYXRoLT5ub2Rlc1swXSwgcGF0aC0+
c2xvdHNbMF0sCisJCQkJc3RydWN0IGJ0cmZzX2ZpbGVfZXh0ZW50X2l0ZW0pOworCisJaWYg
KGJ0cmZzX2ZpbGVfZXh0ZW50X2dlbmVyYXRpb24ocGF0aC0+bm9kZXNbMF0sIGV4dGVudCkg
IT0KKwkgICAgYmFja3JlZi0+Z2VuZXJhdGlvbikKKwkJZ290byBvdXRfZnJlZV9wYXRoOwor
CisJYnRyZnNfcmVsZWFzZV9wYXRoKHBhdGgpOworCisJc3RhcnQgPSBiYWNrcmVmLT5maWxl
X3BvczsKKwlpZiAoYmFja3JlZi0+ZXh0ZW50X29mZnNldCA8IG9sZC0+ZXh0ZW50X29mZnNl
dCArIG9sZC0+b2Zmc2V0KQorCQlzdGFydCArPSBvbGQtPmV4dGVudF9vZmZzZXQgKyBvbGQt
Pm9mZnNldCAtCisJCQkgYmFja3JlZi0+ZXh0ZW50X29mZnNldDsKKworCWxlbiA9IG1pbihi
YWNrcmVmLT5leHRlbnRfb2Zmc2V0ICsgYmFja3JlZi0+bnVtX2J5dGVzLAorCQkgIG9sZC0+
ZXh0ZW50X29mZnNldCArIG9sZC0+b2Zmc2V0ICsgb2xkLT5sZW4pOworCWxlbiAtPSBtYXgo
YmFja3JlZi0+ZXh0ZW50X29mZnNldCwgb2xkLT5leHRlbnRfb2Zmc2V0ICsgb2xkLT5vZmZz
ZXQpOworCisJcmV0ID0gYnRyZnNfZHJvcF9leHRlbnRzKHRyYW5zLCBpbm9kZSwgc3RhcnQs
CisJCQkJIHN0YXJ0ICsgbGVuLCAmaGludF9ieXRlLCAxKTsKKwlpZiAocmV0KQorCQlnb3Rv
IG91dF9mcmVlX3BhdGg7CithZ2FpbjoKKwlrZXkub2JqZWN0aWQgPSBidHJmc19pbm8oaW5v
ZGUpOworCWtleS50eXBlID0gQlRSRlNfRVhURU5UX0RBVEFfS0VZOworCWtleS5vZmZzZXQg
PSBzdGFydDsKKworCWlmIChtZXJnZSkgeworCQlzdHJ1Y3QgYnRyZnNfZmlsZV9leHRlbnRf
aXRlbSAqZmk7CisJCXU2NCBleHRlbnRfbGVuOworCQlzdHJ1Y3QgYnRyZnNfa2V5IGZvdW5k
X2tleTsKKworCQlyZXQgPSBidHJmc19zZWFyY2hfc2xvdCh0cmFucywgcm9vdCwgJmtleSwg
cGF0aCwgMSwgMSk7CisJCWlmIChyZXQgPCAwKQorCQkJZ290byBvdXRfZnJlZV9wYXRoOwor
CisJCXBhdGgtPnNsb3RzWzBdLS07CisJCWxlYWYgPSBwYXRoLT5ub2Rlc1swXTsKKwkJYnRy
ZnNfaXRlbV9rZXlfdG9fY3B1KGxlYWYsICZmb3VuZF9rZXksIHBhdGgtPnNsb3RzWzBdKTsK
KworCQlmaSA9IGJ0cmZzX2l0ZW1fcHRyKGxlYWYsIHBhdGgtPnNsb3RzWzBdLAorCQkJCSAg
ICBzdHJ1Y3QgYnRyZnNfZmlsZV9leHRlbnRfaXRlbSk7CisJCWV4dGVudF9sZW4gPSBidHJm
c19maWxlX2V4dGVudF9udW1fYnl0ZXMobGVhZiwgZmkpOworCisJCWlmIChidHJmc19maWxl
X2V4dGVudF9kaXNrX2J5dGVucihsZWFmLCBmaSkgPT0gbmV3LT5ieXRlbnIgJiYKKwkJICAg
IGJ0cmZzX2ZpbGVfZXh0ZW50X3R5cGUobGVhZiwgZmkpID09IEJUUkZTX0ZJTEVfRVhURU5U
X1JFRyAmJgorCQkgICAgIWJ0cmZzX2ZpbGVfZXh0ZW50X2NvbXByZXNzaW9uKGxlYWYsIGZp
KSAmJgorCQkgICAgIWJ0cmZzX2ZpbGVfZXh0ZW50X2VuY3J5cHRpb24obGVhZiwgZmkpICYm
CisJCSAgICAhYnRyZnNfZmlsZV9leHRlbnRfb3RoZXJfZW5jb2RpbmcobGVhZiwgZmkpICYm
CisJCSAgICBleHRlbnRfbGVuICsgZm91bmRfa2V5Lm9mZnNldCA9PSBzdGFydCkgeworCQkJ
YnRyZnNfc2V0X2ZpbGVfZXh0ZW50X251bV9ieXRlcyhsZWFmLCBmaSwKKwkJCQkJCQlleHRl
bnRfbGVuICsgbGVuKTsKKwkJCWJ0cmZzX21hcmtfYnVmZmVyX2RpcnR5KGxlYWYpOworCQkJ
aW5vZGVfYWRkX2J5dGVzKGlub2RlLCBsZW4pOworCisJCQlyZXQgPSAxOworCQkJZ290byBv
dXRfZnJlZV9wYXRoOworCQl9IGVsc2UgeworCQkJbWVyZ2UgPSBmYWxzZTsKKwkJCWJ0cmZz
X3JlbGVhc2VfcGF0aChwYXRoKTsKKwkJCWdvdG8gYWdhaW47CisJCX0KKwl9CisKKwlyZXQg
PSBidHJmc19pbnNlcnRfZW1wdHlfaXRlbSh0cmFucywgcm9vdCwgcGF0aCwgJmtleSwKKwkJ
CQkJc2l6ZW9mKCpleHRlbnQpKTsKKwlpZiAocmV0KSB7CisJCWJ0cmZzX2Fib3J0X3RyYW5z
YWN0aW9uKHRyYW5zLCByb290LCByZXQpOworCQlnb3RvIG91dF9mcmVlX3BhdGg7CisJfQor
CisJbGVhZiA9IHBhdGgtPm5vZGVzWzBdOworCWl0ZW0gPSBidHJmc19pdGVtX3B0cihsZWFm
LCBwYXRoLT5zbG90c1swXSwKKwkJCQlzdHJ1Y3QgYnRyZnNfZmlsZV9leHRlbnRfaXRlbSk7
CisJYnRyZnNfc2V0X2ZpbGVfZXh0ZW50X2Rpc2tfYnl0ZW5yKGxlYWYsIGl0ZW0sIG5ldy0+
Ynl0ZW5yKTsKKwlidHJmc19zZXRfZmlsZV9leHRlbnRfZGlza19udW1fYnl0ZXMobGVhZiwg
aXRlbSwgbmV3LT5kaXNrX2xlbik7CisJYnRyZnNfc2V0X2ZpbGVfZXh0ZW50X29mZnNldChs
ZWFmLCBpdGVtLCBzdGFydCAtIG5ldy0+ZmlsZV9wb3MpOworCWJ0cmZzX3NldF9maWxlX2V4
dGVudF9udW1fYnl0ZXMobGVhZiwgaXRlbSwgbGVuKTsKKwlidHJmc19zZXRfZmlsZV9leHRl
bnRfcmFtX2J5dGVzKGxlYWYsIGl0ZW0sIG5ldy0+bGVuKTsKKwlidHJmc19zZXRfZmlsZV9l
eHRlbnRfZ2VuZXJhdGlvbihsZWFmLCBpdGVtLCB0cmFucy0+dHJhbnNpZCk7CisJYnRyZnNf
c2V0X2ZpbGVfZXh0ZW50X3R5cGUobGVhZiwgaXRlbSwgQlRSRlNfRklMRV9FWFRFTlRfUkVH
KTsKKwlidHJmc19zZXRfZmlsZV9leHRlbnRfY29tcHJlc3Npb24obGVhZiwgaXRlbSwgbmV3
LT5jb21wcmVzc190eXBlKTsKKwlidHJmc19zZXRfZmlsZV9leHRlbnRfZW5jcnlwdGlvbihs
ZWFmLCBpdGVtLCAwKTsKKwlidHJmc19zZXRfZmlsZV9leHRlbnRfb3RoZXJfZW5jb2Rpbmco
bGVhZiwgaXRlbSwgMCk7CisKKwlidHJmc19tYXJrX2J1ZmZlcl9kaXJ0eShsZWFmKTsKKwlp
bm9kZV9hZGRfYnl0ZXMoaW5vZGUsIGxlbik7CisKKwlyZXQgPSBidHJmc19pbmNfZXh0ZW50
X3JlZih0cmFucywgcm9vdCwgbmV3LT5ieXRlbnIsCisJCQluZXctPmRpc2tfbGVuLCAwLAor
CQkJYmFja3JlZi0+cm9vdF9pZCwgYmFja3JlZi0+aW51bSwKKwkJCXN0YXJ0LCAwKTsKKwlp
ZiAocmV0KSB7CisJCWJ0cmZzX2Fib3J0X3RyYW5zYWN0aW9uKHRyYW5zLCByb290LCByZXQp
OworCQlnb3RvIG91dF9mcmVlX3BhdGg7CisJfQorCisJcmV0ID0gMTsKK291dF9mcmVlX3Bh
dGg6CisJYnRyZnNfcmVsZWFzZV9wYXRoKHBhdGgpOworCWJ0cmZzX2VuZF90cmFuc2FjdGlv
bih0cmFucywgcm9vdCk7CitvdXRfdW5sb2NrOgorCXVubG9ja19leHRlbnRfY2FjaGVkKCZC
VFJGU19JKGlub2RlKS0+aW9fdHJlZSwgYmFja3JlZi0+ZmlsZV9wb3MsCisJCQkgICAgIGJh
Y2tyZWYtPmZpbGVfcG9zICsgYmFja3JlZi0+bnVtX2J5dGVzLAorCQkJICAgICAmY2FjaGVk
LCBHRlBfTk9GUyk7CisJaXB1dChpbm9kZSk7CisJcmV0dXJuIHJldDsKK30KKworc3RhdGlj
IHZvaWQgcmVsaW5rX2ZpbGVfZXh0ZW50cyhzdHJ1Y3QgbmV3X3NhX2RlZnJhZ19leHRlbnQg
Km5ldykKK3sKKwlzdHJ1Y3QgYnRyZnNfcGF0aCAqcGF0aDsKKwlzdHJ1Y3Qgb2xkX3NhX2Rl
ZnJhZ19leHRlbnQgKm9sZCwgKnRtcDsKKwlzdHJ1Y3Qgc2FfZGVmcmFnX2V4dGVudF9iYWNr
cmVmICpiYWNrcmVmOworCXN0cnVjdCBzYV9kZWZyYWdfZXh0ZW50X2JhY2tyZWYgKnByZXYg
PSBOVUxMOworCXN0cnVjdCBpbm9kZSAqaW5vZGU7CisJc3RydWN0IGJ0cmZzX3Jvb3QgKnJv
b3Q7CisJc3RydWN0IHJiX25vZGUgKm5vZGU7CisJc3RydWN0IGV4dGVudF9zdGF0ZSAqY2Fj
aGVkID0gTlVMTDsKKwlpbnQgcmV0OworCisJaW5vZGUgPSBuZXctPmlub2RlOworCXJvb3Qg
PSBCVFJGU19JKGlub2RlKS0+cm9vdDsKKworCXBhdGggPSBidHJmc19hbGxvY19wYXRoKCk7
CisJaWYgKCFwYXRoKQorCQlyZXR1cm47CisKKwlpZiAoIXJlY29yZF9leHRlbnRfYmFja3Jl
ZnMocGF0aCwgbmV3KSkgeworCQlidHJmc19mcmVlX3BhdGgocGF0aCk7CisJCWdvdG8gb3V0
OworCX0KKwlidHJmc19yZWxlYXNlX3BhdGgocGF0aCk7CisKKwlsb2NrX2V4dGVudF9iaXRz
KCZCVFJGU19JKGlub2RlKS0+aW9fdHJlZSwgbmV3LT5maWxlX3BvcywKKwkJCSBuZXctPmZp
bGVfcG9zICsgbmV3LT5sZW4sIDAsICZjYWNoZWQpOworCisJd2hpbGUgKDEpIHsKKwkJbm9k
ZSA9IHJiX2ZpcnN0KCZuZXctPnJvb3QpOworCQlpZiAoIW5vZGUpCisJCQlicmVhazsKKwkJ
cmJfZXJhc2Uobm9kZSwgJm5ldy0+cm9vdCk7CisKKwkJYmFja3JlZiA9IHJiX2VudHJ5KG5v
ZGUsIHN0cnVjdCBzYV9kZWZyYWdfZXh0ZW50X2JhY2tyZWYsIG5vZGUpOworCisJCXJldCA9
IHJlbGlua19leHRlbnRfYmFja3JlZihwYXRoLCBwcmV2LCBiYWNrcmVmKTsKKwkJV0FSTl9P
TihyZXQgPCAwKTsKKworCQlrZnJlZShwcmV2KTsKKworCQlpZiAocmV0ID09IDEpCisJCQlw
cmV2ID0gYmFja3JlZjsKKwkJZWxzZQorCQkJcHJldiA9IE5VTEw7CisJCWNvbmRfcmVzY2hl
ZCgpOworCX0KKworCWtmcmVlKHByZXYpOworCisJdW5sb2NrX2V4dGVudF9jYWNoZWQoJkJU
UkZTX0koaW5vZGUpLT5pb190cmVlLCBuZXctPmZpbGVfcG9zLAorCQkJICAgICBuZXctPmZp
bGVfcG9zICsgbmV3LT5sZW4sICZjYWNoZWQsIEdGUF9OT0ZTKTsKKworCWJ0cmZzX2ZyZWVf
cGF0aChwYXRoKTsKKworCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShvbGQsIHRtcCwgJm5l
dy0+aGVhZCwgbGlzdCkgeworCQlsaXN0X2RlbCgmb2xkLT5saXN0KTsKKwkJa2ZyZWUob2xk
KTsKKwl9CitvdXQ6CisJYXRvbWljX2RlYygmcm9vdC0+ZnNfaW5mby0+ZGVmcmFnX3J1bm5p
bmcpOworCXdha2VfdXAoJnJvb3QtPmZzX2luZm8tPnRyYW5zYWN0aW9uX3dhaXQpOworCisJ
a2ZyZWUobmV3KTsKK30KKworc3RhdGljIHN0cnVjdCBuZXdfc2FfZGVmcmFnX2V4dGVudCAq
CityZWNvcmRfb2xkX2ZpbGVfZXh0ZW50cyhzdHJ1Y3QgaW5vZGUgKmlub2RlLAorCQkJc3Ry
dWN0IGJ0cmZzX29yZGVyZWRfZXh0ZW50ICpvcmRlcmVkKQoreworCXN0cnVjdCBidHJmc19y
b290ICpyb290ID0gQlRSRlNfSShpbm9kZSktPnJvb3Q7CisJc3RydWN0IGJ0cmZzX3BhdGgg
KnBhdGg7CisJc3RydWN0IGJ0cmZzX2tleSBrZXk7CisJc3RydWN0IG9sZF9zYV9kZWZyYWdf
ZXh0ZW50ICpvbGQsICp0bXA7CisJc3RydWN0IG5ld19zYV9kZWZyYWdfZXh0ZW50ICpuZXc7
CisJaW50IHJldDsKKworCW5ldyA9IGttYWxsb2Moc2l6ZW9mKCpuZXcpLCBHRlBfTk9GUyk7
CisJaWYgKCFuZXcpCisJCXJldHVybiBOVUxMOworCisJbmV3LT5pbm9kZSA9IGlub2RlOwor
CW5ldy0+ZmlsZV9wb3MgPSBvcmRlcmVkLT5maWxlX29mZnNldDsKKwluZXctPmxlbiA9IG9y
ZGVyZWQtPmxlbjsKKwluZXctPmJ5dGVuciA9IG9yZGVyZWQtPnN0YXJ0OworCW5ldy0+ZGlz
a19sZW4gPSBvcmRlcmVkLT5kaXNrX2xlbjsKKwluZXctPmNvbXByZXNzX3R5cGUgPSBvcmRl
cmVkLT5jb21wcmVzc190eXBlOworCW5ldy0+cm9vdCA9IFJCX1JPT1Q7CisJSU5JVF9MSVNU
X0hFQUQoJm5ldy0+aGVhZCk7CisKKwlwYXRoID0gYnRyZnNfYWxsb2NfcGF0aCgpOworCWlm
ICghcGF0aCkKKwkJZ290byBvdXRfa2ZyZWU7CisKKwlrZXkub2JqZWN0aWQgPSBidHJmc19p
bm8oaW5vZGUpOworCWtleS50eXBlID0gQlRSRlNfRVhURU5UX0RBVEFfS0VZOworCWtleS5v
ZmZzZXQgPSBuZXctPmZpbGVfcG9zOworCisJcmV0ID0gYnRyZnNfc2VhcmNoX3Nsb3QoTlVM
TCwgcm9vdCwgJmtleSwgcGF0aCwgMCwgMCk7CisJaWYgKHJldCA8IDApCisJCWdvdG8gb3V0
X2ZyZWVfcGF0aDsKKwlpZiAocmV0ID4gMCAmJiBwYXRoLT5zbG90c1swXSA+IDApCisJCXBh
dGgtPnNsb3RzWzBdLS07CisKKwkvKiBmaW5kIG91dCBhbGwgdGhlIG9sZCBleHRlbnRzIGZv
ciB0aGUgZmlsZSByYW5nZSAqLworCXdoaWxlICgxKSB7CisJCXN0cnVjdCBidHJmc19maWxl
X2V4dGVudF9pdGVtICpleHRlbnQ7CisJCXN0cnVjdCBleHRlbnRfYnVmZmVyICpsOworCQlp
bnQgc2xvdDsKKwkJdTY0IG51bV9ieXRlczsKKwkJdTY0IG9mZnNldDsKKwkJdTY0IGVuZDsK
KworCQlsID0gcGF0aC0+bm9kZXNbMF07CisJCXNsb3QgPSBwYXRoLT5zbG90c1swXTsKKwor
CQlpZiAoc2xvdCA+PSBidHJmc19oZWFkZXJfbnJpdGVtcyhsKSkgeworCQkJcmV0ID0gYnRy
ZnNfbmV4dF9sZWFmKHJvb3QsIHBhdGgpOworCQkJaWYgKHJldCA8IDApCisJCQkJZ290byBv
dXRfZnJlZV9saXN0OworCQkJZWxzZSBpZiAocmV0ID4gMCkKKwkJCQlicmVhazsKKwkJCWNv
bnRpbnVlOworCQl9CisKKwkJYnRyZnNfaXRlbV9rZXlfdG9fY3B1KGwsICZrZXksIHNsb3Qp
OworCisJCWlmIChrZXkub2JqZWN0aWQgIT0gYnRyZnNfaW5vKGlub2RlKSkKKwkJCWJyZWFr
OworCQlpZiAoa2V5LnR5cGUgIT0gQlRSRlNfRVhURU5UX0RBVEFfS0VZKQorCQkJYnJlYWs7
CisJCWlmIChrZXkub2Zmc2V0ID49IG5ldy0+ZmlsZV9wb3MgKyBuZXctPmxlbikKKwkJCWJy
ZWFrOworCisJCWV4dGVudCA9IGJ0cmZzX2l0ZW1fcHRyKGwsIHNsb3QsIHN0cnVjdCBidHJm
c19maWxlX2V4dGVudF9pdGVtKTsKKworCQludW1fYnl0ZXMgPSBidHJmc19maWxlX2V4dGVu
dF9udW1fYnl0ZXMobCwgZXh0ZW50KTsKKwkJaWYgKGtleS5vZmZzZXQgKyBudW1fYnl0ZXMg
PCBuZXctPmZpbGVfcG9zKQorCQkJZ290byBuZXh0OworCisJCW9sZCA9IGttYWxsb2Moc2l6
ZW9mKCpvbGQpLCBHRlBfTk9GUyk7CisJCWlmICghb2xkKQorCQkJZ290byBvdXRfZnJlZV9s
aXN0OworCisJCW9mZnNldCA9IG1heChuZXctPmZpbGVfcG9zLCBrZXkub2Zmc2V0KTsKKwkJ
ZW5kID0gbWluKG5ldy0+ZmlsZV9wb3MgKyBuZXctPmxlbiwga2V5Lm9mZnNldCArIG51bV9i
eXRlcyk7CisKKwkJb2xkLT5ieXRlbnIgPSBidHJmc19maWxlX2V4dGVudF9kaXNrX2J5dGVu
cihsLCBleHRlbnQpOworCQlvbGQtPmV4dGVudF9vZmZzZXQgPSBidHJmc19maWxlX2V4dGVu
dF9vZmZzZXQobCwgZXh0ZW50KTsKKwkJb2xkLT5vZmZzZXQgPSBvZmZzZXQgLSBrZXkub2Zm
c2V0OworCQlvbGQtPmxlbiA9IGVuZCAtIG9mZnNldDsKKwkJb2xkLT5uZXcgPSBuZXc7CisJ
CW9sZC0+Y291bnQgPSAwOworCQlsaXN0X2FkZF90YWlsKCZvbGQtPmxpc3QsICZuZXctPmhl
YWQpOworbmV4dDoKKwkJcGF0aC0+c2xvdHNbMF0rKzsKKwkJY29uZF9yZXNjaGVkKCk7CisJ
fQorCisJYnRyZnNfZnJlZV9wYXRoKHBhdGgpOworCWF0b21pY19pbmMoJnJvb3QtPmZzX2lu
Zm8tPmRlZnJhZ19ydW5uaW5nKTsKKworCXJldHVybiBuZXc7CisKK291dF9mcmVlX2xpc3Q6
CisJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKG9sZCwgdG1wLCAmbmV3LT5oZWFkLCBsaXN0
KSB7CisJCWxpc3RfZGVsKCZvbGQtPmxpc3QpOworCQlrZnJlZShvbGQpOworCX0KK291dF9m
cmVlX3BhdGg6CisJYnRyZnNfZnJlZV9wYXRoKHBhdGgpOworb3V0X2tmcmVlOgorCWtmcmVl
KG5ldyk7CisJcmV0dXJuIE5VTEw7Cit9CisKIC8qCiAgKiBoZWxwZXIgZnVuY3Rpb24gZm9y
IGJ0cmZzX2ZpbmlzaF9vcmRlcmVkX2lvLCB0aGlzCiAgKiBqdXN0IHJlYWRzIGluIHNvbWUg
b2YgdGhlIGNzdW0gbGVhdmVzIHRvIHByaW1lIHRoZW0gaW50byByYW0KQEAgLTE4NjQsNiAr
MjQ2Nyw3IEBAIHN0YXRpYyBpbnQgYnRyZnNfZmluaXNoX29yZGVyZWRfaW8oc3RydWN0IGJ0
cmZzX29yZGVyZWRfZXh0ZW50ICpvcmRlcmVkX2V4dGVudCkKIAlzdHJ1Y3QgYnRyZnNfdHJh
bnNfaGFuZGxlICp0cmFucyA9IE5VTEw7CiAJc3RydWN0IGV4dGVudF9pb190cmVlICppb190
cmVlID0gJkJUUkZTX0koaW5vZGUpLT5pb190cmVlOwogCXN0cnVjdCBleHRlbnRfc3RhdGUg
KmNhY2hlZF9zdGF0ZSA9IE5VTEw7CisJc3RydWN0IG5ld19zYV9kZWZyYWdfZXh0ZW50ICpu
ZXcgPSBOVUxMOwogCWludCBjb21wcmVzc190eXBlID0gMDsKIAlpbnQgcmV0OwogCWJvb2wg
bm9sb2NrOwpAQCAtMTkwMCw2ICsyNTA0LDE1IEBAIHN0YXRpYyBpbnQgYnRyZnNfZmluaXNo
X29yZGVyZWRfaW8oc3RydWN0IGJ0cmZzX29yZGVyZWRfZXh0ZW50ICpvcmRlcmVkX2V4dGVu
dCkKIAkJCSBvcmRlcmVkX2V4dGVudC0+ZmlsZV9vZmZzZXQgKyBvcmRlcmVkX2V4dGVudC0+
bGVuIC0gMSwKIAkJCSAwLCAmY2FjaGVkX3N0YXRlKTsKIAorCXJldCA9IHRlc3RfcmFuZ2Vf
Yml0KGlvX3RyZWUsIG9yZGVyZWRfZXh0ZW50LT5maWxlX29mZnNldCwKKwkJCW9yZGVyZWRf
ZXh0ZW50LT5maWxlX29mZnNldCArIG9yZGVyZWRfZXh0ZW50LT5sZW4gLSAxLAorCQkJRVhU
RU5UX0RFRlJBRywgMSwgY2FjaGVkX3N0YXRlKTsKKwlpZiAocmV0ICYmIGJ0cmZzX3Jvb3Rf
bGFzdF9zbmFwc2hvdCgmcm9vdC0+cm9vdF9pdGVtKSA+PQorCQkJCQkJQlRSRlNfSShpbm9k
ZSktPmdlbmVyYXRpb24pIHsKKwkJLyogdGhlIGlub2RlIGlzIHNoYXJlZCAqLworCQluZXcg
PSByZWNvcmRfb2xkX2ZpbGVfZXh0ZW50cyhpbm9kZSwgb3JkZXJlZF9leHRlbnQpOworCX0K
KwogCWlmIChub2xvY2spCiAJCXRyYW5zID0gYnRyZnNfam9pbl90cmFuc2FjdGlvbl9ub2xv
Y2socm9vdCk7CiAJZWxzZQpAQCAtMTk3Niw2ICsyNTg5LDEwIEBAIG91dDoKIAkgKi8KIAli
dHJmc19yZW1vdmVfb3JkZXJlZF9leHRlbnQoaW5vZGUsIG9yZGVyZWRfZXh0ZW50KTsKIAor
CS8qIGZvciBzbmFwc2hvdC1hd2FyZSBkZWZyYWcgKi8KKwlpZiAobmV3KQorCQlyZWxpbmtf
ZmlsZV9leHRlbnRzKG5ldyk7CisKIAkvKiBvbmNlIGZvciB1cyAqLwogCWJ0cmZzX3B1dF9v
cmRlcmVkX2V4dGVudChvcmRlcmVkX2V4dGVudCk7CiAJLyogb25jZSBmb3IgdGhlIHRyZWUg
Ki8KLS0gCjEuNy43LjYKCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGZvci1qYW4vMDAwMS1C
dHJmcy1kZWJ1Zy1wYXJ0LTEucGF0Y2gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwMDAwNjQ0ADAwMDAwMDAAMDAwMDAw
MAAwMDAwMDAxNTcwMQAxMjAzNzU0NTAyNAAwMTU3NjMAIDAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdXN0YXIgIAByb290AAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAHJvb3QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAARnJvbSBiZjk1MWRhNGI5YTI4ZDU3NTA4NmVjYjY4ZGQxZjY2NTU2OTli
YzRhIE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgQm8gPGxpdWIubGl1Ym9A
Z21haWwuY29tPgpEYXRlOiBXZWQsIDE3IE9jdCAyMDEyIDIyOjU3OjQzICswODAwClN1Ympl
Y3Q6IFtQQVRDSCAxLzJdIEJ0cmZzOiBkZWJ1ZyBwYXJ0IDEKClNpZ25lZC1vZmYtYnk6IExp
dSBCbyA8bGl1Yi5saXVib0BnbWFpbC5jb20+Ci0tLQogZnMvYnRyZnMvaW5vZGUuYyB8ICAg
ODcgKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0KIDEgZmlsZXMgY2hhbmdlZCwgMzkgaW5zZXJ0aW9ucygrKSwgNDggZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvZnMvYnRyZnMvaW5vZGUuYyBiL2ZzL2J0cmZzL2lub2RlLmMKaW5k
ZXggMmM3ODVjMC4uN2RjNDMyMyAxMDA2NDQKLS0tIGEvZnMvYnRyZnMvaW5vZGUuYworKysg
Yi9mcy9idHJmcy9pbm9kZS5jCkBAIC0xODkzLDcgKzE4OTMsNiBAQCBzdGF0aWMgaW50IGJh
Y2tyZWZfY29tcChzdHJ1Y3Qgc2FfZGVmcmFnX2V4dGVudF9iYWNrcmVmICpiMSwKIAllbHNl
IGlmIChiMS0+ZmlsZV9wb3MgPiBiMi0+ZmlsZV9wb3MpCiAJCXJldHVybiAxOwogCi0JV0FS
Tl9PTigxKTsKIAlyZXR1cm4gMDsKIH0KIApAQCAtMTkxMiwxMCArMTkxMSw4IEBAIHN0YXRp
YyB2b2lkIGJhY2tyZWZfaW5zZXJ0KHN0cnVjdCByYl9yb290ICpyb290LAogCQlyZXQgPSBi
YWNrcmVmX2NvbXAoYmFja3JlZiwgZW50cnkpOwogCQlpZiAocmV0IDwgMCkKIAkJCXAgPSAm
KCpwKS0+cmJfbGVmdDsKLQkJZWxzZSBpZiAocmV0ID4gMCkKLQkJCXAgPSAmKCpwKS0+cmJf
cmlnaHQ7CiAJCWVsc2UKLQkJCUJVR19PTigxKTsKKwkJCXAgPSAmKCpwKS0+cmJfcmlnaHQ7
CiAJfQogCiAJcmJfbGlua19ub2RlKCZiYWNrcmVmLT5ub2RlLCBwYXJlbnQsIHApOwpAQCAt
MTk5Niw3ICsxOTkzLDEwIEBAIHN0YXRpYyBub2lubGluZSBpbnQgcmVjb3JkX29uZV9iYWNr
cmVmKHU2NCBpbnVtLCB1NjQgb2Zmc2V0LCB1NjQgcm9vdF9pZCwKIAogCQlidHJmc19pdGVt
X2tleV90b19jcHUobGVhZiwgJmtleSwgc2xvdCk7CiAKLQkJaWYgKGtleS5vYmplY3RpZCAh
PSBpbnVtIHx8IGtleS50eXBlICE9IEJUUkZTX0VYVEVOVF9EQVRBX0tFWSkKKwkJaWYgKGtl
eS5vYmplY3RpZCA+IGludW0pCisJCQlnb3RvIG91dDsKKworCQlpZiAoa2V5Lm9iamVjdGlk
IDwgaW51bSB8fCBrZXkudHlwZSAhPSBCVFJGU19FWFRFTlRfREFUQV9LRVkpCiAJCQljb250
aW51ZTsKIAogCQlleHRlbnQgPSBidHJmc19pdGVtX3B0cihsZWFmLCBzbG90LApAQCAtMjAw
NSwyMCArMjAwNSwxOCBAQCBzdGF0aWMgbm9pbmxpbmUgaW50IHJlY29yZF9vbmVfYmFja3Jl
Zih1NjQgaW51bSwgdTY0IG9mZnNldCwgdTY0IHJvb3RfaWQsCiAJCWlmIChidHJmc19maWxl
X2V4dGVudF9kaXNrX2J5dGVucihsZWFmLCBleHRlbnQpICE9IG9sZC0+Ynl0ZW5yKQogCQkJ
Y29udGludWU7CiAKLQkJaWYgKGtleS5vZmZzZXQgLSBidHJmc19maWxlX2V4dGVudF9vZmZz
ZXQobGVhZiwgZXh0ZW50KSAhPQotCQkgICAgb2Zmc2V0KQorCQlleHRlbnRfb2Zmc2V0ID0g
YnRyZnNfZmlsZV9leHRlbnRfb2Zmc2V0KGxlYWYsIGV4dGVudCk7CisJCWlmIChrZXkub2Zm
c2V0IC0gZXh0ZW50X29mZnNldCAhPSBvZmZzZXQpCisJCQljb250aW51ZTsKKworCQludW1f
Ynl0ZXMgPSBidHJmc19maWxlX2V4dGVudF9udW1fYnl0ZXMobGVhZiwgZXh0ZW50KTsKKwkJ
aWYgKGV4dGVudF9vZmZzZXQgPj0gb2xkLT5leHRlbnRfb2Zmc2V0ICsgb2xkLT5vZmZzZXQg
KyBvbGQtPmxlbiB8fAorCQkgICAgZXh0ZW50X29mZnNldCArIG51bV9ieXRlcyA8PSBvbGQt
PmV4dGVudF9vZmZzZXQgKyBvbGQtPm9mZnNldCkKIAkJCWNvbnRpbnVlOwogCiAJCWJyZWFr
OwogCX0KIAotCWV4dGVudF9vZmZzZXQgPSBidHJmc19maWxlX2V4dGVudF9vZmZzZXQobGVh
ZiwgZXh0ZW50KTsKLQludW1fYnl0ZXMgPSBidHJmc19maWxlX2V4dGVudF9udW1fYnl0ZXMo
bGVhZiwgZXh0ZW50KTsKLQotCWlmIChleHRlbnRfb2Zmc2V0ID49IG9sZC0+ZXh0ZW50X29m
ZnNldCArIG9sZC0+b2Zmc2V0ICsgb2xkLT5sZW4gfHwKLQkgICAgZXh0ZW50X29mZnNldCAr
IG51bV9ieXRlcyA8IG9sZC0+ZXh0ZW50X29mZnNldCArIG9sZC0+b2Zmc2V0KQotCQlnb3Rv
IG91dDsKLQogCWJhY2tyZWYgPSBrbWFsbG9jKHNpemVvZigqYmFja3JlZiksIEdGUF9OT0ZT
KTsKIAlpZiAoIWJhY2tyZWYpIHsKIAkJcmV0ID0gLUVOT0VOVDsKQEAgLTIwNTMsNyArMjA1
MSw3IEBAIHN0YXRpYyBub2lubGluZSBib29sIHJlY29yZF9leHRlbnRfYmFja3JlZnMoc3Ry
dWN0IGJ0cmZzX3BhdGggKnBhdGgsCiAJCXJldCA9IGl0ZXJhdGVfaW5vZGVzX2Zyb21fbG9n
aWNhbChvbGQtPmJ5dGVuciwgZnNfaW5mbywKIAkJCQkJCSAgcGF0aCwgcmVjb3JkX29uZV9i
YWNrcmVmLAogCQkJCQkJICBvbGQpOwotCQlXQVJOX09OKHJldCA8IDApOworCQlCVUdfT04o
cmV0IDwgMCAmJiByZXQgIT0gLUVOT0VOVCk7CiAKIAkJLyogbm8gYmFja3JlZiB0byBiZSBw
cm9jZXNzZWQgZm9yIHRoaXMgZXh0ZW50ICovCiAJCWlmICghb2xkLT5jb3VudCkgewpAQCAt
MjA5MSwxMSArMjA4OSwxMiBAQCBzdGF0aWMgbm9pbmxpbmUgaW50IHJlbGlua19leHRlbnRf
YmFja3JlZihzdHJ1Y3QgYnRyZnNfcGF0aCAqcGF0aCwKIAlpbnQgcmV0ID0gMDsKIAl1NjQg
c3RhcnQ7CiAJdTY0IGxlbjsKKwl1NjQgbG9ja19zdGFydDsKKwl1NjQgbG9ja19lbmQ7CiAJ
Ym9vbCBtZXJnZSA9IGZhbHNlOwogCiAJaWYgKHByZXYgJiYgcHJldi0+cm9vdF9pZCA9PSBi
YWNrcmVmLT5yb290X2lkICYmCiAJICAgIHByZXYtPmludW0gPT0gYmFja3JlZi0+aW51bSAm
JgotCSAgICBwcmV2LT5leHRlbnRfb2Zmc2V0ID09IGJhY2tyZWYtPmV4dGVudF9vZmZzZXQg
JiYKIAkgICAgcHJldi0+ZmlsZV9wb3MgKyBwcmV2LT5udW1fYnl0ZXMgPT0gYmFja3JlZi0+
ZmlsZV9wb3MpCiAJCW1lcmdlID0gdHJ1ZTsKIApAQCAtMjEyMiwyNiArMjEyMSwxNSBAQCBz
dGF0aWMgbm9pbmxpbmUgaW50IHJlbGlua19leHRlbnRfYmFja3JlZihzdHJ1Y3QgYnRyZnNf
cGF0aCAqcGF0aCwKIAkJcmV0dXJuIDA7CiAJfQogCi0JbG9ja19leHRlbnRfYml0cygmQlRS
RlNfSShpbm9kZSktPmlvX3RyZWUsIGJhY2tyZWYtPmZpbGVfcG9zLAotCQkJIGJhY2tyZWYt
PmZpbGVfcG9zICsgYmFja3JlZi0+bnVtX2J5dGVzLCAwLCAmY2FjaGVkKTsKLQotCW9yZGVy
ZWQgPSBidHJmc19sb29rdXBfZmlyc3Rfb3JkZXJlZF9leHRlbnQoaW5vZGUsCi0JCQkJCQkg
ICAgYmFja3JlZi0+ZmlsZV9wb3MgKwotCQkJCQkJICAgIGJhY2tyZWYtPm51bV9ieXRlcyk7
Ci0JaWYgKG9yZGVyZWQpIHsKLQkJYnRyZnNfcHV0X29yZGVyZWRfZXh0ZW50KG9yZGVyZWQp
OwotCQlnb3RvIG91dF91bmxvY2s7Ci0JfQotCiAJLyoKIAkgKiAxIGZvciBkcm9wX2V4dGVu
dHMKIAkgKiAxIGZvciBtZXJnZSBjbGF1c2UncyBzZWFyY2hfc2xvdAogCSAqIDEgZm9yIGlu
c2VydCBpdGVtcwogCSAqLwotCXRyYW5zID0gYnRyZnNfc3RhcnRfdHJhbnNhY3Rpb24ocm9v
dCwgMyk7CisJdHJhbnMgPSBidHJmc19qb2luX3RyYW5zYWN0aW9uKHJvb3QpOwogCWlmIChJ
U19FUlIodHJhbnMpKSB7CiAJCXJldCA9IFBUUl9FUlIodHJhbnMpOwotCQlnb3RvIG91dF91
bmxvY2s7CisJCWdvdG8gb3V0X2ZyZWVfcGF0aDsKIAl9CiAKIAlrZXkub2JqZWN0aWQgPSBi
YWNrcmVmLT5pbnVtOwpAQCAtMjE3NCwxMCArMjE2MiwyMSBAQCBzdGF0aWMgbm9pbmxpbmUg
aW50IHJlbGlua19leHRlbnRfYmFja3JlZihzdHJ1Y3QgYnRyZnNfcGF0aCAqcGF0aCwKIAkJ
ICBvbGQtPmV4dGVudF9vZmZzZXQgKyBvbGQtPm9mZnNldCArIG9sZC0+bGVuKTsKIAlsZW4g
LT0gbWF4KGJhY2tyZWYtPmV4dGVudF9vZmZzZXQsIG9sZC0+ZXh0ZW50X29mZnNldCArIG9s
ZC0+b2Zmc2V0KTsKIAorCWxvY2tfc3RhcnQgPSBiYWNrcmVmLT5maWxlX3BvczsKKwlsb2Nr
X2VuZCA9IGJhY2tyZWYtPmZpbGVfcG9zICsgYmFja3JlZi0+bnVtX2J5dGVzIC0gMTsKKwls
b2NrX2V4dGVudF9iaXRzKCZCVFJGU19JKGlub2RlKS0+aW9fdHJlZSwgbG9ja19zdGFydCwg
bG9ja19lbmQsIDAsICZjYWNoZWQpOworCisJb3JkZXJlZCA9IGJ0cmZzX2xvb2t1cF9maXJz
dF9vcmRlcmVkX2V4dGVudChpbm9kZSwgbG9ja19lbmQpOworCWlmIChvcmRlcmVkKSB7CisJ
CWJ0cmZzX3B1dF9vcmRlcmVkX2V4dGVudChvcmRlcmVkKTsKKwkJZ290byBvdXRfdW5sb2Nr
OworCX0KKworCiAJcmV0ID0gYnRyZnNfZHJvcF9leHRlbnRzKHRyYW5zLCBCVFJGU19JKGlu
b2RlKS0+cm9vdCwgaW5vZGUsIHN0YXJ0LAogCQkJCSBzdGFydCArIGxlbiwgMSk7CiAJaWYg
KHJldCkKLQkJZ290byBvdXRfZnJlZV9wYXRoOworCQlnb3RvIG91dF91bmxvY2s7CiBhZ2Fp
bjoKIAlrZXkub2JqZWN0aWQgPSBidHJmc19pbm8oaW5vZGUpOwogCWtleS50eXBlID0gQlRS
RlNfRVhURU5UX0RBVEFfS0VZOwpAQCAtMjE5MCw3ICsyMTg5LDcgQEAgYWdhaW46CiAKIAkJ
cmV0ID0gYnRyZnNfc2VhcmNoX3Nsb3QodHJhbnMsIHJvb3QsICZrZXksIHBhdGgsIDEsIDEp
OwogCQlpZiAocmV0IDwgMCkKLQkJCWdvdG8gb3V0X2ZyZWVfcGF0aDsKKwkJCWdvdG8gb3V0
X3VubG9jazsKIAogCQlwYXRoLT5zbG90c1swXS0tOwogCQlsZWFmID0gcGF0aC0+bm9kZXNb
MF07CkBAIC0yMjEyLDcgKzIyMTEsNyBAQCBhZ2FpbjoKIAkJCWlub2RlX2FkZF9ieXRlcyhp
bm9kZSwgbGVuKTsKIAogCQkJcmV0ID0gMTsKLQkJCWdvdG8gb3V0X2ZyZWVfcGF0aDsKKwkJ
CWdvdG8gb3V0X3VubG9jazsKIAkJfSBlbHNlIHsKIAkJCW1lcmdlID0gZmFsc2U7CiAJCQli
dHJmc19yZWxlYXNlX3BhdGgocGF0aCk7CkBAIC0yMjI0LDcgKzIyMjMsNyBAQCBhZ2FpbjoK
IAkJCQkJc2l6ZW9mKCpleHRlbnQpKTsKIAlpZiAocmV0KSB7CiAJCWJ0cmZzX2Fib3J0X3Ry
YW5zYWN0aW9uKHRyYW5zLCByb290LCByZXQpOwotCQlnb3RvIG91dF9mcmVlX3BhdGg7CisJ
CWdvdG8gb3V0X3VubG9jazsKIAl9CiAKIAlsZWFmID0gcGF0aC0+bm9kZXNbMF07CkBAIC0y
MjQ3LDIwICsyMjQ2LDE5IEBAIGFnYWluOgogCXJldCA9IGJ0cmZzX2luY19leHRlbnRfcmVm
KHRyYW5zLCByb290LCBuZXctPmJ5dGVuciwKIAkJCW5ldy0+ZGlza19sZW4sIDAsCiAJCQli
YWNrcmVmLT5yb290X2lkLCBiYWNrcmVmLT5pbnVtLAotCQkJc3RhcnQsIDApOworCQkJbmV3
LT5maWxlX3BvcywgMCk7CS8qIHN0YXJ0IC0gZXh0ZW50X29mZnNldCAqLwogCWlmIChyZXQp
IHsKIAkJYnRyZnNfYWJvcnRfdHJhbnNhY3Rpb24odHJhbnMsIHJvb3QsIHJldCk7Ci0JCWdv
dG8gb3V0X2ZyZWVfcGF0aDsKKwkJZ290byBvdXRfdW5sb2NrOwogCX0KIAogCXJldCA9IDE7
CitvdXRfdW5sb2NrOgorCXVubG9ja19leHRlbnRfY2FjaGVkKCZCVFJGU19JKGlub2RlKS0+
aW9fdHJlZSwgbG9ja19zdGFydCwgbG9ja19lbmQsICZjYWNoZWQsIEdGUF9OT0ZTKTsKIG91
dF9mcmVlX3BhdGg6CiAJYnRyZnNfcmVsZWFzZV9wYXRoKHBhdGgpOwotCWJ0cmZzX2VuZF90
cmFuc2FjdGlvbih0cmFucywgcm9vdCk7Ci1vdXRfdW5sb2NrOgotCXVubG9ja19leHRlbnRf
Y2FjaGVkKCZCVFJGU19JKGlub2RlKS0+aW9fdHJlZSwgYmFja3JlZi0+ZmlsZV9wb3MsCi0J
CQkgICAgIGJhY2tyZWYtPmZpbGVfcG9zICsgYmFja3JlZi0+bnVtX2J5dGVzLAotCQkJICAg
ICAmY2FjaGVkLCBHRlBfTk9GUyk7CisJaWYgKHRyYW5zKQorCQlidHJmc19lbmRfdHJhbnNh
Y3Rpb24odHJhbnMsIHJvb3QpOwogCWlwdXQoaW5vZGUpOwogCXJldHVybiByZXQ7CiB9CkBA
IC0yMjc0LDcgKzIyNzIsNiBAQCBzdGF0aWMgdm9pZCByZWxpbmtfZmlsZV9leHRlbnRzKHN0
cnVjdCBuZXdfc2FfZGVmcmFnX2V4dGVudCAqbmV3KQogCXN0cnVjdCBpbm9kZSAqaW5vZGU7
CiAJc3RydWN0IGJ0cmZzX3Jvb3QgKnJvb3Q7CiAJc3RydWN0IHJiX25vZGUgKm5vZGU7Ci0J
c3RydWN0IGV4dGVudF9zdGF0ZSAqY2FjaGVkID0gTlVMTDsKIAlpbnQgcmV0OwogCiAJaW5v
ZGUgPSBuZXctPmlub2RlOwpAQCAtMjI5MCw5ICsyMjg3LDYgQEAgc3RhdGljIHZvaWQgcmVs
aW5rX2ZpbGVfZXh0ZW50cyhzdHJ1Y3QgbmV3X3NhX2RlZnJhZ19leHRlbnQgKm5ldykKIAl9
CiAJYnRyZnNfcmVsZWFzZV9wYXRoKHBhdGgpOwogCi0JbG9ja19leHRlbnRfYml0cygmQlRS
RlNfSShpbm9kZSktPmlvX3RyZWUsIG5ldy0+ZmlsZV9wb3MsCi0JCQkgbmV3LT5maWxlX3Bv
cyArIG5ldy0+bGVuLCAwLCAmY2FjaGVkKTsKLQogCXdoaWxlICgxKSB7CiAJCW5vZGUgPSBy
Yl9maXJzdCgmbmV3LT5yb290KTsKIAkJaWYgKCFub2RlKQpAQCAtMjMxMiwxMiArMjMwNiw4
IEBAIHN0YXRpYyB2b2lkIHJlbGlua19maWxlX2V4dGVudHMoc3RydWN0IG5ld19zYV9kZWZy
YWdfZXh0ZW50ICpuZXcpCiAJCQlwcmV2ID0gTlVMTDsKIAkJY29uZF9yZXNjaGVkKCk7CiAJ
fQotCiAJa2ZyZWUocHJldik7CiAKLQl1bmxvY2tfZXh0ZW50X2NhY2hlZCgmQlRSRlNfSShp
bm9kZSktPmlvX3RyZWUsIG5ldy0+ZmlsZV9wb3MsCi0JCQkgICAgIG5ldy0+ZmlsZV9wb3Mg
KyBuZXctPmxlbiwgJmNhY2hlZCwgR0ZQX05PRlMpOwotCiAJYnRyZnNfZnJlZV9wYXRoKHBh
dGgpOwogCiAJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKG9sZCwgdG1wLCAmbmV3LT5oZWFk
LCBsaXN0KSB7CkBAIC0yNDEzLDYgKzI0MDMsNyBAQCByZWNvcmRfb2xkX2ZpbGVfZXh0ZW50
cyhzdHJ1Y3QgaW5vZGUgKmlub2RlLAogCQllbmQgPSBtaW4obmV3LT5maWxlX3BvcyArIG5l
dy0+bGVuLCBrZXkub2Zmc2V0ICsgbnVtX2J5dGVzKTsKIAogCQlvbGQtPmJ5dGVuciA9IGJ0
cmZzX2ZpbGVfZXh0ZW50X2Rpc2tfYnl0ZW5yKGwsIGV4dGVudCk7CisJCUJVR19PTighb2xk
LT5ieXRlbnIpOwogCQlvbGQtPmV4dGVudF9vZmZzZXQgPSBidHJmc19maWxlX2V4dGVudF9v
ZmZzZXQobCwgZXh0ZW50KTsKIAkJb2xkLT5vZmZzZXQgPSBvZmZzZXQgLSBrZXkub2Zmc2V0
OwogCQlvbGQtPmxlbiA9IGVuZCAtIG9mZnNldDsKLS0gCjEuNy43LjYKCgAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGZv
ci1qYW4vMDAwMi1CdHJmcy1kZWJ1Zy1wYXJ0LTIucGF0Y2gAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwMDAwNjQ0ADAw
MDAwMDAAMDAwMDAwMAAwMDAwMDAwNTY1MQAxMjAzNzU0NTAyNAAwMTU3NzAAIDAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdXN0YXIgIAByb290AAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHJvb3QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARnJvbSA4N2NmYTUzYjJiODU2OGQxMTNhNjJjZmZk
MDI2ZDEwOTZlNjU4MzVmIE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgQm8g
PGxpdWIubGl1Ym9AZ21haWwuY29tPgpEYXRlOiBXZWQsIDE3IE9jdCAyMDEyIDIyOjU5OjIy
ICswODAwClN1YmplY3Q6IFtQQVRDSCAyLzJdIEJ0cmZzOiBkZWJ1ZyBwYXJ0IDIKClNpZ25l
ZC1vZmYtYnk6IExpdSBCbyA8bGl1Yi5saXVib0BnbWFpbC5jb20+Ci0tLQogZnMvYnRyZnMv
Y3RyZWUuYyB8ICAgMTggKysrKysrKysrKysrKysrKysrCiAxIGZpbGVzIGNoYW5nZWQsIDE4
IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvYnRyZnMv
Y3RyZWUuYyBiL2ZzL2J0cmZzL2N0cmVlLmMKaW5kZXggYjMzNDM2Mi4uZmY4MjMwZiAxMDA2
NDQKLS0tIGEvZnMvYnRyZnMvY3RyZWUuYworKysgYi9mcy9idHJmcy9jdHJlZS5jCkBAIC0z
NzksNiArMzc5LDggQEAgdTY0IGJ0cmZzX2dldF90cmVlX21vZF9zZXEoc3RydWN0IGJ0cmZz
X2ZzX2luZm8gKmZzX2luZm8sCiAJaWYgKCFlbGVtLT5zZXEpIHsKIAkJZWxlbS0+c2VxID0g
YnRyZnNfaW5jX3RyZWVfbW9kX3NlcShmc19pbmZvKTsKIAkJbGlzdF9hZGRfdGFpbCgmZWxl
bS0+bGlzdCwgJmZzX2luZm8tPnRyZWVfbW9kX3NlcV9saXN0KTsKKworCQlCVUdfT04oKGZz
X2luZm8tPnRyZWVfbW9kX3NlcV9saXN0LnByZXYpLT5uZXh0ICE9ICgmZnNfaW5mby0+dHJl
ZV9tb2Rfc2VxX2xpc3QpKTsKIAl9CiAJc2VxID0gYnRyZnNfaW5jX3RyZWVfbW9kX3NlcShm
c19pbmZvKTsKIAlzcGluX3VubG9jaygmZnNfaW5mby0+dHJlZV9tb2Rfc2VxX2xvY2spOwpA
QCAtNDAzLDkgKzQwNSwxMSBAQCB2b2lkIGJ0cmZzX3B1dF90cmVlX21vZF9zZXEoc3RydWN0
IGJ0cmZzX2ZzX2luZm8gKmZzX2luZm8sCiAKIAlzcGluX2xvY2soJmZzX2luZm8tPnRyZWVf
bW9kX3NlcV9sb2NrKTsKIAlsaXN0X2RlbCgmZWxlbS0+bGlzdCk7CisKIAllbGVtLT5zZXEg
PSAwOwogCiAJbGlzdF9mb3JfZWFjaF9lbnRyeShjdXJfZWxlbSwgJmZzX2luZm8tPnRyZWVf
bW9kX3NlcV9saXN0LCBsaXN0KSB7CisJCUJVR19PTighY3VyX2VsZW0pOwogCQlpZiAoY3Vy
X2VsZW0tPnNlcSA8IG1pbl9zZXEpIHsKIAkJCWlmIChzZXFfcHV0dGluZyA+IGN1cl9lbGVt
LT5zZXEpIHsKIAkJCQkvKgpAQCAtMTEzMSw2ICsxMTM1LDcgQEAgX190cmVlX21vZF9sb2df
cmV3aW5kKHN0cnVjdCBleHRlbnRfYnVmZmVyICplYiwgdTY0IHRpbWVfc2VxLAogCXVuc2ln
bmVkIGxvbmcgb19kc3Q7CiAJdW5zaWduZWQgbG9uZyBvX3NyYzsKIAl1bnNpZ25lZCBsb25n
IHBfc2l6ZSA9IHNpemVvZihzdHJ1Y3QgYnRyZnNfa2V5X3B0cik7CisJaW50IHJtID0gMCwg
YWRkID0gMDs7CiAKIAluID0gYnRyZnNfaGVhZGVyX25yaXRlbXMoZWIpOwogCXdoaWxlICh0
bSAmJiB0bS0+c2VxID49IHRpbWVfc2VxKSB7CkBAIC0xMTQ5LDYgKzExNTQsNyBAQCBfX3Ry
ZWVfbW9kX2xvZ19yZXdpbmQoc3RydWN0IGV4dGVudF9idWZmZXIgKmViLCB1NjQgdGltZV9z
ZXEsCiAJCQlidHJmc19zZXRfbm9kZV9wdHJfZ2VuZXJhdGlvbihlYiwgdG0tPnNsb3QsCiAJ
CQkJCQkgICAgICB0bS0+Z2VuZXJhdGlvbik7CiAJCQluKys7CisJCQlybSsrOwogCQkJYnJl
YWs7CiAJCWNhc2UgTU9EX0xPR19LRVlfUkVQTEFDRToKIAkJCUJVR19PTih0bS0+c2xvdCA+
PSBuKTsKQEAgLTExNjAsNiArMTE2Niw3IEBAIF9fdHJlZV9tb2RfbG9nX3Jld2luZChzdHJ1
Y3QgZXh0ZW50X2J1ZmZlciAqZWIsIHU2NCB0aW1lX3NlcSwKIAkJY2FzZSBNT0RfTE9HX0tF
WV9BREQ6CiAJCQkvKiBpZiBhIG1vdmUgb3BlcmF0aW9uIGlzIG5lZWRlZCBpdCdzIGluIHRo
ZSBsb2cgKi8KIAkJCW4tLTsKKwkJCWFkZCA9IDA7CiAJCQlicmVhazsKIAkJY2FzZSBNT0Rf
TE9HX01PVkVfS0VZUzoKIAkJCW9fZHN0ID0gYnRyZnNfbm9kZV9rZXlfcHRyX29mZnNldCh0
bS0+c2xvdCk7CkBAIC0xMTg2LDYgKzExOTMsMTAgQEAgX190cmVlX21vZF9sb2dfcmV3aW5k
KHN0cnVjdCBleHRlbnRfYnVmZmVyICplYiwgdTY0IHRpbWVfc2VxLAogCQlpZiAodG0tPmlu
ZGV4ICE9IGZpcnN0X3RtLT5pbmRleCkKIAkJCWJyZWFrOwogCX0KKwlpZiAobiA+IDEzMCB8
fCAoaW50KW4gPCAwKSB7CisJCXByaW50aygiZWItPnN0YXJ0ICVsbHUgZWItPmxlbiAlbGx1
IGViLT5sZXZlbCAlZCBucml0ZW1zICVkIG4gJWQgcm0gJWQgYWRkICVkXG4iLAorCQkJZWIt
PnN0YXJ0LCBlYi0+bGVuLCBidHJmc19oZWFkZXJfbGV2ZWwoZWIpLCBidHJmc19oZWFkZXJf
bnJpdGVtcyhlYiksIG4sIHJtLCBhZGQpOworCX0KIAlidHJmc19zZXRfaGVhZGVyX25yaXRl
bXMoZWIsIG4pOwogfQogCkBAIC0xNTY0LDYgKzE1NzUsMTMgQEAgc3RhdGljIG5vaW5saW5l
IGludCBnZW5lcmljX2Jpbl9zZWFyY2goc3RydWN0IGV4dGVudF9idWZmZXIgKmViLAogCQlt
aWQgPSAobG93ICsgaGlnaCkgLyAyOwogCQlvZmZzZXQgPSBwICsgbWlkICogaXRlbV9zaXpl
OwogCisJCWlmIChvZmZzZXQgKyBzaXplb2Yoc3RydWN0IGJ0cmZzX2Rpc2tfa2V5KSA+IGVi
LT5sZW4pIHsKKwkJCXByaW50aygib2Zmc2V0ICVsbHUgbWluX2xlbiAlZCBlYi0+c3RhcnQg
JWxsdSBlYi0+bGVuICVsbHUsIGViLT5sZXZlbCAlZCBwICVsbHUgbWlkICVkIGxvdyAlZCBo
aWdoICVkIGl0ZW0gJWQgbWF4ICVkXG4iLAorCQkJCW9mZnNldCwgc2l6ZW9mKHN0cnVjdCBi
dHJmc19kaXNrX2tleSksIGViLT5zdGFydCwgZWItPmxlbiwgYnRyZnNfaGVhZGVyX2xldmVs
KGViKSwKKwkJCQlwLCBtaWQsIGxvdywgaGlnaCwgaXRlbV9zaXplLCBtYXgpOworCQkJQlVH
X09OKDEpOworCQl9CisKIAkJaWYgKCFrYWRkciB8fCBvZmZzZXQgPCBtYXBfc3RhcnQgfHwK
IAkJICAgIChvZmZzZXQgKyBzaXplb2Yoc3RydWN0IGJ0cmZzX2Rpc2tfa2V5KSkgPgogCQkg
ICAgbWFwX3N0YXJ0ICsgbWFwX2xlbikgewotLSAKMS43LjcuNgoKAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
--------------060301030907060000020906--
