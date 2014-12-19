Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:50195 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaLSX2Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 18:28:25 -0500
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 6613724FD4
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 00:28:23 +0100 (CET)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7nSiff9ClmiS for <linux-btrfs@vger.kernel.org>;
	Sat, 20 Dec 2014 00:28:22 +0100 (CET)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 00:28:22 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 20 Dec 2014 00:28:22 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: kernel BUG at /home/apw/COD/linux/fs/btrfs/inode.c:3123!
Message-ID: <c1ba36ab05ed307b268eb5cad622d0fc@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Get this BUG with 3.18.1 (pasted at the bottom of the email).
Below all actions from creating the fs to BUG. I did not attempt to 
reproduce.

# mkfs.btrfs /dev/vdb
Btrfs v3.17.3
See http://btrfs.wiki.kernel.org for more information.

Turning ON incompat feature 'extref': increased hardlink limit per file 
to 65536
fs created label (null) on /dev/vdb
         nodesize 16384 leafsize 16384 sectorsize 4096 size 256.00GiB

# mount -o noatime /dev/vdb /mnt/test/
# cd /mnt/test
# btrfs sub cre subvolume
Create subvolume './subvolume'
# dd if=/dev/urandom of=bigfile.img bs=64k
^C91758+0 records in
91757+0 records out
6013386752 bytes (6.0 GB) copied, 374.777 s, 16.0 MB/s
# btrfs sub list /mnt/test/
ID 257 gen 16 top level 5 path subvolume

# btrfs quota enable /mnt/test

# btrfs qgroup show /mnt/test
qgroupid rfer       excl
-------- ----       ----
0/5      16384      16384
0/257    6013403136 6013403136

# dd if=/dev/urandom of=bigfile2.img bs=64k
^C47721+0 records in
47720+0 records out
3127377920 bytes (3.1 GB) copied, 194.641 s, 16.1 MB/s

# btrfs qgroup show /mnt/test
qgroupid rfer       excl
-------- ----       ----
0/5      16384      16384
0/257    8704049152 8704049152
root@srv2:/mnt/test/subvolume# sync
root@srv2:/mnt/test/subvolume# btrfs qgroup show /mnt/test
qgroupid rfer       excl
-------- ----       ----
0/5      16384      16384
0/257    9140781056 9140781056

# dd if=/dev/urandom of=bigfile3.img bs=64k
^C3617580+0 records in
3617579+0 records out
237081657344 bytes (237 GB) copied, 14796 s, 16.0 MB/s

# df -h
Filesystem      Size  Used Avail Use% Mounted on
(...)
/dev/vdb        256G  230G   25G  91% /mnt/test


# btrfs qgroup show /mnt/test
qgroupid rfer         excl
-------- ----         ----
0/5      16384        16384
0/257    245960245248 245960245248

# ls -l
total 240451584
-rw-r--r-- 1 root root   3127377920 Dec 19 20:06 bigfile2.img
-rw-r--r-- 1 root root 237081657344 Dec 20 00:15 bigfile3.img
-rw-r--r-- 1 root root   6013386752 Dec 19 20:02 bigfile.img

# rm bigfile3.img

# sync

