Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:58256 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdAMQj7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jan 2017 11:39:59 -0500
Received: from [2601:196:4600:77b0:ae9e:17ff:feb7:72ca] (helo=wopr.kernelslacker.org)
        by scorn.kernelslacker.org with esmtp (Exim 4.84_2)
        (envelope-from <davej@codemonkey.org.uk>)
        id 1cS4cH-0000Po-Je
        for linux-btrfs@vger.kernel.org; Fri, 13 Jan 2017 11:22:14 -0500
Date: Fri, 13 Jan 2017 11:22:13 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: 4.10-rc btrfs gets 'stuck'.
Message-ID: <20170113162213.vx53xa3zf6nglbrq@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've seen this happen 3 times during 4.10rc.

When running trinity, it gets 'stuck', with all but one process
stuck on a lock.  I've left this running for days, and it never makes
progress.  The process holding the lock seems to be stuck somewhere.

When this happens it's pretty apparent in ps axf output.

10129 pts/1    SL+    0:36     \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl --dr
10165 ?        DNs    0:03         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
10186 ?        DNs    0:01         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
10187 ?        DNs    0:02         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
12533 ?        DNs    0:01         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
14334 ?        DNs    0:01         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
14356 ?        Ds     0:01         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
14532 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
15149 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
15214 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
15588 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
15657 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
15850 pts/1    DN     0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
16092 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
16439 pts/1    DN     0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
16772 ?        RNs  2498:28         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl
17033 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
17420 ?        Ds     0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
17438 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
17535 ?        Ds     0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
17690 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
17711 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
17730 ?        Ds     0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
17760 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
17863 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
17990 ?        DNs    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
18387 pts/1    DL+    0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
18500 pts/1    D+     0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
18625 ?        Ds     0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
18748 ?        Ds     0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl 
18807 pts/1    D+     0:00         \_ ../trinity -C64 -D -q -l off --dropprivs -N 1000000 -a64 --disable-fds=perf --enable-fds=testfile -x ioctl

(Note the 2498:28 runtime of the only running child task).

As mentioned, all the blocked children are sleeping..

18807
[<ffffffff813dd9c7>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffffa0094beb>] btrfs_fallocate+0xcb/0x11d0 [btrfs]
[<ffffffff81245453>] vfs_fallocate+0x143/0x230
[<ffffffff81246358>] SyS_fallocate+0x48/0x80
[<ffffffff81002d81>] do_syscall_64+0x61/0x170
[<ffffffff818cb3cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

18748
[<ffffffff813dd9c7>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffffa0096d02>] btrfs_sync_file+0x162/0x4c0 [btrfs]
[<ffffffff81283d8b>] vfs_fsync_range+0x4b/0xb0
[<ffffffff81283e4d>] do_fsync+0x3d/0x70
[<ffffffff81284100>] SyS_fsync+0x10/0x20
[<ffffffff81002d81>] do_syscall_64+0x61/0x170
[<ffffffff818cb3cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

18625
[<ffffffff8126bdf9>] __fdget_pos+0x49/0x50
[<ffffffff8124a7ce>] SyS_write+0x2e/0xc0
[<ffffffff81002d81>] do_syscall_64+0x61/0x170
[<ffffffff818cb3cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

18500
[<ffffffff813dd9c7>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffffa00970d8>] btrfs_file_write_iter+0x78/0x570 [btrfs]
[<ffffffff81248888>] do_iter_readv_writev+0xb8/0x120
[<ffffffff81249594>] do_readv_writev+0x1a4/0x250
[<ffffffff8124989f>] vfs_writev+0x3f/0x50
[<ffffffff81249a65>] do_pwritev+0xb5/0xd0
[<ffffffff8124ac37>] SyS_pwritev2+0x17/0x30
[<ffffffff81002d81>] do_syscall_64+0x61/0x170
[<ffffffff818cb3cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

18387
[<ffffffff813dd9c7>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffffa0096d02>] btrfs_sync_file+0x162/0x4c0 [btrfs]
[<ffffffff81283d8b>] vfs_fsync_range+0x4b/0xb0
[<ffffffff81283e4d>] do_fsync+0x3d/0x70
[<ffffffff81284100>] SyS_fsync+0x10/0x20
[<ffffffff81002d81>] do_syscall_64+0x61/0x170
[<ffffffff818cb3cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

17990
[<ffffffff8126bdf9>] __fdget_pos+0x49/0x50
[<ffffffff81248d5d>] SyS_lseek+0x1d/0xb0
[<ffffffff81002d81>] do_syscall_64+0x61/0x170
[<ffffffff818cb3cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

17863
[<ffffffff813dd9c7>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffff812456ca>] chmod_common+0x9a/0x150
[<ffffffff81246afa>] SyS_fchmod+0x3a/0x70
[<ffffffff81002d81>] do_syscall_64+0x61/0x170
[<ffffffff818cb3cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

17760
[<ffffffff8126bdf9>] __fdget_pos+0x49/0x50
[<ffffffff812498e3>] do_writev+0x33/0x100
[<ffffffff8124aba0>] SyS_writev+0x10/0x20
[<ffffffff81002d81>] do_syscall_64+0x61/0x170
[<ffffffff818cb3cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

17730
[<ffffffff8126bdf9>] __fdget_pos+0x49/0x50
[<ffffffff8124a7ce>] SyS_write+0x2e/0xc0
[<ffffffff81002d81>] do_syscall_64+0x61/0x170
[<ffffffff818cb3cb>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

etc etc.



Function graph trace of the running pid :
http://codemonkey.org.uk/junk/btrfs-stuck3.txt
(There are also stuck1 and stuck2 in that dir from other runs if they're interesting)


Also of note, is that the running task isn't killable.

iotop shows that there's almost no IO going on at all.

The syscall that the running child is trying to do is pretty simple..

fallocate(fd=7, mode=0x3, offset=114, len=9440) 

perhaps interesting, is that the file backing that fd has been unlinked.

# ll /proc/16772/fd/7
lrwx------ 1 root root 64 Jan 13 11:21 /proc/16772/fd/7 -> /mnt/ssd/trinity/tmp/trinity.9kTIQN/tmp/trinity-testfile4 (deleted)


	Dave

