Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from u164.east.ru ([195.170.63.164]:41597 "EHLO u164.east.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752674AbcIYIEh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Sep 2016 04:04:37 -0400
Date: Sun, 25 Sep 2016 10:55:24 +0300
From: Anatoly Pugachev <matorola@gmail.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 0/6] Btrfs: free space tree and sanity test fixes
Message-ID: <20160925075524.GA3870@yogzotot>
References: <cover.1474580472.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1474580472.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 05:22:31PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> This is v2 of my earlier series "Btrfs: fix free space tree
> bitmaps+tests on big-endian systems" [1]. Patches 1, 4, and 5 are the
> same as patches 1, 2, and 3 from the original series. I've added patch 2
> to fix another bug I noticed (an xfstest went out earlier). Patch 3 is
> the result of the earlier discussion here [2]. Finally, patch 6 was
> necessary to get the sanity tests to run on my MIPS emulator.
> 
> This series applies to v4.8-rc7. The sanity tests pass on both x86-64
> and MIPS, and there are no xfstests regressions. Chandan and Anatoly,
> could you test these out as well?
> 
> I'm working on the btrfs-progs follow up, but these patches are safe
> without that -- the new FREE_SPACE_TREE_VALID bit will stop all versions
> of btrfs-progs from mounting read-write.

Omar,

applied patch to git kernel (v4.8-rc7-172-gbd5dbcb) cleanly. Did not used
btrfs-progs.git, but debian shipped 4.7.3-1 .

(re)booted to a newly patched kernel and used xfstests.git (v1.1.0-1328-g06d4001):

# mount tmpfs -t tmpfs -o size=26g /ramdisk
# cd /ramdisk
# fallocate -l 10g testvol1
# for i in 1 2 3 4; do fallocate -l 4g scratch${i}; done
# for i in *; do losetup -f $i; done
# losetup
NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE         DIO
/dev/loop0         0      0         0  0 /ramdisk/scratch1   0
/dev/loop1         0      0         0  0 /ramdisk/scratch2   0
/dev/loop2         0      0         0  0 /ramdisk/scratch3   0
/dev/loop3         0      0         0  0 /ramdisk/scratch4   0
/dev/loop4         0      0         0  0 /ramdisk/testvol1   0

mator@ttip:~/xfstests-dev$ cat local.config
export TEST_DEV=/dev/loop4
export TEST_DIR=/testvol
export SCRATCH_DEV_POOL="/dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3"
export SCRATCH_MNT=/mnt/scratch

root@ttip:/home/mator/xfstests-dev# mkfs.btrfs /dev/loop4
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

root@ttip:/home/mator/xfstests-dev# ./check 'btrfs/*'
FSTYP         -- btrfs
PLATFORM      -- Linux/sparc64 ttip 4.8.0-rc7+
MKFS_OPTIONS  -- /dev/loop0
MOUNT_OPTIONS -- /dev/loop0 /mnt/scratch