# dmesg
(...)
[   95.055420] BTRFS: device fsid 97f98279-21e7-4822-89be-3aed9dc05f2c 
devid 1 transid 3 /dev/vdb
[  118.446509] BTRFS info (device vdb): disk space caching is enabled
[  118.446518] BTRFS: flagging fs with big metadata feature
[  118.452176] BTRFS: creating UUID tree
[  575.189412] BTRFS info (device vdb): qgroup scan completed
[15948.234826] ------------[ cut here ]------------
[15948.234883] kernel BUG at /home/apw/COD/linux/fs/btrfs/inode.c:3123!
[15948.234906] invalid opcode: 0000 [#1] SMP
[15948.234925] Modules linked in: nf_log_ipv6 ip6t_REJECT nf_reject_ipv6 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_log_ipv4 
nf_log_common xt_LOG ipt_REJECT nf_reject_ipv4 xt_tcpudp 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
iptable_filter ip_tables x_tables dm_crypt btrfs xor crct10dif_pclmul 
crc32_pclmul ghash_clmulni_intel aesni_intel ppdev aes_x86_64 lrw 
raid6_pq gf128mul glue_helper ablk_helper cryptd serio_raw mac_hid 
pvpanic 8250_fintek parport_pc i2c_piix4 lp parport psmouse qxl ttm 
floppy drm_kms_helper drm
[15948.235172] CPU: 0 PID: 3274 Comm: btrfs-cleaner Not tainted 
3.18.1-031801-generic #201412170637
[15948.235193] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 
04/01/2014
[15948.235222] task: ffff880036708a00 ti: ffff88007b97c000 task.ti: 
ffff88007b97c000
[15948.235240] RIP: 0010:[<ffffffffc0458ec9>]  [<ffffffffc0458ec9>] 
btrfs_orphan_add+0x1a9/0x1c0 [btrfs]
[15948.235305] RSP: 0018:ffff88007b97fc98  EFLAGS: 00010286
[15948.235318] RAX: 00000000ffffffe4 RBX: ffff88007b80a800 RCX: 
0000000000000000
[15948.235333] RDX: 000000000000219e RSI: 0000000000040000 RDI: 
ffff880079418138
[15948.235349] RBP: ffff88007b97fcd8 R08: ffff88007fc1cae0 R09: 
ffff88007ad272d0
[15948.235366] R10: 0000000000000000 R11: 0000000000000010 R12: 
ffff88007a2d9500
[15948.235381] R13: ffff8800027d60e0 R14: ffff88007b80ac58 R15: 
0000000000000001
[15948.235401] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) 
knlGS:0000000000000000
[15948.235418] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15948.235432] CR2: 00007f0489ff0000 CR3: 000000007a5e0000 CR4: 
00000000001407f0
[15948.235464] Stack:
[15948.235473]  ffff88007b97fcd8 ffffffffc0497acf ffff88007b809800 
ffff88003c207400
[15948.235498]  ffff88007b809800 ffff88007ad272d0 ffff88007a2d9500 
0000000000000001
[15948.235521]  ffff88007b97fd58 ffffffffc04412e0 ffff880079418000 
00000004c0427fea
[15948.235551] Call Trace:
[15948.235601]  [<ffffffffc0497acf>] ? 
lookup_free_space_inode+0x4f/0x100 [btrfs]
[15948.235642]  [<ffffffffc04412e0>] 
btrfs_remove_block_group+0x140/0x490 [btrfs]
[15948.235693]  [<ffffffffc047bde5>] btrfs_remove_chunk+0x245/0x380 
[btrfs]
[15948.235731]  [<ffffffffc0441866>] btrfs_delete_unused_bgs+0x236/0x270 
[btrfs]
[15948.235771]  [<ffffffffc044ad6c>] cleaner_kthread+0x12c/0x190 [btrfs]
[15948.235806]  [<ffffffffc044ac40>] ? 
btrfs_destroy_all_delalloc_inodes+0x120/0x120 [btrfs]
[15948.235844]  [<ffffffff81093a09>] kthread+0xc9/0xe0
[15948.235872]  [<ffffffff81093940>] ? flush_kthread_worker+0x90/0x90
[15948.235900]  [<ffffffff817b36bc>] ret_from_fork+0x7c/0xb0
[15948.235919]  [<ffffffff81093940>] ? flush_kthread_worker+0x90/0x90
[15948.235933] Code: e8 7d a1 fc ff 8b 45 c8 e9 6d ff ff ff 0f 1f 44 00 
00 f0 41 80 65 80 fd 4c 89 ef 89 45 c8 e8 cf 20 fe ff 8b 45 c8 e9 48 ff 
ff ff <0f> 0b 4c 89 f7 45 31 f6 e8 8a a2 35 c1 e9 f9 fe ff ff 0f 1f 44
[15948.236017] RIP  [<ffffffffc0458ec9>] btrfs_orphan_add+0x1a9/0x1c0 
[btrfs]
[15948.236017]  RSP <ffff88007b97fc98>
[15948.761942] ---[ end trace 0ccd21c265dce56b ]---

# ls
bigfile2.img  bigfile.img

# touch 1
(...never returned...)

-- 
Tomasz Chmielewski
http://www.sslrack.com

