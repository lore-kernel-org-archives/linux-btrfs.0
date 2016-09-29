Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from u164.east.ru ([195.170.63.164]:49909 "EHLO u164.east.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752823AbcI2MVx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 08:21:53 -0400
Date: Thu, 29 Sep 2016 15:21:48 +0300
From: Anatoly Pugachev <matorola@gmail.com>
To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>, bo.li.liu@oracle.com
Cc: fstests@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Btrfs: free space tree and sanity test fixes
Message-ID: <20160929122148.GA22109@yogzotot>
References: <cover.1474580472.git.osandov@fb.com>
 <20160925075524.GA3870@yogzotot>
 <20160926175000.GF16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160926175000.GF16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 26, 2016 at 07:50:00PM +0200, David Sterba wrote:
> On Sun, Sep 25, 2016 at 10:55:24AM +0300, Anatoly Pugachev wrote:
> > applied patch to git kernel (v4.8-rc7-172-gbd5dbcb) cleanly. Did not used
> > btrfs-progs.git, but debian shipped 4.7.3-1 .
> > 
> > [3184240.135182] BTRFS info (device loop0): creating UUID tree
> > [3184240.252534] BTRFS critical (device loop4): corrupt leaf, non-root leaf's nritems is 0: block=29556736,root=1, slot=0
> 
> The error does not seem to be related to the free space bitmap issues
> (at least I don't see a connection). The message is from
> 
>   1ba98d086fe3a14d6a31f2f66dbab70c45d00f63
>   "Btrfs: detect corruption when non-root leaf has zero item"
> 
> called from btrfs_mark_buffer_dirty with integrity checker on.
> Confirmed from the log:
> 
> > [3102837.870398] Btrfs loaded, crc32c=crc32c-sparc64, debug=on, assert=on, integrity-checker=on
> ...
> 
> This is fixed by patch
> 
>   "Btrfs: remove unnecessary btrfs_mark_buffer_dirty in split_leaf"
> 
> that's in the 4.9 queue. Other than that, the self-tests seem to pass,
> thanks for the test. Would be good if you can test with the mentioned
> patch included or without integrity checker. Thanks for testing.


updated git kernel to v4.8-rc8-8-gae6dd8d , applied this 
"Btrfs: free space tree and sanity test fixes" patchset and added/applied 
"Btrfs: remove unnecessary btrfs_mark_buffer_dirty in split_leaf" :


1) kernel config BTRFS integrity-checker=on :

Sep 29 00:32:15 ttip kernel: raid6: using intx1 recovery algorithm
Sep 29 00:32:15 ttip kernel: xor: automatically using best checksumming function:
Sep 29 00:32:15 ttip kernel:    Niagara   :  4746.000 MB/sec
Sep 29 00:32:15 ttip kernel: Btrfs loaded, crc32c=crc32c-sparc64, debug=on, assert=on, integrity-checker=on
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: sectorsize: 8192  nodesize: 8192
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running btrfs free space cache tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent only tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running bitmap only tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running bitmap and extent tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running space stealing from bitmap to extent
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Free space cache tests finished
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent buffer operation tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running btrfs_split_item tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent I/O tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running find delalloc tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent buffer bitmap tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Extent I/O tests finished
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running btrfs_get_extent tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running hole first btrfs_get_extent test
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running outstanding_extents tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running qgroup tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Qgroup basic add
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Qgroup multiple refs test
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running free space tree tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: sectorsize: 8192  nodesize: 16384
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running btrfs free space cache tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent only tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running bitmap only tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running bitmap and extent tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running space stealing from bitmap to extent
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Free space cache tests finished
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent buffer operation tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running btrfs_split_item tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent I/O tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running find delalloc tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent buffer bitmap tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Extent I/O tests finished
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running btrfs_get_extent tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running hole first btrfs_get_extent test
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running outstanding_extents tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running qgroup tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Qgroup basic add
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Qgroup multiple refs test
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running free space tree tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: sectorsize: 8192  nodesize: 32768
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running btrfs free space cache tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent only tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running bitmap only tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running bitmap and extent tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running space stealing from bitmap to extent
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Free space cache tests finished
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent buffer operation tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running btrfs_split_item tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent I/O tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running find delalloc tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent buffer bitmap tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Extent I/O tests finished
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running btrfs_get_extent tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running hole first btrfs_get_extent test
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running outstanding_extents tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running qgroup tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Qgroup basic add
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Qgroup multiple refs test
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running free space tree tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: sectorsize: 8192  nodesize: 65536
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running btrfs free space cache tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent only tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running bitmap only tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running bitmap and extent tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running space stealing from bitmap to extent
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Free space cache tests finished
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent buffer operation tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running btrfs_split_item tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent I/O tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running find delalloc tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running extent buffer bitmap tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Extent I/O tests finished
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running btrfs_get_extent tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running hole first btrfs_get_extent test
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running outstanding_extents tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running qgroup tests
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Qgroup basic add
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Qgroup multiple refs test
Sep 29 00:32:15 ttip kernel: BTRFS: selftest: Running free space tree tests
Sep 29 00:32:15 ttip kernel: random: fast init done
Sep 29 00:32:15 ttip kernel: EXT4-fs (vdiska2): mounted filesystem with ordered data mode. Opts: (null)
Sep 29 00:32:15 ttip kernel: random: crng init done
Sep 29 00:32:15 ttip kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Sep 29 00:32:15 ttip systemd[1]: systemd 231 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD +IDN
Sep 29 00:32:15 ttip systemd[1]: Detected architecture sparc64.
Sep 29 00:32:15 ttip systemd[1]: Set hostname to <ttip>.
Sep 29 00:32:15 ttip systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
Sep 29 00:32:15 ttip systemd[1]: Reached target Swap.
Sep 29 00:32:15 ttip systemd[1]: Listening on fsck to fsckd communication Socket.
Sep 29 00:32:15 ttip kernel: nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
Sep 29 00:32:16 ttip kernel: EXT4-fs (vdiska2): re-mounted. Opts: errors=remount-ro
Sep 29 00:32:22 ttip kernel: n2rng.c:v0.2 (July 27, 2011)
Sep 29 00:32:27 ttip kernel: n2rng f029b124: Registered RNG HVAPI major 2 minor 0
Sep 29 00:32:27 ttip kernel: n2rng f029b124: Found multi-unit-capable RNG, units: 2
Sep 29 00:32:27 ttip kernel: n2rng f029b124: RNG ready
Sep 29 00:32:27 ttip kernel: sha1_sparc64: Using sparc64 sha1 opcode optimized SHA-1 implementation
Sep 29 00:32:27 ttip kernel: sha256_sparc64: Using sparc64 sha256 opcode optimized SHA-256/SHA-224 implementation
Sep 29 00:32:27 ttip kernel: sha512_sparc64: Using sparc64 sha512 opcode optimized SHA-512/SHA-384 implementation
Sep 29 00:32:27 ttip kernel: md5_sparc64: Using sparc64 md5 opcode optimized MD5 implementation
Sep 29 00:32:27 ttip kernel: aes_sparc64: Using sparc64 aes opcodes optimized AES implementation
Sep 29 00:32:27 ttip kernel: des_sparc64: Using sparc64 des opcodes optimized DES implementation
Sep 29 00:32:27 ttip kernel: camellia_sparc64: Using sparc64 camellia opcodes optimized CAMELLIA implementation
Sep 29 00:32:27 ttip kernel: SGI XFS with ACLs, security attributes, realtime, no debug enabled
Sep 29 00:32:27 ttip kernel: XFS (vdiskb1): Mounting V5 Filesystem
Sep 29 00:32:27 ttip kernel: XFS (vdiskb1): Ending clean mount
Sep 29 00:32:27 ttip kernel: EXT4-fs (vdiska1): mounting ext3 file system using the ext4 subsystem
Sep 29 00:32:27 ttip kernel: EXT4-fs (vdiska1): mounted filesystem with ordered data mode. Opts: (null)
Sep 29 00:32:27 ttip systemd[1]: apt-daily.timer: Adding 10h 46min 38.851540s random time.
Sep 29 00:32:27 ttip kernel: tun: Universal TUN/TAP device driver, 1.6
Sep 29 00:32:27 ttip kernel: tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Sep 29 00:38:32 ttip kernel: loop: module loaded
Sep 29 00:40:55 ttip kernel: BTRFS: device fsid 7bb81df9-0e2b-47f2-81ff-c08502d38da6 devid 1 transid 5 /dev/loop4
Sep 29 00:41:30 ttip kernel: BTRFS info (device loop4): disk space caching is enabled
Sep 29 00:41:30 ttip kernel: BTRFS info (device loop4): has skinny extents
Sep 29 00:41:30 ttip kernel: BTRFS info (device loop4): flagging fs with big metadata feature
Sep 29 00:41:30 ttip kernel: BTRFS info (device loop4): creating UUID tree
Sep 29 00:41:31 ttip kernel: BTRFS: device fsid d0ee7ca3-3be0-465f-857b-19e681181923 devid 1 transid 5 /dev/loop0
Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): enabling free space tree
Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): using free space tree
Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): has skinny extents
Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): flagging fs with big metadata feature
Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): creating free space tree
Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): setting 1 ro feature flag
Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): setting 2 ro feature flag
Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): creating UUID tree
Sep 29 00:41:32 ttip kernel: BTRFS critical (device loop4): corrupt leaf, non-root leaf's nritems is 0: block=29556736,root=1, slot=0
Sep 29 00:41:32 ttip kernel: BTRFS info (device loop4): leaf 29556736 total ptrs 0 free space 16283
Sep 29 00:41:32 ttip kernel: BTRFS: assertion failed: 0, file: fs/btrfs/disk-io.c, line: 4059kernel BUG at fs/btrfs/ctree.h:3369!
Sep 29 00:41:32 ttip kernel:               \|/ ____ \|/
                                           "@'/ .. \`@"
                                           /_| \__/ |_\
                                              \__U_/
