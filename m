Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53822 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524Ab3BVRWE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 12:22:04 -0500
Received: by mail-pb0-f50.google.com with SMTP id up1so514935pbc.37
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 09:22:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130222165302.GE2062@localhost.localdomain>
References: <CAMfhy91avz+euv1vtomHMv87o-f57paUDAgegEXtn9gQ==W3Fg@mail.gmail.com>
	<20130222165302.GE2062@localhost.localdomain>
Date: Fri, 22 Feb 2013 12:22:04 -0500
Message-ID: <CAMfhy91KbFSdCyNdQo1a4whWtqg2TbXKLuJdCiRTfj9E3oOePw@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/extent_io.c:4718 map_private_extent_buffer+0xd4/0xe0
 [btrfs]()
From: Mace Moneta <moneta.mace@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 11:53 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Fri, Feb 22, 2013 at 07:46:16AM -0700, Mace Moneta wrote:
>> https://bugzilla.redhat.com/show_bug.cgi?id=906142
>>
>> With 3.8 kernels in Fedora 18, using encfs on btrfs I get the
>> following error.  It can take hours of use before I get a
>> reoccurrence, and I need to btrfsck, btrfs-zero-log, and/or mount with
>> '-o recovery' to get the filesystem back after a reboot.  No data
>> appears to be lost, and a scrub runs to completion with no errors.
>
> Could you do
>
> gdb btrfs.ko
> list *(btrfs_log_inode+0x3b8)
>
> and tell me what it says?  Thanks,
>
> Josef

# uname -r
3.8.0-0.rc7.git0.1.fc19.x86_64

# gdb /usr/lib/modules/3.8.0-0.rc7.git0.1.fc19.x86_64/kernel/fs/btrfs/btrfs.ko

(gdb) list *(btrfs_log_inode+0x3b8)
0x675b8 is in btrfs_log_inode (fs/btrfs/tree-log.c:3633).
3628
3629    log_extents:
3630            if (fast_search) {
3631                    btrfs_release_path(dst_path);
3632                    ret = btrfs_log_changed_extents(trans, root,
inode, dst_path);
3633                    if (ret) {
3634                            err = ret;
3635                            goto out_unlock;
3636                    }
3637            } else {
(gdb)
