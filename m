From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Kernel BUG on mounting BtrFS / after reboot
Date: Tue, 23 Feb 2010 08:30:56 +0000 (UTC)
Message-ID: <loom.20100223T092903-542@post.gmane.org>
References: <loom.20100212T220341-877@post.gmane.org> <20100217141813.GH29430@think> <loom.20100218T013258-629@post.gmane.org> <20100218150238.GL10559@think> <loom.20100218T183230-637@post.gmane.org> <20100218204843.GW10559@think> <loom.20100218T215310-779@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Alex Elsayed <eternaleye <at> gmail.com> writes:

> 
> Chris Mason <chris.mason <at> oracle.com> writes:
> > I think the btrfsck output is missing.  It sounds like we'll survive if
> > we just skip this part of the log replay.  I'll cook a patch based on
> > the btrfsck output.
> 
> It was inline in my first message, immediately after the BUG trace.

Any update? Including btrfsck output here, in case it got lost:

Arkadios ~ # btrfsck /dev/Arkadios/Root
root 5 inode 1525410 errors 400
root 5 inode 5364659 errors 2
root 5 inode 5364663 errors 2
root 5 inode 5364668 errors 2
root 5 inode 5364677 errors 2
root 5 inode 6123691 errors 400
root 5 inode 6239775 errors 2
root 5 inode 6239779 errors 2
root 5 inode 6239789 errors 2
root 5 inode 6239971 errors 2
root 5 inode 6269030 errors 2
root 5 inode 6269034 errors 2
root 5 inode 6269667 errors 2
root 5 inode 6270025 errors 2
root 5 inode 6423082 errors 400
root 5 inode 6424288 errors 2
root 5 inode 6424328 errors 2
root 5 inode 6424506 errors 2
root 5 inode 6424510 errors 2
root 5 inode 7314036 errors 400
root 5 inode 7538573 errors 400
root 5 inode 7541407 errors 400
root 5 inode 7541533 errors 400
root 5 inode 7954626 errors 400
root 5 inode 7955659 errors 2
root 5 inode 7955723 errors 2
root 5 inode 7955727 errors 2
root 5 inode 7957158 errors 2
root 5 inode 8076299 errors 2
root 5 inode 8138735 errors 400
root 5 inode 8346718 errors 400
root 5 inode 8378669 errors 400
root 5 inode 8504794 errors 400
root 5 inode 8628757 errors 400
root 5 inode 8628952 errors 2
root 5 inode 8628966 errors 2
root 5 inode 8628970 errors 2
root 5 inode 8629003 errors 2
root 5 inode 8633819 errors 2
root 5 inode 8693549 errors 400
root 5 inode 9014871 errors 2
root 5 inode 9014938 errors 2
root 5 inode 9014942 errors 2
root 5 inode 9014946 errors 2
found 449101881344 bytes used err is 1
total csum bytes: 433187792
total tree bytes: 5517582336
total fs tree bytes: 4585156608
btree space waste bytes: 1419008115
file data blocks allocated: 1040877457408
 referenced 439746732032
Btrfs Btrfs v0.19