Sep 29 00:41:32 ttip kernel: umount(9847): Kernel bad sw trap 5 [#1]
Sep 29 00:41:32 ttip kernel: CPU: 22 PID: 9847 Comm: umount Not tainted 4.8.0-rc8+ #10
Sep 29 00:41:32 ttip kernel: task: fff800007db1a480 task.stack: fff80007f2dc8000
Sep 29 00:41:32 ttip kernel: TSTATE: 0000004411001606 TPC: 00000000100d6ccc TNPC: 00000000100d6cd0 Y: 00000000    Not tainted
Sep 29 00:41:32 ttip kernel: TPC: <btrfs_mark_buffer_dirty+0x1ac/0x1e0 [btrfs]>
Sep 29 00:41:32 ttip kernel: g0: 0000000000000000 g1: 0000000000000000 g2: 0000000000000007 g3: 0000000000000000
Sep 29 00:41:32 ttip kernel: g4: fff800007db1a480 g5: fff800082c692000 g6: fff80007f2dc8000 g7: fff800082ce00000
Sep 29 00:41:32 ttip kernel: o0: 000000001019cac8 o1: 0000000000000d29 o2: 000000001019c930 o3: 0000000000000fdb
Sep 29 00:41:32 ttip kernel: o4: 0000000001c30000 o5: 0000000000000000 sp: fff80007f2dca3c1 ret_pc: 00000000100d6cc4
Sep 29 00:41:32 ttip kernel: RPC: <btrfs_mark_buffer_dirty+0x1a4/0x1e0 [btrfs]>
Sep 29 00:41:32 ttip kernel: l0: 000000000000154c l1: 0000000000002000 l2: 0000000000002000 l3: fff8000812764b10
Sep 29 00:41:32 ttip kernel: l4: fff800080f33aa18 l5: 00000000101b8400 l6: 0000000001000000 l7: 0000000000000000
Sep 29 00:41:32 ttip kernel: i0: fff800081372bbe8 i1: 0000000000000000 i2: 0700000000000000 i3: 00060000122b38f0
Sep 29 00:41:32 ttip kernel: i4: fff8000813156800 i5: 0000000000000007 i6: fff80007f2dca471 i7: 00000000100a0388
Sep 29 00:41:32 ttip kernel: I7: <__btrfs_cow_block+0x7e8/0xb80 [btrfs]>
Sep 29 00:41:32 ttip kernel: Call Trace:
Sep 29 00:41:32 ttip kernel:  [00000000100a0388] __btrfs_cow_block+0x7e8/0xb80 [btrfs]
Sep 29 00:41:32 ttip kernel:  [00000000100a0948] btrfs_cow_block+0x1a8/0x340 [btrfs]
Sep 29 00:41:32 ttip kernel:  [00000000100a6000] btrfs_search_slot+0x2a0/0xf60 [btrfs]
Sep 29 00:41:32 ttip kernel:  [00000000100ccff4] btrfs_del_csums+0x1b4/0x6a0 [btrfs]
Sep 29 00:41:32 ttip kernel:  [00000000100b4ecc] __btrfs_free_extent.isra.19+0x9ec/0x12c0 [btrfs]
Sep 29 00:41:32 ttip kernel:  [00000000100ba788] __btrfs_run_delayed_refs+0x548/0x1980 [btrfs]
Sep 29 00:41:32 ttip kernel:  [00000000100bfec8] btrfs_run_delayed_refs+0x88/0x2c0 [btrfs]
Sep 29 00:41:32 ttip kernel:  [00000000100dcc20] commit_cowonly_roots+0xe0/0x5c0 [btrfs]
Sep 29 00:41:32 ttip kernel:  [00000000100df9b4] btrfs_commit_transaction+0x534/0xd60 [btrfs]
Sep 29 00:41:32 ttip kernel:  [00000000100d54c4] btrfs_commit_super+0x64/0x80 [btrfs]
Sep 29 00:41:32 ttip kernel:  [00000000100d8a60] close_ctree+0x260/0x320 [btrfs]
Sep 29 00:41:32 ttip kernel:  [0000000010096cd0] btrfs_put_super+0x10/0x20 [btrfs]
Sep 29 00:41:32 ttip kernel:  [00000000005e62d4] generic_shutdown_super+0x74/0x100
Sep 29 00:41:32 ttip kernel:  [00000000005e65b0] kill_anon_super+0x10/0x40
Sep 29 00:41:32 ttip kernel:  [00000000100969b4] btrfs_kill_super+0x14/0x100 [btrfs]
Sep 29 00:41:32 ttip kernel:  [00000000005e67a4] deactivate_locked_super+0x44/0x80
Sep 29 00:41:32 ttip kernel: Disabling lock debugging due to kernel taint
Sep 29 00:41:32 ttip kernel: Caller[00000000100a0388]: __btrfs_cow_block+0x7e8/0xb80 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[00000000100a0948]: btrfs_cow_block+0x1a8/0x340 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[00000000100a6000]: btrfs_search_slot+0x2a0/0xf60 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[00000000100ccff4]: btrfs_del_csums+0x1b4/0x6a0 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[00000000100b4ecc]: __btrfs_free_extent.isra.19+0x9ec/0x12c0 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[00000000100ba788]: __btrfs_run_delayed_refs+0x548/0x1980 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[00000000100bfec8]: btrfs_run_delayed_refs+0x88/0x2c0 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[00000000100dcc20]: commit_cowonly_roots+0xe0/0x5c0 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[00000000100df9b4]: btrfs_commit_transaction+0x534/0xd60 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[00000000100d54c4]: btrfs_commit_super+0x64/0x80 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[00000000100d8a60]: close_ctree+0x260/0x320 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[0000000010096cd0]: btrfs_put_super+0x10/0x20 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[00000000005e62d4]: generic_shutdown_super+0x74/0x100
Sep 29 00:41:32 ttip kernel: Caller[00000000005e65b0]: kill_anon_super+0x10/0x40
Sep 29 00:41:32 ttip kernel: Caller[00000000100969b4]: btrfs_kill_super+0x14/0x100 [btrfs]
Sep 29 00:41:32 ttip kernel: Caller[00000000005e67a4]: deactivate_locked_super+0x44/0x80
Sep 29 00:41:32 ttip kernel: Caller[00000000005e74a4]: deactivate_super+0x64/0x80
Sep 29 00:41:32 ttip kernel: Caller[00000000006055dc]: cleanup_mnt+0x3c/0xa0
Sep 29 00:41:32 ttip kernel: Caller[00000000006056ac]: __cleanup_mnt+0xc/0x20
Sep 29 00:41:32 ttip kernel: Caller[00000000004859c0]: task_work_run+0xa0/0xe0
Sep 29 00:41:32 ttip kernel: Caller[000000000042e144]: do_notify_resume+0x64/0x80
Sep 29 00:41:32 ttip kernel: Caller[0000000000404b44]: __handle_signal+0xc/0x2c
Sep 29 00:41:32 ttip kernel: Caller[fff8000100150db4]: 0xfff8000100150db4
Sep 29 00:41:32 ttip kernel: Instruction DUMP: 92102d29  7c0d43df  901222c8 <91d02005> d25e2008  d4422b40  7c19c0d2  90022af0  106fffe1 
Sep 29 00:41:32 ttip unknown: run fstests btrfs/001 at 2016-09-29 00:41:32


kernel oops and hangs (as like in my previous email)





2) kernel config BTRFS integrity-checker=off