_check_btrfs_filesystem: filesystem on /dev/loop4 is inconsistent (see /home/mator/xfstests-dev/results//check.full)
btrfs/001


(on another screen/tmux window shell)

$ pstree -A | grep check 
        |-sshd-+-sshd---sshd---bash---sudo---bash---check---001---mount

$ ps ax | grep mount
 76344 pts/0    D+     0:00 /bin/mount -t btrfs /dev/loop4 /testvol

$ cat /home/mator/xfstests-dev/results//check.full
_check_btrfs_filesystem: filesystem on /dev/loop4 is inconsistent
*** fsck.btrfs output ***
ERROR: cannot open device '/dev/loop4': Device or resource busy
Couldn't open file system
*** end fsck.btrfs output
*** mount output ***
sysfs on /sys type sysfs (rw,relatime)
proc on /proc type proc (rw,relatime)
udev on /dev type devtmpfs (rw,nosuid,relatime,size=16479064k,nr_inodes=2059883,mode=755)
devpts on /dev/pts type devpts (rw,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,noexec,relatime,size=3314128k,mode=755)
/dev/vdiska2 on / type ext4 (rw,relatime,errors=remount-ro,data=ordered)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw)
tmpfs on /run/lock type tmpfs (rw,nosuid,nodev,noexec,relatime,size=5120k)
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpu,cpuacct)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,net_cls,net_prio)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,pids)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=29,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=23073)
mqueue on /dev/mqueue type mqueue (rw,relatime)
debugfs on /sys/kernel/debug type debugfs (rw,relatime)
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime)
/dev/vdiska1 on /boot type ext3 (rw,relatime,data=ordered)
/dev/vdiskb1 on /home type xfs (rw,relatime,attr2,inode64,noquota)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,relatime)
tmpfs on /run/user/1000 type tmpfs (rw,nosuid,nodev,relatime,size=3314120k,mode=700,uid=1000,gid=1000)
tmpfs on /ramdisk type tmpfs (rw,relatime,size=27262976k)
/dev/loop0 on /mnt/scratch type btrfs (rw,relatime,space_cache,subvolid=5,subvol=/)
*** end mount output

in kernel logs and on console:

