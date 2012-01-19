From: Elsa Thomas <elsa.thomas-f5ob1dq@yopmail.com>
Subject: Errors after clean reboot
Date: Wed, 18 Jan 2012 22:54:37 -0800
Message-ID: <CALkG1Nwkeohg0CwWg-bGDnvvMuJLFO8RvB1r0FddqCk8MRDdww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I can no longer mount my Btrfs filesystem after a clean reboot. Before
the reboot, there were errors in the syslog, but unfortunately I can't
recover them now that the root filesystem won't mount.

Here is a mount attempt using kernel 3.2.1 with the latest git copy of
the btrfs-progs from Josef's repository
(77ac61128a0722cab89c785f5f2247304133b214). If there are any crazy
outputs below, it might be my transcription:

ref mismatch on [11938124288000 4096] extent item 1, found 0
Backref 11938124288000 root 7 not referenced
Incorrect global back ref count on 11938124288000 found 1 wanted 0
backpointer mismatch on [11938124288000 4096]
owner ref check failed [11938124288000 4096]
ref mismatch on [11938136866816 4096] extent item 1, found 0
Backref 11938136866816 root 7 not referenced
Incorrect global back ref count on 11938136866816 found 1 wanted 0
backpointer mismatch on [11938136866816 4096]
owner ref check failed [11938136866816 4096]
found 1899959918593 bytes used err is 1
total csum bytes: 0
total tree bytes: 8092626944
total fs tree bytes: 7476834304
btree space waste bytes: 2147150418
file data blocks allocated: 5397271654400
 referenced 1887149088768
Btrfs Btrfs v0.19
[ 2860.812831] btrfsck used greatest stack depth: 2400 bytes left
dracut:/# mount -t btrfs -o recovery /dev/sdd3 /blah2
[ 2905.640723] device fsid 10209b28-8190-4af6-9bce-8543c22bde8d devid
15 transid 808248 /dev/sdd3
[ 2905.862540] btrfs: enabling auto recovery parent transit verify
failed on 6223284617216 wanted 807415 found 807912
[ 2906.127226] parent transit verify failed on 6223284617216 wanted
807415 found 807912
[ 2906.129364] parent transit verify failed on 6223284617216 wanted
807415 found 807912
[ 2906.129791] parent transit verify failed on 6223284617216 wanted
807415 found 807912
[ 2906.218505] btrfs: open_ctree failed