[3535986.809765] raid6: using intx1 recovery algorithm
[3535986.810822] xor: automatically using best checksumming function:
[3535986.849741]    Niagara   :  4786.000 MB/sec
[3535987.273958] Btrfs loaded, crc32c=crc32c-sparc64, debug=on, assert=on
[3535987.274599] BTRFS: selftest: sectorsize: 8192  nodesize: 8192
[3535987.274607] BTRFS: selftest: Running btrfs free space cache tests
[3535987.274798] BTRFS: selftest: Running extent only tests
[3535987.274817] BTRFS: selftest: Running bitmap only tests
[3535987.274891] BTRFS: selftest: Running bitmap and extent tests
[3535987.274997] BTRFS: selftest: Running space stealing from bitmap to extent
[3535987.275569] BTRFS: selftest: Free space cache tests finished
[3535987.275575] BTRFS: selftest: Running extent buffer operation tests
[3535987.275580] BTRFS: selftest: Running btrfs_split_item tests
[3535987.275950] BTRFS: selftest: Running extent I/O tests
[3535987.275956] BTRFS: selftest: Running find delalloc tests
[3535987.276520] BTRFS: selftest: Running extent buffer bitmap tests
[3535987.324943] BTRFS: selftest: Extent I/O tests finished
[3535987.324950] BTRFS: selftest: Running btrfs_get_extent tests
[3535987.325385] BTRFS: selftest: Running hole first btrfs_get_extent test
[3535987.325729] BTRFS: selftest: Running outstanding_extents tests
[3535987.326282] BTRFS: selftest: Running qgroup tests
[3535987.326288] BTRFS: selftest: Qgroup basic add
[3535987.326346] BTRFS: selftest: Qgroup multiple refs test
[3535987.328207] BTRFS: selftest: Running free space tree tests
[3535987.365715] BTRFS: selftest: sectorsize: 8192  nodesize: 16384
[3535987.365722] BTRFS: selftest: Running btrfs free space cache tests
[3535987.365911] BTRFS: selftest: Running extent only tests
[3535987.365922] BTRFS: selftest: Running bitmap only tests
[3535987.365986] BTRFS: selftest: Running bitmap and extent tests
[3535987.366089] BTRFS: selftest: Running space stealing from bitmap to extent
[3535987.366654] BTRFS: selftest: Free space cache tests finished
[3535987.366660] BTRFS: selftest: Running extent buffer operation tests
[3535987.366665] BTRFS: selftest: Running btrfs_split_item tests
[3535987.366997] BTRFS: selftest: Running extent I/O tests
[3535987.367003] BTRFS: selftest: Running find delalloc tests
[3535987.367450] BTRFS: selftest: Running extent buffer bitmap tests
[3535987.415830] BTRFS: selftest: Extent I/O tests finished
[3535987.415846] BTRFS: selftest: Running btrfs_get_extent tests
[3535987.416310] BTRFS: selftest: Running hole first btrfs_get_extent test
[3535987.416653] BTRFS: selftest: Running outstanding_extents tests
[3535987.417198] BTRFS: selftest: Running qgroup tests
[3535987.417204] BTRFS: selftest: Qgroup basic add
[3535987.417253] BTRFS: selftest: Qgroup multiple refs test
[3535987.419119] BTRFS: selftest: Running free space tree tests
[3535987.456670] BTRFS: selftest: sectorsize: 8192  nodesize: 32768
[3535987.456677] BTRFS: selftest: Running btrfs free space cache tests
[3535987.456860] BTRFS: selftest: Running extent only tests
[3535987.456873] BTRFS: selftest: Running bitmap only tests
[3535987.456938] BTRFS: selftest: Running bitmap and extent tests
[3535987.457041] BTRFS: selftest: Running space stealing from bitmap to extent
[3535987.457607] BTRFS: selftest: Free space cache tests finished
[3535987.457613] BTRFS: selftest: Running extent buffer operation tests
[3535987.457618] BTRFS: selftest: Running btrfs_split_item tests
[3535987.457962] BTRFS: selftest: Running extent I/O tests
[3535987.457968] BTRFS: selftest: Running find delalloc tests
[3535987.458465] BTRFS: selftest: Running extent buffer bitmap tests
[3535987.506819] BTRFS: selftest: Extent I/O tests finished
[3535987.506831] BTRFS: selftest: Running btrfs_get_extent tests
[3535987.507272] BTRFS: selftest: Running hole first btrfs_get_extent test
[3535987.507614] BTRFS: selftest: Running outstanding_extents tests
[3535987.508154] BTRFS: selftest: Running qgroup tests
[3535987.508160] BTRFS: selftest: Qgroup basic add
[3535987.508205] BTRFS: selftest: Qgroup multiple refs test
[3535987.510075] BTRFS: selftest: Running free space tree tests
[3535987.547635] BTRFS: selftest: sectorsize: 8192  nodesize: 65536
[3535987.547646] BTRFS: selftest: Running btrfs free space cache tests
[3535987.547829] BTRFS: selftest: Running extent only tests
[3535987.547843] BTRFS: selftest: Running bitmap only tests
[3535987.547907] BTRFS: selftest: Running bitmap and extent tests
[3535987.548011] BTRFS: selftest: Running space stealing from bitmap to extent
[3535987.548577] BTRFS: selftest: Free space cache tests finished
[3535987.548583] BTRFS: selftest: Running extent buffer operation tests
[3535987.548588] BTRFS: selftest: Running btrfs_split_item tests
[3535987.548927] BTRFS: selftest: Running extent I/O tests
[3535987.548933] BTRFS: selftest: Running find delalloc tests
[3535987.549449] BTRFS: selftest: Running extent buffer bitmap tests
[3535987.597810] BTRFS: selftest: Extent I/O tests finished
[3535987.597817] BTRFS: selftest: Running btrfs_get_extent tests
[3535987.598229] BTRFS: selftest: Running hole first btrfs_get_extent test
[3535987.598572] BTRFS: selftest: Running outstanding_extents tests
[3535987.599111] BTRFS: selftest: Running qgroup tests
[3535987.599117] BTRFS: selftest: Qgroup basic add
[3535987.599157] BTRFS: selftest: Qgroup multiple refs test
[3535987.601014] BTRFS: selftest: Running free space tree tests
Scanning for Btrfs filesystems
[3535987.695327] random: fast init done


