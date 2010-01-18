From: "Ronny H. Kavli" <ronny.kavli@gmail.com>
Subject: Inconsistent reports after disk-error.
Date: Mon, 18 Jan 2010 23:45:40 +0100
Message-ID: <1263854740.6829.20.camel@bollox.stuffit.loc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been running btrfs on some disks with Ubuntu kernel 2.6.31 for a
while now. Recently I had a bad USB-cable to one of those disks which
left the btrfs filesystem in a somewhat sad state. Fair enough.

What worries me is what btrfsck reports back to me during two successive
runs:
root@bollox:/home/kavli# btrfsck /dev/mapper/vg3-vbox1 
checksum verify failed on 142837022720 wanted 5D18D333 found 95085E8
checksum verify failed on 142837022720 wanted 5D18D333 found 95085E8
checksum verify failed on 142837022720 wanted 5D18D333 found 95085E8
btrfsck: disk-io.c:741: open_ctree_fd: Assertion `!(!tree_root->node)'
failed.
Aborted
root@bollox:/home/kavli# btrfsck /dev/mapper/vg3-vbox1 
checksum verify failed on 142837022720 wanted 5D18D333 found 81D15E8
checksum verify failed on 142837022720 wanted 5D18D333 found 81D15E8
checksum verify failed on 142837022720 wanted 5D18D333 found 81D15E8
btrfsck: disk-io.c:741: open_ctree_fd: Assertion `!(!tree_root->node)'
failed.
Aborted

I'd expected the checksums for the two separate runs to be equal.

This is a vanilla filesystem that resides on one physical disk:
root@bollox:/home/kavli# btrfs-show /dev/mapper/vg3-vbox1 
failed to read /dev/sr0
Label: none  uuid: 08078f2f-22e0-4b79-8367-66528791afff
        Total devices 1 FS bytes used 106.79GB
        devid    1 size 232.88GB used 218.04GB
path /dev/mapper/vg3-vbox1

Btrfs Btrfs v0.19

I've googled a bit and found one case with a similar problem in a raid1
setup (I guess incorrectly stated as raid0):
 http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03429.html

There were no followups beyond that point which stated the cause of this
behaviour.

BTW: Is there any hope of recovery of this filesystem, or is it just a
new mkfs that can help?

Regards,

 -- RHK

