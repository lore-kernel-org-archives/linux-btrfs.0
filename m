From: Alex <alex@bpmit.com>
Subject: SELinux inode size gotcha in btrfs.
Date: Mon, 27 Feb 2012 22:18:55 +0000 (UTC)
Message-ID: <loom.20120227T210703-631@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,


I've come across the 'gotcha' in XFS where the inode size defaults to 256 [1]
whereas for SELinux the attributes play better when you initialise it at
creation to 512.

>From my reading of the btrfs specs [2] it doesn't look like you'll get caught
with that as the inodes "will not contain embedded file data or extended
attribute data. These things are stored in other item types."

Have I read that right? I've seen xattr bugs patches etc but nothing that would
hit the SE Linux domain.




[1]
http://www.gentoo.org/proj/en/hardened/selinux/selinux-handbook.xml?part=2&chap=1
[2] http://btrfs.ipv5.de/index.php?title=Btrfs_design#Inodes