# mount tmpfs -t tmpfs -o size=26g /ramdisk/
# cd /ramdisk/
# for i in 1 2 3 4; do fallocate -l 4g scratch${i}; losetup --show -f scratch${i}; done
/dev/loop0
/dev/loop1
/dev/loop2
/dev/loop3

# fallocate -l 10g testvol1
# losetup --show -f testvol1
/dev/loop4
# mkfs.btrfs /dev/loop4
btrfs-progs v4.7.3
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (10.00GiB) ...
Label:              (null)
UUID:
Node size:          16384
Sector size:        8192
Filesystem size:    10.00GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP               1.00GiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1    10.00GiB  /dev/loop4
	

Sep 29 12:09:44 ttip kernel: loop: module loaded
Sep 29 12:10:01 ttip kernel: BTRFS: device fsid 65949799-6eb6-4f95-bff6-40a84f522e16 devid 1 transid 5 /dev/loop4
	
	
root@ttip:/home/mator/xfstests-dev# cat local.config
export TEST_DEV=/dev/loop4
export TEST_DIR=/testvol
export SCRATCH_DEV_POOL="/dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3"
export SCRATCH_MNT=/mnt/scratch
export MOUNT_OPTIONS="-o space_cache=v2"

root@ttip:/home/mator/xfstests-dev# ./check -g auto
FSTYP         -- btrfs
PLATFORM      -- Linux/sparc64 ttip 4.8.0-rc8+
MKFS_OPTIONS  -- /dev/loop0
MOUNT_OPTIONS -- -o space_cache=v2 /dev/loop0 /mnt/scratch

