From: btrfs@nentwig.biz
Subject: can't read superblock (but could mount)
Date: Fri, 10 Feb 2012 20:30:51 +0100
Message-ID: <20120210203051.Horde.q5KnHsL8999PNXBrH5AlxdA@webmail.df.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I used to have arch linux running on 1 btrfs partition (sda1, incl. /boot).
When switching to 3.2.5 recently the system fails to boot:

(after udevd)
/etc/rc.sysinit: line 15: 117 Bus error  mountpoint -q /proc
and so on, no idea.

It used to boot with 3.2.4, but

1) I obviously had some corruption in the tree, when I tried to delete a
certain file I hit e.g. "kernel BUG at fs/btrfs/extent-tree.c" message.

2) Even while running 3.2.4 I was unable to mount the partition from a
parallel gentoo or live USB install and I still am:

# mount /dev/sda1 /mnt/arch/
mount: /dev/sda1: can't read superblock

The strange thing is: when trying to boot from the partition the boot  
loader (syslinux) is
obviously still able load the kernel from that partition.

Tried btrfs-zero-log and some deperate other things. Result: I can now  
actually
execute btrfsck which previously used to fail:

# btrfsck /dev/sda1
Extent back ref already exists for 9872289792 parent 0 root 5
leaf parent key incorrect 9872289792
bad block 9872289792
ref mismatch on [9872289792 4096] extent item 1, found 2
Incorrect global backref count on 9872289792 found 1 wanted 2
backpointer mismatch on [9872289792 4096]
owner ref check failed [9872289792 4096]
ref mismatch on [9889067008 4096] extent item 1, found 0
Backref 9889067008 root 5 not referenced
Incorrect global backref count on 9889067008 found 1 wanted 0
backpointer mismatch on [9889067008 4096]
owner ref check failed [9889067008 4096]
ref mismatch on [37163102208 65536] extent item 1, found 0
Incorrect local backref count on 37163102208 root 5 owner 3360937  
offset 0 found 0 wanted 1
backpointer mismatch on [37163102208 65536]
owner ref check failed [37163102208 65536]
ref mismatch on [37163814912 36864] extent item 0, found 1
Backref 37163814912 root 5 owner 3360939 offset 0 num_refs 0 not found  
in extent tree
Incorrect local backref count on 37163814912 root 5 owner 3360939  
offset 0 found 1 wanted 0
backpointer mismatch on [37163814912 36864]
found 15491117056 bytes used err is 1
total csum bytes: 14764500
total tree bytes: 366956544
total fs tree bytes: 317714432
btree space waste bytes: 90628933
file data blocks allocated: 16182484992
  referenced 17813028864
Btrfs Btrfs v0.19-dirty

However this doesn't seem to fix anything. Can run it over and over  
again with same output.

btrfs-show does recognize the partition...

# btrfs-show /dev/sda1
**
** WARNING: this program is considered deprecated
** Please consider to switch to the btrfs utility
**
failed to read /dev/sde: No medium found
Label: none  uuid: 9e9886fc-3e60-4c59-a246-727662769ee2
         Total devices 1 FS bytes used 14.43GB
         devid    1 size 37.27GB used 34.52GB path /dev/sda1

Btrfs Btrfs v0.19-dirty


...while device scan does not:

# btrfs device scan /dev/sda1
Scanning for Btrfs filesystems in '/dev/sda1'


Finally dmesg after a mount attempt:

[88124.390308] Btrfs detected SSD devices, enabling SSD mode
[88124.392354] parent transid verify failed on 9872289792 wanted  
152893 found 120351
[88124.392357] parent transid verify failed on 9872289792 wanted  
152893 found 120351
[88124.392359] parent transid verify failed on 9872289792 wanted  
152893 found 120351
[88124.392360] parent transid verify failed on 9872289792 wanted  
152893 found 120351
[88124.392361] parent transid verify failed on 9872289792 wanted  
152893 found 120351
[88124.392370] BTRFS: inode 3392566 still on the orphan list
[88124.392372] btrfs: could not do orphan cleanup -5
[88124.688187] btrfs: open_ctree failed


Any chance to rescue the data?

thx
tcn

