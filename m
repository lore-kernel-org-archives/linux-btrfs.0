From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: Music-files suddenly not recognized anymore, empty files - Btrfschk
	reports errors
Date: Sat, 12 Jun 2010 22:40:53 +0200
Message-ID: <AANLkTim4wf0p5KP29Usd8cp6YOQzR3oiqpPTFl1NoVTP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Recently Amarok started to reject some of music files.
Some files seem to be simply corrupted (mplayer is still able to play
them), other have zero length.

Btrfsck reports:
root 5 inode 1371 errors 400
found 42498768896 bytes used err is 1
total csum bytes: 41015664
total tree bytes: 498728960
total fs tree bytes: 406466560
btree space waste bytes: 110792472
file data blocks allocated: 271306133504
 referenced 46886879232
Btrfs Btrfs v0.19


Anything I can do to repair those errors?

Thank you in advance, Clemens
