Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:33981 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753246AbcLGQLn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 11:11:43 -0500
Received: by mail-ua0-f181.google.com with SMTP id 51so419763617uai.1
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Dec 2016 08:11:42 -0800 (PST)
MIME-Version: 1.0
From: Yclept Nemo <orbisvicis@gmail.com>
Date: Wed, 7 Dec 2016 11:11:41 -0500
Message-ID: <CALurfZUCpzPKgLafJFy2SehfWq_4qYxaaHkWJ82Q8dn3XjDD0w@mail.gmail.com>
Subject: [bug]: possible recursive locking detected
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel version: drm-next x86_64
abrt (fedora) bug report: https://bugzilla.redhat.com/show_bug.cgi?id=1402453
dmesg snippet (the full dmesg is 15Mb):

kernel: =============================================
kernel: [ INFO: possible recursive locking detected ]
kernel: 4.9.0-0.rc8.git0.1.fc25.x86_64 #1 Not tainted
kernel: ---------------------------------------------
kernel: gvfsd-metadata/1397 is trying to acquire lock:
kernel:  (
kernel: &ei->log_mutex
kernel: ){+.+...}
kernel: , at:
kernel: [<ffffffffc05f53f2>] btrfs_log_inode+0x162/0x1190 [btrfs]
kernel:
        but task is already holding lock:
kernel:  (
kernel: &ei->log_mutex
kernel: ){+.+...}
kernel: , at:
kernel: [<ffffffffc05f53f2>] btrfs_log_inode+0x162/0x1190 [btrfs]
kernel:
        other info that might help us debug this:
kernel:  Possible unsafe locking scenario:
kernel:        CPU0
kernel:        ----
kernel:   lock(
kernel: &ei->log_mutex
kernel: );
kernel:   lock(
kernel: &ei->log_mutex
kernel: );
kernel:
         *** DEADLOCK ***
kernel:  May be due to missing lock nesting notation
kernel: 3 locks held by gvfsd-metadata/1397:
kernel:  #0:
kernel:  (
kernel: &type->i_mutex_dir_key
kernel: #3
kernel: ){++++++}
kernel: , at:
kernel: [<ffffffffc05c3de3>] btrfs_sync_file+0x163/0x4c0 [btrfs]
kernel:  #1:
kernel:  (
kernel: sb_internal
kernel: ){.+.+.+}
kernel: , at:
kernel: [<ffffffffc05aaa16>] start_transaction+0x2f6/0x530 [btrfs]
kernel:  #2:
kernel:  (
kernel: &ei->log_mutex
kernel: ){+.+...}
kernel: , at:
kernel: [<ffffffffc05f53f2>] btrfs_log_inode+0x162/0x1190 [btrfs]
kernel:
        stack backtrace:
kernel: CPU: 0 PID: 1397 Comm: gvfsd-metadata Not tainted
4.9.0-0.rc8.git0.1.fc25.x86_64 #1
kernel: Hardware name:    /LP NF4 Series, BIOS 6.00 PG 01/25/2005
kernel:  ffffb5c3c383b760 ffffffffa64772e3 ffffffffa7be05e0 ffff96512b328000
kernel:  ffffb5c3c383b828 ffffffffa611231e ffffb5c3c383b780 ffffffff00000003
kernel:  00000000c383b7a8 ffffffffa74e5600 6629c0631375af20 ffff96512b328ca8
kernel: Call Trace:
kernel:  [<ffffffffa64772e3>] dump_stack+0x86/0xc3
kernel:  [<ffffffffa611231e>] __lock_acquire+0x78e/0x1290
kernel:  [<ffffffffa60ed4b0>] ? sched_clock_cpu+0x90/0xc0
kernel:  [<ffffffffa691395e>] ? mutex_unlock+0xe/0x10
kernel:  [<ffffffffa6113286>] lock_acquire+0xf6/0x1f0
kernel:  [<ffffffffc05f53f2>] ? btrfs_log_inode+0x162/0x1190 [btrfs]
kernel:  [<ffffffffa6912ce6>] mutex_lock_nested+0x86/0x3f0
kernel:  [<ffffffffc05f53f2>] ? btrfs_log_inode+0x162/0x1190 [btrfs]
kernel:  [<ffffffffc060bb05>] ? __btrfs_release_delayed_node+0x75/0x1c0 [btrfs]
kernel:  [<ffffffffc05f53f2>] ? btrfs_log_inode+0x162/0x1190 [btrfs]
kernel:  [<ffffffffc060d999>] ?
btrfs_commit_inode_delayed_inode+0xe9/0x130 [btrfs]
kernel:  [<ffffffffc05f53f2>] btrfs_log_inode+0x162/0x1190 [btrfs]
kernel:  [<ffffffffa60e16fa>] ? __might_sleep+0x4a/0x80
kernel:  [<ffffffffc05f5fa8>] btrfs_log_inode+0xd18/0x1190 [btrfs]
kernel:  [<ffffffffa60ed3b7>] ? sched_clock_local+0x17/0x80
kernel:  [<ffffffffc0635dc7>] log_new_dir_dentries+0x1e1/0x4c0 [btrfs]
kernel:  [<ffffffffc05f6d48>] btrfs_log_inode_parent+0x898/0x940 [btrfs]
kernel:  [<ffffffffa62ca879>] ? dget_parent+0x99/0x2a0
kernel:  [<ffffffffc05f7d92>] btrfs_log_dentry_safe+0x62/0x80 [btrfs]
kernel:  [<ffffffffc05c3f92>] btrfs_sync_file+0x312/0x4c0 [btrfs]
kernel:  [<ffffffffa62eb6db>] vfs_fsync_range+0x4b/0xb0
kernel:  [<ffffffffa62eb79d>] do_fsync+0x3d/0x70
kernel:  [<ffffffffa62eba60>] SyS_fsync+0x10/0x20
kernel:  [<ffffffffa6917741>] entry_SYSCALL_64_fastpath+0x1f/0xc2