[3184224.438566] BTRFS: device fsid b54ec0aa-4187-419d-9de1-5ef284cd3b32 devid 1 transid 5 /dev/loop4
[3184239.417845] BTRFS info (device loop4): disk space caching is enabled
[3184239.417865] BTRFS info (device loop4): has skinny extents
[3184239.417872] BTRFS info (device loop4): flagging fs with big metadata feature
[3184239.421147] BTRFS info (device loop4): creating UUID tree
[3184240.026601] BTRFS: device fsid 5383d227-9ea2-4514-8857-641c6e2e2063 devid 1 transid 5 /dev/loop0
[3184240.131927] BTRFS info (device loop0): disk space caching is enabled
[3184240.131956] BTRFS info (device loop0): has skinny extents
[3184240.131971] BTRFS info (device loop0): flagging fs with big metadata feature
[3184240.135182] BTRFS info (device loop0): creating UUID tree
[3184240.252534] BTRFS critical (device loop4): corrupt leaf, non-root leaf's nritems is 0: block=29556736,root=1, slot=0
[3184240.252558] BTRFS info (device loop4): leaf 29556736 total ptrs 0 free space 16283
[3184240.252567] BTRFS: assertion failed: 0, file: fs/btrfs/disk-io.c, line: 4059kernel BUG at fs/btrfs/ctree.h:3369!
[3184240.252581]               \|/ ____ \|/
[3184240.252581]               "@'/ .. \`@"
[3184240.252581]               /_| \__/ |_\
[3184240.252581]                  \__U_/
[3184240.252597] umount(76111): Kernel bad sw trap 5 [#1]
[3184240.252605] CPU: 21 PID: 76111 Comm: umount Not tainted 4.8.0-rc7+ #9
[3184240.252612] task: fff8000805feed20 task.stack: fff8000804824000
[3184240.252620] TSTATE: 0000004411001600 TPC: 00000000100d6ccc TNPC: 00000000100d6cd0 Y: 00000000    Not tainted
[3184240.252679] TPC: <btrfs_mark_buffer_dirty+0x1ac/0x1e0 [btrfs]>
[3184240.252686] g0: 0000000000000000 g1: 0000000000000000 g2: 0000000000000007 g3: 0000000000000000
[3184240.252694] g4: fff8000805feed20 g5: fff800082c66e000 g6: fff8000804824000 g7: fff800082ce00000
[3184240.252702] o0: 000000001019cac8 o1: 0000000000000d29 o2: 000000001019c930 o3: 0000000000000fdb
[3184240.252710] o4: 0000000001c30000 o5: 0000000000000000 sp: fff80008048263c1 ret_pc: 00000000100d6cc4
[3184240.252731] RPC: <btrfs_mark_buffer_dirty+0x1a4/0x1e0 [btrfs]>
[3184240.252738] l0: 000000000000154c l1: 0000000000002000 l2: 0000000000002000 l3: fff80008115fbf10
[3184240.252746] l4: fff8000805d7a698 l5: 00000000101b8400 l6: 0000000001000000 l7: 0000000000000000
[3184240.252754] i0: fff8000812f97968 i1: 0000000000000000 i2: 0700000000000000 i3: 000600001229fa48
[3184240.252762] i4: fff80008134fb000 i5: 0000000000000007 i6: fff8000804826471 i7: 00000000100a0388
[3184240.252780] I7: <__btrfs_cow_block+0x7e8/0xb80 [btrfs]>
[3184240.252786] Call Trace:
[3184240.252801]  [00000000100a0388] __btrfs_cow_block+0x7e8/0xb80 [btrfs]
[3184240.252816]  [00000000100a0948] btrfs_cow_block+0x1a8/0x340 [btrfs]
[3184240.252832]  [00000000100a6000] btrfs_search_slot+0x2a0/0xf60 [btrfs]
[3184240.252849]  [00000000100ccff4] btrfs_del_csums+0x1b4/0x6a0 [btrfs]
[3184240.252865]  [00000000100b4ecc] __btrfs_free_extent.isra.19+0x9ec/0x12c0 [btrfs]
[3184240.252884]  [00000000100ba788] __btrfs_run_delayed_refs+0x548/0x1980 [btrfs]
[3184240.252902]  [00000000100bfec8] btrfs_run_delayed_refs+0x88/0x2c0 [btrfs]
[3184240.252921]  [00000000100dcc20] commit_cowonly_roots+0xe0/0x5c0 [btrfs]
[3184240.252939]  [00000000100df9b4] btrfs_commit_transaction+0x534/0xd60 [btrfs]
[3184240.252959]  [00000000100d54c4] btrfs_commit_super+0x64/0x80 [btrfs]
[3184240.252977]  [00000000100d8a60] close_ctree+0x260/0x320 [btrfs]
[3184240.252992]  [0000000010096cd0] btrfs_put_super+0x10/0x20 [btrfs]
[3184240.253006]  [00000000005e7d74] generic_shutdown_super+0x74/0x100
[3184240.253013]  [00000000005e8050] kill_anon_super+0x10/0x40
[3184240.253028]  [00000000100969b4] btrfs_kill_super+0x14/0x100 [btrfs]
[3184240.253035]  [00000000005e8244] deactivate_locked_super+0x44/0x80
[3184240.253041] Disabling lock debugging due to kernel taint
[3184240.253057] Caller[00000000100a0388]: __btrfs_cow_block+0x7e8/0xb80 [btrfs]
[3184240.253072] Caller[00000000100a0948]: btrfs_cow_block+0x1a8/0x340 [btrfs]
[3184240.253088] Caller[00000000100a6000]: btrfs_search_slot+0x2a0/0xf60 [btrfs]
[3184240.253105] Caller[00000000100ccff4]: btrfs_del_csums+0x1b4/0x6a0 [btrfs]
[3184240.253121] Caller[00000000100b4ecc]: __btrfs_free_extent.isra.19+0x9ec/0x12c0 [btrfs]
[3184240.253139] Caller[00000000100ba788]: __btrfs_run_delayed_refs+0x548/0x1980 [btrfs]
[3184240.253158] Caller[00000000100bfec8]: btrfs_run_delayed_refs+0x88/0x2c0 [btrfs]
[3184240.253178] Caller[00000000100dcc20]: commit_cowonly_roots+0xe0/0x5c0 [btrfs]
[3184240.253198] Caller[00000000100df9b4]: btrfs_commit_transaction+0x534/0xd60 [btrfs]
[3184240.253218] Caller[00000000100d54c4]: btrfs_commit_super+0x64/0x80 [btrfs]
[3184240.253236] Caller[00000000100d8a60]: close_ctree+0x260/0x320 [btrfs]
[3184240.253251] Caller[0000000010096cd0]: btrfs_put_super+0x10/0x20 [btrfs]
[3184240.253258] Caller[00000000005e7d74]: generic_shutdown_super+0x74/0x100
[3184240.253265] Caller[00000000005e8050]: kill_anon_super+0x10/0x40
[3184240.253279] Caller[00000000100969b4]: btrfs_kill_super+0x14/0x100 [btrfs]
[3184240.253287] Caller[00000000005e8244]: deactivate_locked_super+0x44/0x80
[3184240.253293] Caller[00000000005e8f44]: deactivate_super+0x64/0x80
[3184240.253304] Caller[000000000060707c]: cleanup_mnt+0x3c/0xa0
[3184240.253310] Caller[000000000060714c]: __cleanup_mnt+0xc/0x20
[3184240.253321] Caller[00000000004859e0]: task_work_run+0xa0/0xe0
[3184240.253330] Caller[000000000042e144]: do_notify_resume+0x64/0x80
[3184240.253338] Caller[0000000000404b44]: __handle_signal+0xc/0x2c
[3184240.253344] Caller[fff8000100150db4]: 0xfff8000100150db4
[3184240.253349] Instruction DUMP: 92102d29  7c0d43df  901222c8 <91d02005> d25e2008  d4422b40  7c19cac2  90022af0  106fffe1
[3184240.312832] run fstests btrfs/001 at 2016-09-25 10:25:48


Do I need to redo test with btrfs-progs.git version instead of debian one?

Thanks.

PS: boot log of btrfs module:

[3102837.407118] xor: automatically using best checksumming function:
[3102837.446156]    Niagara   :  4898.000 MB/sec
[3102837.870398] Btrfs loaded, crc32c=crc32c-sparc64, debug=on, assert=on, integrity-checker=on
[3102837.871047] BTRFS: selftest: sectorsize: 8192  nodesize: 8192
[3102837.871055] BTRFS: selftest: Running btrfs free space cache tests
[3102837.871242] BTRFS: selftest: Running extent only tests
[3102837.871261] BTRFS: selftest: Running bitmap only tests
[3102837.871338] BTRFS: selftest: Running bitmap and extent tests
[3102837.871443] BTRFS: selftest: Running space stealing from bitmap to extent
[3102837.872016] BTRFS: selftest: Free space cache tests finished
[3102837.872023] BTRFS: selftest: Running extent buffer operation tests
[3102837.872028] BTRFS: selftest: Running btrfs_split_item tests
[3102837.872394] BTRFS: selftest: Running extent I/O tests
[3102837.872401] BTRFS: selftest: Running find delalloc tests
[3102837.872953] BTRFS: selftest: Running extent buffer bitmap tests
[3102837.921398] BTRFS: selftest: Extent I/O tests finished
[3102837.921409] BTRFS: selftest: Running btrfs_get_extent tests
[3102837.921901] BTRFS: selftest: Running hole first btrfs_get_extent test
[3102837.922261] BTRFS: selftest: Running outstanding_extents tests
[3102837.922831] BTRFS: selftest: Running qgroup tests
[3102837.922838] BTRFS: selftest: Qgroup basic add
[3102837.922901] BTRFS: selftest: Qgroup multiple refs test
[3102837.924768] BTRFS: selftest: Running free space tree tests
[3102837.962292] BTRFS: selftest: sectorsize: 8192  nodesize: 16384
[3102837.962303] BTRFS: selftest: Running btrfs free space cache tests
[3102837.962486] BTRFS: selftest: Running extent only tests
[3102837.962502] BTRFS: selftest: Running bitmap only tests
[3102837.962576] BTRFS: selftest: Running bitmap and extent tests
[3102837.962681] BTRFS: selftest: Running space stealing from bitmap to extent
[3102837.963250] BTRFS: selftest: Free space cache tests finished
[3102837.963257] BTRFS: selftest: Running extent buffer operation tests
[3102837.963262] BTRFS: selftest: Running btrfs_split_item tests
[3102837.963601] BTRFS: selftest: Running extent I/O tests
[3102837.963607] BTRFS: selftest: Running find delalloc tests
[3102837.964145] BTRFS: selftest: Running extent buffer bitmap tests
[3102838.012532] BTRFS: selftest: Extent I/O tests finished
[3102838.012539] BTRFS: selftest: Running btrfs_get_extent tests
[3102838.012951] BTRFS: selftest: Running hole first btrfs_get_extent test
[3102838.013292] BTRFS: selftest: Running outstanding_extents tests
[3102838.013830] BTRFS: selftest: Running qgroup tests
[3102838.013836] BTRFS: selftest: Qgroup basic add
[3102838.013879] BTRFS: selftest: Qgroup multiple refs test
[3102838.015744] BTRFS: selftest: Running free space tree tests
[3102838.053230] BTRFS: selftest: sectorsize: 8192  nodesize: 32768
[3102838.053237] BTRFS: selftest: Running btrfs free space cache tests
[3102838.053419] BTRFS: selftest: Running extent only tests
[3102838.053430] BTRFS: selftest: Running bitmap only tests
[3102838.053493] BTRFS: selftest: Running bitmap and extent tests
[3102838.053597] BTRFS: selftest: Running space stealing from bitmap to extent
[3102838.054167] BTRFS: selftest: Free space cache tests finished
[3102838.054173] BTRFS: selftest: Running extent buffer operation tests
[3102838.054179] BTRFS: selftest: Running btrfs_split_item tests
[3102838.054512] BTRFS: selftest: Running extent I/O tests
[3102838.054518] BTRFS: selftest: Running find delalloc tests
[3102838.054956] BTRFS: selftest: Running extent buffer bitmap tests
[3102838.103317] BTRFS: selftest: Extent I/O tests finished
[3102838.103324] BTRFS: selftest: Running btrfs_get_extent tests
[3102838.103728] BTRFS: selftest: Running hole first btrfs_get_extent test
[3102838.104068] BTRFS: selftest: Running outstanding_extents tests
[3102838.104603] BTRFS: selftest: Running qgroup tests
[3102838.104609] BTRFS: selftest: Qgroup basic add
[3102838.104644] BTRFS: selftest: Qgroup multiple refs test
[3102838.106503] BTRFS: selftest: Running free space tree tests
[3102838.143985] BTRFS: selftest: sectorsize: 8192  nodesize: 65536
[3102838.143992] BTRFS: selftest: Running btrfs free space cache tests
[3102838.144173] BTRFS: selftest: Running extent only tests
[3102838.144184] BTRFS: selftest: Running bitmap only tests
[3102838.144247] BTRFS: selftest: Running bitmap and extent tests
[3102838.144350] BTRFS: selftest: Running space stealing from bitmap to extent
[3102838.144915] BTRFS: selftest: Free space cache tests finished
[3102838.144921] BTRFS: selftest: Running extent buffer operation tests
[3102838.144926] BTRFS: selftest: Running btrfs_split_item tests
[3102838.145260] BTRFS: selftest: Running extent I/O tests
[3102838.145266] BTRFS: selftest: Running find delalloc tests
[3102838.145700] BTRFS: selftest: Running extent buffer bitmap tests
[3102838.194039] BTRFS: selftest: Extent I/O tests finished
[3102838.194045] BTRFS: selftest: Running btrfs_get_extent tests
[3102838.194462] BTRFS: selftest: Running hole first btrfs_get_extent test
[3102838.194804] BTRFS: selftest: Running outstanding_extents tests
[3102838.195339] BTRFS: selftest: Running qgroup tests
[3102838.195345] BTRFS: selftest: Qgroup basic add
[3102838.195380] BTRFS: selftest: Qgroup multiple refs test
[3102838.197235] BTRFS: selftest: Running free space tree tests
[3102838.288732] random: fast init done

