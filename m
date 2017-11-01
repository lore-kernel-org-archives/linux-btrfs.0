Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:49837 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbdKAPKP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 11:10:15 -0400
Received: by mail-oi0-f67.google.com with SMTP id w197so4919065oif.6
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 08:10:15 -0700 (PDT)
MIME-Version: 1.0
From: Nathan Royce <nroycea+kernel@gmail.com>
Date: Wed, 1 Nov 2017 10:10:14 -0500
Message-ID: <CALaQ_hr1x32YyzBduFVhzpW=E_4=k5TiNLvtz9FP3NPJfCe6jg@mail.gmail.com>
Subject: kernel BUG at fs/btrfs/ctree.c:3182 - occurred during heavy NFS transfer
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ODroid XU4
Arch Linux
Kernel 4.13 (custom)
4TB USB 3.0 mechanical WD Drive/hub (had bad-block issues in the past
that were "corrected")
Occurred when using rsync to copy files to an encfs mount over nfs
(only 22MB made it).

Note, I keep the activity on my odroid very low or things start to bug
out left and right. I even set the kernel config so only the 4 LITTLE
ARM cores are used rather than include the other 4 big cores.
Heavy IO such as from an rsync is one such thing to cause a bugout it seems.

Surprisingly, the whigout didn't cause my drive to remount RO.