btrfs/001        2s
btrfs/002        11s
btrfs/003        [not run] /dev/loop0 is a device which is not deletable
btrfs/004        18s
btrfs/005        14s
btrfs/006        3s
btrfs/007        2s
btrfs/008        1s
btrfs/009        1s
btrfs/010        [failed, exit status 1] - output mismatch (see /home/mator/xfstests-dev/results//btrfs/010.out.bad)
    --- tests/btrfs/010.out     2016-09-24 11:51:48.190888875 +0300
    +++ /home/mator/xfstests-dev/results//btrfs/010.out.bad     2016-09-29 12:11:51.102710463 +0300
    @@ -1,2 +1,2 @@
     QA output created by 010
    -done
    +number of extents mis-match!
    ...
    (Run 'diff -u tests/btrfs/010.out /home/mator/xfstests-dev/results//btrfs/010.out.bad'  to see the entire diff)
btrfs/011        [failed, exit status 1] - output mismatch (see /home/mator/xfstests-dev/results//btrfs/011.out.bad)
    --- tests/btrfs/011.out     2016-09-24 11:51:48.190888875 +0300
    +++ /home/mator/xfstests-dev/results//btrfs/011.out.bad     2016-09-29 12:12:25.764134794 +0300
    @@ -1,3 +1,2 @@
     QA output created by 011
     *** test btrfs replace
    -*** done   
    ...
    (Run 'diff -u tests/btrfs/011.out /home/mator/xfstests-dev/results//btrfs/011.out.bad'  to see the entire diff)
btrfs/012        [failed, exit status 1] - output mismatch (see /home/mator/xfstests-dev/results//btrfs/012.out.bad)
    --- tests/btrfs/012.out     2016-09-24 11:51:48.190888875 +0300
    +++ /home/mator/xfstests-dev/results//btrfs/012.out.bad     2016-09-29 12:12:33.672459590 +0300
    @@ -1 +1,3 @@
     == QA output created by 012
    +btrfs-convert failed
    +(see /home/mator/xfstests-dev/results//btrfs/012.full for details)
    ...
    (Run 'diff -u tests/btrfs/012.out /home/mator/xfstests-dev/results//btrfs/012.out.bad'  to see the entire diff)
btrfs/013        11s
btrfs/014        201s
btrfs/015        0s
btrfs/016        1s
btrfs/017        1s
btrfs/018        1s
btrfs/019        1s
btrfs/020        2s
btrfs/021        16s
btrfs/022        4s
btrfs/023        7s
btrfs/024        2s
btrfs/025        2s
btrfs/026        5s
btrfs/027        [not run] btrfs and this test needs 5 or more disks in SCRATCH_DEV_POOL
btrfs/028        31s
btrfs/029        1s
btrfs/030        2s
btrfs/031        1s
btrfs/032        1s
btrfs/033        28s
btrfs/034        9s
btrfs/035        1s
btrfs/036        47s
btrfs/037        7s
btrfs/038        2s
btrfs/039        2s
btrfs/040        1s
btrfs/041        2s
btrfs/042        1s
btrfs/043        1s
btrfs/044        2s
btrfs/045        2s
btrfs/046        7s
btrfs/047        [not run] Missing btrfs-progs send --stream-version command line option, skipped this test
btrfs/048        3s
btrfs/049        6s
btrfs/050        17s
btrfs/051        2s
btrfs/052        9s
btrfs/053        2s
btrfs/054        2s
btrfs/055        2s
btrfs/056        4s
btrfs/057        [failed, exit status 1] - output mismatch (see /home/mator/xfstests-dev/results//btrfs/057.out.bad)
    --- tests/btrfs/057.out     2016-09-24 11:51:48.206889520 +0300
    +++ /home/mator/xfstests-dev/results//btrfs/057.out.bad     2016-09-29 12:20:27.184192306 +0300
    @@ -1,3 +1,3 @@
     QA output created by 057
    -4096 4096  
    -4096 4096  
    +failed: '_scratch_mkfs -b 1g --nodesize 4096'
    +(see /home/mator/xfstests-dev/results//btrfs/057.full for details)
    ...
    (Run 'diff -u tests/btrfs/057.out /home/mator/xfstests-dev/results//btrfs/057.out.bad'  to see the entire diff)
btrfs/058        4s
btrfs/059        1s
btrfs/060        101s
btrfs/061        99s
btrfs/062        201s
btrfs/063        97s
btrfs/064        [not run] btrfs and this test needs 5 or more disks in SCRATCH_DEV_POOL
btrfs/065        [not run] btrfs and this test needs 5 or more disks in SCRATCH_DEV_POOL
btrfs/066        16s
btrfs/067        45s
btrfs/068        16s
btrfs/069        [not run] btrfs and this test needs 5 or more disks in SCRATCH_DEV_POOL
btrfs/070        [not run] btrfs and this test needs 5 or more disks in SCRATCH_DEV_POOL
btrfs/071        [not run] btrfs and this test needs 5 or more disks in SCRATCH_DEV_POOL
btrfs/072        44s
btrfs/073        17s
btrfs/074        48s
btrfs/075        [not run] Require selinux to be enabled
btrfs/076        1s
btrfs/077        2s
btrfs/078        14s
btrfs/079        [not run] This test requires at least 10GB free on /mnt/scratch to run
btrfs/080        139s
btrfs/081        1s
btrfs/082        1s
btrfs/083        2s
btrfs/084        2s
btrfs/085        4s
btrfs/086        1s
btrfs/087        2s
btrfs/088        [not run] /sys/kernel/debug/fail_make_request  not found. Seems that CONFIG_FAIL_MAKE_REQUEST kernel config option not enabled
btrfs/089        1s
btrfs/090        2s
btrfs/091        1s
btrfs/092        1s
btrfs/093        2s
btrfs/094        1s
btrfs/095        2s
btrfs/096        1s
btrfs/097        1s
btrfs/098        1s
btrfs/099        1s
btrfs/100        14s
btrfs/101       



mator@ttip:~/xfstests-dev/results/btrfs$ top -bin 1
top - 14:37:17 up  2:28,  2 users,  load average: 1.00, 1.00, 1.00
Tasks: 342 total,   2 running, 340 sleeping,   0 stopped,   0 zombie
%Cpu(s):  1.4 us,  3.8 sy,  0.0 ni, 94.8 id,  0.1 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem : 33141248 total, 30396208 free,   248920 used,  2496120 buff/cache
KiB Swap:        0 total,        0 free,        0 used. 32184752 avail Mem 

   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
193017 root      20   0    9448   1008    800 R  90.9  0.0 120:59.48 btrfs


btrfs/101 hangs, unable to strace it or attach via gdb to get stack trace. Just
to remind that I have btrgs-progs from debian sid/unstable:
# apt-cache show btrfs-progs  | grep Ver 
Version: 4.7.3-1
	

Current ~/xfstests-dev/results/ (with stuck btrfs/101) available at 
http://u163.east.ru/btrfs/xfstests-dev-sparc64-4.8-btrfs-free-space-tree-and-sanity-test-fixes.tar.gz

