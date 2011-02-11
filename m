From: Wido den Hollander <wido@widodh.nl>
Subject: kernel BUG at /usr/src/btrfs-work/fs/btrfs/extent-tree.c:2195
Date: Fri, 11 Feb 2011 21:38:40 +0100
Message-ID: <1297456720.4281.99.camel@wido-laptop.pcextreme.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

While testing with my Ceph cluster I saw some btrfs messages:
http://pastebin.com/URN3ShVb

I'm not sure when these messages came up (What state of the OSD).

To keep up with the recent btrfs changes I'm using Josef's btrfs-work
repository ( aba63cd31ab85e3ec7e9805fadc77dad8b7fc945 ) with the 2.6.38
kernel.

One of my OSD's (Object Store Daemons) is still blocking, this is the
OSD which is using /dev/sdc (See the pastebin errors about sdc).

It's in status D, the stack is showing:

root@noisy:~# cat /proc/1974/task/2043/stack 
[<ffffffffa033fc3a>] btrfs_commit_transaction_async+0x25a/0x2e0 [btrfs]
[<ffffffffa036e48e>] btrfs_mksubvol+0x2ae/0x350 [btrfs]
[<ffffffffa036e62a>] btrfs_ioctl_snap_create_transid+0xfa/0x150 [btrfs]
[<ffffffffa036e709>] btrfs_ioctl_snap_create_v2+0x89/0x100 [btrfs]
[<ffffffffa0371692>] btrfs_ioctl+0x762/0xa90 [btrfs]
[<ffffffff8116de1d>] vfs_ioctl+0x1d/0x50
[<ffffffff8116e8b9>] do_vfs_ioctl+0x69/0x1d0
[<ffffffff8116eab4>] sys_ioctl+0x94/0xa0
[<ffffffff8100c002>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
root@noisy:~#

I don't know if it is related to the messages in my dmesg, but I thought
i'd send it anyway.

Is this a known bug?

Thank you,

Wido