Nov 01 09:43:46 dd kernel: ------------[ cut here ]------------
Nov 01 09:43:46 dd kernel: kernel BUG at fs/btrfs/ctree.c:3182!
Nov 01 09:43:46 dd kernel: Internal error: Oops - BUG: 0 [#1] SMP ARM
Nov 01 09:43:46 dd kernel: Modules linked in: nf_conntrack_netlink
nfnetlink cmac ccm ppp_deflate ppp_async ppp_generic slhc bridge stp
llc nf_log_ipv4 ipt_REJECT nf_reject_ipv4 xt_recent nf_log_ipv6
iptable_filter nf_log_common ipt_MASQUERADE xt_LOG
nf_nat_masquerade_ip
Nov 01 09:43:46 dd kernel:  usbserial btrfs xor xor_neon lzo_compress
lzo_decompress zlib_deflate raid6_pq nfsd auth_rpcgss oid_registry
nfs_acl lockd grace crypto_user sunrpc ip_tables x_tables
Nov 01 09:43:46 dd kernel: CPU: 3 PID: 476 Comm: nfsd Not tainted
4.13.0-dirty #2
Nov 01 09:43:46 dd kernel: Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
Nov 01 09:43:46 dd kernel: task: e9987080 task.stack: e8c28000
Nov 01 09:43:46 dd kernel: PC is at btrfs_set_item_key_safe+0x138/0x144 [btrfs]
Nov 01 09:43:46 dd kernel: LR is at comp_keys+0x4c/0x68 [btrfs]
Nov 01 09:43:46 dd kernel: pc : [<bf155ea8>]    lr : [<bf155150>]
psr: 60010013
Nov 01 09:43:46 dd kernel: sp : e8c29890  ip : 0000006c  fp : 00000001
Nov 01 09:43:46 dd kernel: r10: ec8ce000  r9 : d75feb40  r8 : e8c29893
Nov 01 09:43:46 dd kernel: r7 : c52816c8  r6 : c0c05448  r5 : 0000002e
 r4 : e8c29986
Nov 01 09:43:46 dd kernel: r3 : 00040d00  r2 : 00040d00  r1 : e8c29986
 r0 : 00000000
Nov 01 09:43:46 dd kernel: Flags: nZCv  IRQs on  FIQs on  Mode SVC_32
ISA ARM  Segment none
Nov 01 09:43:46 dd kernel: Control: 10c5387d  Table: 4bc2806a  DAC: 00000051
Nov 01 09:43:46 dd kernel: Process nfsd (pid: 476, stack limit = 0xe8c28218)
Nov 01 09:43:46 dd kernel: Stack: (0xe8c29890 to 0xe8c2a000)
Nov 01 09:43:47 dd kernel: 9880:
8b002000 0000365c 6c000000 00010000
Nov 01 09:43:47 dd kernel: 98a0: 00000000 00040d00 c52816c8 00000000
0000a000 00000000 0000286a e8c29975
Nov 01 09:43:47 dd kernel: 98c0: d75feb40 bf19a130 00365c8b 00000000
0000a000 00000000 ffffffff 00000001
Nov 01 09:43:47 dd kernel: 98e0: dbe24000 bf1ab0ec 00000000 c52816c8
00011000 00000000 00365c8b 00000000
Nov 01 09:43:47 dd kernel: 9900: 00000000 e99f5800 0000286a 00000000
00000001 e9335248 ffffffff 00000000
Nov 01 09:43:47 dd kernel: 9920: 00000000 e73472d0 00000000 00000000
0000a000 00000000 00000000 00000000
Nov 01 09:43:48 dd kernel: 9940: 00000000 ec8ce000 00000000 00000000
00000000 00000000 bf221f04 c0c05448
Nov 01 09:43:48 dd kernel: 9960: 00000000 e8c29a7c 00000000 00000000
00000004 365c8b10 00000000 a0006c00
Nov 01 09:43:48 dd kernel: 9980: 00000000 5c8b0000 00000036 006c0000
00000100 c5000000 d0bf41e0 e93350a8
Nov 01 09:43:48 dd kernel: 99a0: 00001000 00000000 00365c8b 00000000
00a0006c 00000000 c5281b00 00040d00
Nov 01 09:43:48 dd kernel: 99c0: d75feb44 c52816c8 c24da070 00006000
00000000 0000a000 00000000 00010000
Nov 01 09:43:48 dd kernel: 99e0: 00000000 bf1cdb60 0000a000 00000000
00010000 00000000 00000000 00000000
Nov 01 09:43:48 dd kernel: 9a00: 00000001 00000035 e8c29a7c eb78f9ab
00006000 00000000 e8c29a8c c24da000
Nov 01 09:43:48 dd kernel: 9a20: 00000000 e8c29b74 e93350b4 e9335080
e93350a8 00000000 e99f5800 e9335248
Nov 01 09:43:49 dd kernel: 9a40: 0000a000 00000000 0000a000 00000000
ee22d000 ec8ce000 e73472d0 d75feb40
Nov 01 09:43:49 dd kernel: 9a60: e8c29cf8 e9335220 c0c05448 e8c29aa0
c52816c8 00000000 00000000 00000000
Nov 01 09:43:49 dd kernel: 9a80: 00000000 c24da9d0 c24da9d0 e8c29a8c
00000000 00002000 c5281bd8 c5281bec
Nov 01 09:43:49 dd kernel: 9aa0: 00000000 c07289cc c5281bd8 00040d00
d75feb44 00000000 00000000 e9335080
Nov 01 09:43:49 dd kernel: 9ac0: d75feb40 d75fe2d0 ffffffef c0c05448
e73472d0 bf1ce878 e8c29b74 e8c29cf8
Nov 01 09:43:49 dd kernel: 9ae0: 00008000 00000000 00009007 00000000
00365c8b 00000000 e8c29b20 f0802000
Nov 01 09:43:49 dd kernel: 9b00: d75feb40 00000000 c0162e10 60010013
00000000 e99f5800 c0c57dd8 ee22d000
Nov 01 09:43:49 dd kernel: 9b20: e9335248 ec8ce000 00000000 e8c29cf8
ffffe000 e9ad8c80 e9335118 00000000
Nov 01 09:43:49 dd kernel: 9b40: c0c57dd8 ffffe000 ee22d298 00000001
e9ad8c80 e8c29b70 e8c28000 c0162e10
Nov 01 09:43:50 dd kernel: 9b60: 60010013 ffffffff 00000000 00000000
ee22d284 e8c29b74 e8c29b74 8bc96be0
Nov 01 09:43:50 dd kernel: 9b80: 0000365c 01000000 00000000 00000000
000000a0 c0235cc4 00000000 e73472d0
Nov 01 09:43:50 dd kernel: 9ba0: ecc24390 00040d00 ee991000 c0c05448
ee22d000 ec8ce240 e9335080 ec8ce240
Nov 01 09:43:50 dd kernel: 9bc0: ed695720 000411c9 00000000 bf1cf1a0
00008000 00000000 00009007 00000000
Nov 01 09:43:50 dd kernel: 9be0: e8c29cf8 e9335354 e73472d0 e8c29cf8
ee22d284 00000000 7ffffffe 00000000
Nov 01 09:43:50 dd kernel: 9c00: ee991000 00000000 00009007 00000000
00000001 00000000 00000000 00000000
Nov 01 09:43:50 dd kernel: 9c20: 00000000 00000000 c0c05448 ec8ce578
dae85a00 c07289cc ec8ce000 ec8ce578
Nov 01 09:43:50 dd kernel: 9c40: dae85a00 c07289cc ed695770 00000001
00008000 c07289cc ed695770 00040d00
Nov 01 09:43:50 dd kernel: 9c60: ed695720 e73472d0 c0c05448 00008000
00000000 ed695720 e955d428 00009007
Nov 01 09:43:51 dd kernel: 9c80: 00000000 bf1d0874 00008000 00000000
00009007 00000000 00000000 e8c29cf8
Nov 01 09:43:51 dd kernel: 9ca0: e9335248 ee22d000 e8c29cf8 00008000
00000000 e988ee00 e73472d0 bf19cbb0
Nov 01 09:43:51 dd kernel: 9cc0: 00008000 00000000 00009007 00000000
e8c29cf8 00001008 00008000 00000000
Nov 01 09:43:51 dd kernel: 9ce0: 00000fff e93352d0 00001008 00000000
00000000 e9335098 00000000 00000057
Nov 01 09:43:51 dd kernel: 9d00: 00000000 00000000 e9335248 ee22d2f8
ee22d2f8 00040d00 00000000 e9335248
Nov 01 09:43:51 dd kernel: 9d20: e8c29dc0 e9335098 00001008 00009007
00000000 00009008 00000000 bf19d25c
Nov 01 09:43:51 dd kernel: 9d40: 00009007 00000000 00000000 c02f4458
00008000 00000000 c0c05448 00000000
Nov 01 09:43:51 dd kernel: 9d60: ee22d000 00000001 e9335098 00000000
00001008 00000000 e8c29dc0 c018267c
Nov 01 09:43:52 dd kernel: 9d80: 59f63c11 00000000 00001008 59f9dda1
1bdc0c72 00040d00 59f63c11 00000004
Nov 01 09:43:52 dd kernel: 9da0: c0c05448 00008000 00000000 e8c29e38
e8c29ea8 00000001 00000000 c021acac
Nov 01 09:43:52 dd kernel: 9dc0: e988ee00 00000000 00009008 00000000
00000000 00000000 00000030 00000000
Nov 01 09:43:52 dd kernel: 9de0: ed874d00 00040d00 00000004 e8c29e44
e988ee00 00000000 e8c29e38 c021c8ec
Nov 01 09:43:52 dd kernel: 9e00: 00000004 00000007 bf0e3388 c0c05448
ee047000 e988ee00 00000000 00200140
Nov 01 09:43:52 dd kernel: 9e20: e8c29ea8 bf0b60c0 00001008 bf0cdd04
60010013 e8c29ea4 00008000 00000000
Nov 01 09:43:52 dd kernel: 9e40: c0c05448 00000003 00000000 00000000
ee0475d0 00000000 e75d6b80 00040d00
Nov 01 09:43:52 dd kernel: 9e60: 11270000 00000000 ee045340 00008000
00000000 c0c05448 ee046038 ee0475c0
Nov 01 09:43:53 dd kernel: 9e80: 00000002 bf0c1218 00008000 00000000
ee0475c0 00000002 e8c29ea8 00000004
Nov 01 09:43:53 dd kernel: 9ea0: 00000000 e988ee00 00001008 00040d00
ee046000 ee046000 ee047000 ee045000
Nov 01 09:43:53 dd kernel: 9ec0: ee045320 ee046038 ee047df0 ee046160
00000000 bf0c2dc8 00000060 bf0ddde0
Nov 01 09:43:53 dd kernel: 9ee0: ee045340 bf0de170 00000000 ee047000
bf0de4dc ec2b6018 0000001c ec2b6000
Nov 01 09:43:53 dd kernel: 9f00: 0000000c bf0de4dc ec2b6000 bf0b1d90
ee047000 c0c05448 e98fd600 00000001
Nov 01 09:43:53 dd kernel: 9f20: ec2b6000 bf023a20 e995a800 ec2b600c
00000018 ec2b6018 bf0de4bc bf0de4a0
Nov 01 09:43:53 dd kernel: 9f40: 01000000 00040d00 e99d1da8 ee047000
0036ee80 ed95dc00 bf0e5eb0 c0c41780
Nov 01 09:43:53 dd kernel: 9f60: bf0b1788 e99d1da8 e99432a8 bf0b1868
e9943280 e9818f00 00000000 e8c28000
Nov 01 09:43:54 dd kernel: 9f80: ee047000 c0139cd8 e8c28000 e9818f00
c0139b8c 00000000 00000000 00000000
Nov 01 09:43:54 dd kernel: 9fa0: 00000000 00000000 00000000 c0107c18
00000000 00000000 00000000 00000000
Nov 01 09:43:54 dd kernel: 9fc0: 00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
Nov 01 09:43:54 dd kernel: 9fe0: 00000000 00000000 00000000 00000000
00000013 00000000 e1a03005 e1a02007
Nov 01 09:43:54 dd kernel: [<bf155ea8>] (btrfs_set_item_key_safe
[btrfs]) from [<bf19a130>] (__btrfs_drop_extents+0xce4/0x1000 [btrfs])
Nov 01 09:43:54 dd kernel: [<bf19a130>] (__btrfs_drop_extents [btrfs])
from [<bf1cdb60>] (btrfs_log_changed_extents+0x630/0xa40 [btrfs])
Nov 01 09:43:54 dd kernel: [<bf1cdb60>] (btrfs_log_changed_extents
[btrfs]) from [<bf1ce878>] (btrfs_log_inode+0x908/0xf98 [btrfs])
Nov 01 09:43:54 dd kernel: [<bf1ce878>] (btrfs_log_inode [btrfs]) from
[<bf1cf1a0>] (btrfs_log_inode_parent+0x20c/0x978 [btrfs])
Nov 01 09:43:54 dd kernel: [<bf1cf1a0>] (btrfs_log_inode_parent
[btrfs]) from [<bf1d0874>] (btrfs_log_dentry_safe+0x58/0x70 [btrfs])
Nov 01 09:43:54 dd kernel: [<bf1d0874>] (btrfs_log_dentry_safe
[btrfs]) from [<bf19cbb0>] (btrfs_sync_file+0x28c/0x3b8 [btrfs])
Nov 01 09:43:54 dd kernel: [<bf19cbb0>] (btrfs_sync_file [btrfs]) from
[<bf19d25c>] (btrfs_file_write_iter+0x580/0x698 [btrfs])
Nov 01 09:43:54 dd kernel: [<bf19d25c>] (btrfs_file_write_iter
[btrfs]) from [<c021acac>] (do_iter_readv_writev+0xf8/0x15c)
Nov 01 09:43:54 dd kernel: [<c021acac>] (do_iter_readv_writev) from
[<c021c8ec>] (do_iter_write+0x88/0x190)
Nov 01 09:43:54 dd kernel: [<c021c8ec>] (do_iter_write) from
[<bf0b60c0>] (nfsd_vfs_write+0xbc/0x27c [nfsd])
Nov 01 09:43:54 dd kernel: [<bf0b60c0>] (nfsd_vfs_write [nfsd]) from
[<bf0c1218>] (nfsd4_write+0x14c/0x198 [nfsd])
Nov 01 09:43:54 dd kernel: [<bf0c1218>] (nfsd4_write [nfsd]) from
[<bf0c2dc8>] (nfsd4_proc_compound+0x368/0x4f0 [nfsd])
Nov 01 09:43:54 dd kernel: [<bf0c2dc8>] (nfsd4_proc_compound [nfsd])
from [<bf0b1d90>] (nfsd_dispatch+0x78/0x198 [nfsd])
Nov 01 09:43:54 dd kernel: [<bf0b1d90>] (nfsd_dispatch [nfsd]) from
[<bf023a20>] (svc_process+0x440/0x6dc [sunrpc])
Nov 01 09:43:54 dd kernel: [<bf023a20>] (svc_process [sunrpc]) from
[<bf0b1868>] (nfsd+0xe0/0x150 [nfsd])
Nov 01 09:43:54 dd kernel: [<bf0b1868>] (nfsd [nfsd]) from
[<c0139cd8>] (kthread+0x14c/0x154)
Nov 01 09:43:54 dd kernel: [<c0139cd8>] (kthread) from [<c0107c18>]
(ret_from_fork+0x14/0x3c)
Nov 01 09:43:54 dd kernel: Code: e1a00008 ebfffc98 e3500000 caffffd3 (e7f001f2)
Nov 01 09:43:54 dd kernel: ---[ end trace 420ef9dba81d89fa ]---
