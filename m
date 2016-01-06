Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35354 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbcAFJIr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 04:08:47 -0500
Received: by mail-io0-f180.google.com with SMTP id 77so181787882ioc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jan 2016 01:08:46 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 6 Jan 2016 18:08:46 +0900
Message-ID: <CAG8fp8T9=_HFHYayh=hP-VOa-DD2+G5Fg-dLv9SJr9wGhybA6w@mail.gmail.com>
Subject: sendfile(2) not killable on btrfs
From: Akihiro Suda <suda.kyoto@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have an issue on btrfs, and opened a bugzilla ticket:
https://bugzilla.kernel.org/show_bug.cgi?id=110391

=====
Commit 296291cd should have made sendfile(2) killable.

https://github.com/torvalds/linux/commit/296291cd
> Currently a simple program below issues a sendfile(2) system call which
> takes about 62 days to complete in my test KVM instance.
>
>         int fd;
>         off_t off = 0;
>
>         fd = open("file", O_RDWR | O_TRUNC | O_SYNC | O_CREAT, 0644);
>         ftruncate(fd, 2);
>         lseek(fd, 0, SEEK_END);
>         sendfile(fd, fd, &off, 0xfffffff);
>
> Now you should not ask kernel to do a stupid stuff like copying 256MB in
> 2-byte chunks and call fsync(2) after each chunk but if you do, sysadmin
> should have a way to stop you.


However, it is still not killable on btrfs.

Stack trace:

  [<ffffffffc021ea60>] write_all_supers.isra.45+0x960/0xb00 [btrfs]
  [<ffffffffc02200f7>] write_ctree_super+0x17/0x20 [btrfs]
  [<ffffffffc026b1c7>] btrfs_sync_log+0x897/0xb40 [btrfs]
  [<ffffffffc023d0c8>] btrfs_sync_file+0x328/0x360 [btrfs]
  [<ffffffff8122fe9b>] vfs_fsync_range+0x4b/0xb0
  [<ffffffffc023d307>] btrfs_file_write_iter+0x207/0x510 [btrfs]
  [<ffffffff811fca0b>] new_sync_write+0x9b/0xe0
  [<ffffffff811fca76>] __vfs_write+0x26/0x40
  [<ffffffff811fce13>] __kernel_write+0x53/0xf0
  [<ffffffff8122d832>] write_pipe_buf+0x72/0xa0
  [<ffffffff8122d349>] __splice_from_pipe+0xf9/0x170
  [<ffffffff8122eeee>] splice_from_pipe+0x5e/0x90
  [<ffffffff8122ef5d>] default_file_splice_write+0x1d/0x30
  [<ffffffff8122cda6>] direct_splice_actor+0x36/0x40
  [<ffffffff8122d9d6>] splice_direct_to_actor+0xe6/0x210
  [<ffffffff8122db98>] do_splice_direct+0x98/0xd0
  [<ffffffff811fddef>] do_sendfile+0x1bf/0x3a0
  [<ffffffff811fea2e>] SyS_sendfile64+0x5e/0xb0
  [<ffffffff817f02b2>] entry_SYSCALL_64_fastpath+0x16/0x75
  [<ffffffffffffffff>] 0xffffffffffffffff
