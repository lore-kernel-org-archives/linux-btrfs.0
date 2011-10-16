From: dima <dolenin@parallels.com>
Subject: unresolved ref root error
Date: Sun, 16 Oct 2011 01:37:12 +0000 (UTC)
Message-ID: <loom.20111016T032429-296@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On a newly created filesystem with btrfs-progs-git-20111009 and the 3.1.0-rc8
kernel I am getting the following error when doing btrfsck after main OS
installation

fs tree 256 refs 2 
        unresolved ref root 256 dir 256 index 2 namelen 8 name __active error 600
found 4215058432 bytes used err is 1
total csum bytes: 3962760
total tree bytes: 157192192
total fs tree bytes: 146976768
btree space waste bytes: 45236856
file data blocks allocated: 4123439104
 referenced 4056010752
Btrfs v0.19-35-g1b444cd-dirty

256 is the subvolume for /
[root@yukikaze ~]# btrfs subvol list /
ID 256 top level 5 path __active
ID 257 top level 5 path __home

Should I be concerned with this error?

I saw a similar question here
http://comments.gmane.org/gmane.comp.file-systems.btrfs/12455
but no hints were provided for the reason of the error.

Any info is appreciated.
thanks
~dima

