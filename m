Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:51495 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3JVIIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 04:08:09 -0400
Received: by mail-vc0-f169.google.com with SMTP id hu8so1124379vcb.28
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 01:08:08 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Oct 2013 10:08:08 +0200
Message-ID: <CAFZZw9bYsJCNyeQQfcJP1rRB5SGBXuiswA8jF1bUycvZPhQLqg@mail.gmail.com>
Subject: Unable to mount partition
From: Geert Van Damme <geert.vandamme@darling.be>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I use btrfs for my /home drive. It's a separate drive with just a
single partition.
I upgraded to ubuntu 13.10 (beta) a few weeks ago, without any real
trouble. But I did have too many issues (not with the drive or btrfs,
though) so I decided to do a fresh install.
The new install failed a few times, so I made another startup usb
drive with another program and that one worked fine.
However, my /dev/sda1 was now recognised as an ext4 instea of btrfs.
It also had some files on it (a default ubuntu /home and a
/lost+found)
I can't mount the drive as type=btrfs

sudo mount -t btrfs /dev/sda1 /mnt/btrfs/
mount: wrong fs type, bad option, bad superblock on /dev/sda1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so


sudo dmesg | grep btrfs
[  187.604312] btrfs[2771]: segfault at ac ip 000000000042b93b sp
00007fff918332c8 error 4 in btrfs[400000+4d000]
[  196.574435] btrfs[2777]: segfault at ac ip 000000000042b93b sp
00007fff0f04d8a8 error 4 in btrfs[400000+4d000]
[  241.698698] btrfs[2800]: segfault at ac ip 000000000042b93b sp
00007fffb1d02b08 error 4 in btrfs[400000+4d000]



Everything I tried crashed, except for 'show'


sudo btrfs fi show
failed to open /dev/sr0: No medium found
Label: none  uuid: 183af3e0-2572-4497-9705-1d27a6657f7b
    Total devices 1 FS bytes used 746.23GB
    devid    1 size 2.73TB used 2.73TB path /dev/sda1

Btrfs v0.20-rc1


which makes it more or less reassuring that the data is still there,
but I can't seem to find a way to get it :-(
At the moment I restored a backup, so I'm fine more or less, but it
would be nice if I could fix this.


sudo btrfs fi df /dev/sda1
ERROR: couldn't get space info on '/dev/sda1' - Inappropriate ioctl for device


sudo btrfsck /dev/sda1
Check tree block failed, want=21000192, have=0
Check tree block failed, want=21000192, have=0
Check tree block failed, want=21000192, have=0
Check tree block failed, want=21000192, have=0
Check tree block failed, want=21000192, have=0
read block failed check_tree_block
Couldn't read chunk root


sudo btrfs restore -i -v  /dev/sda1 /home/geert/recover
Check tree block failed, want=21000192, have=0
Check tree block failed, want=21000192, have=0
Check tree block failed, want=21000192, have=0
Check tree block failed, want=21000192, have=0
Check tree block failed, want=21000192, have=0
read block failed check_tree_block
Couldn't read chunk root
Could not open root, trying backup super
Check tree block failed, want=21000192, have=0
Check tree block failed, want=21000192, have=0
Check tree block failed, want=21000192, have=0
Check tree block failed, want=21000192, have=0
Check tree block failed, want=21000192, have=0
read block failed check_tree_block
Couldn't read chunk root
Could not open root, trying backup super
No valid Btrfs found on /dev/sda1
Could not open root, trying backup super


btrfs chunk-recover   ran for a few moments, but then failed with

btrfs: cmds-chunk.c:125: process_extent_buffer: Assertion
`!(exists->nmirrors >=2)´ failed.

It looks like the chunk-recover command isn't any more available in
the latest btrfs-tools package I installed  (from
https://launchpad.net/~samuel-maftoul/+archive/btrfs-tools/+build/4461274).

It did work with the default btrfs from ubuntu 13.10 though, but
showed the error above

It looks a lot similar to
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg27390.html
and
http://www.spinics.net/lists/linux-btrfs/msg26274.html

Is there anything else I could try?
