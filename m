Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23280 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965050Ab3BMWW0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 17:22:26 -0500
Date: Thu, 14 Feb 2013 09:17:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Karel Zak <kzak@redhat.com>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, xfs@oss.sgi.com,
        sandeen@redhat.com, Zach Brown <zabrown@redhat.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
Message-ID: <20130213221720.GH26694@dastard>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
 <20130212202753.GC26694@dastard>
 <20130213080154.GC18597@x2.net.home>
 <alpine.LFD.2.00.1302131127070.2315@(none)>
 <20130213121655.GA7799@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130213121655.GA7799@x2.net.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 13, 2013 at 01:16:55PM +0100, Karel Zak wrote:
> On Wed, Feb 13, 2013 at 11:41:08AM +0100, Lukáš Czerner wrote:
> > However
> > 
> > mkfs.btrfs /dev/sda
> > mkfs.ext4 -F /dev/sda
> > 
> > works well, however I am not sure why that is. Is that some kind of
> > mount(8) magic ?
> 
>  This is bug in libmount. Fixed in upstream tree. The libmount in some
>  cases ignores the ambivalent probing result from libblkid and tries 
>  stuff from /etc/filesystems (where is for example ext4).
> 
> > So I think that liblkid _and_ btrfs tools has to be fixed not to treat
> > backup superblocks as primary!
> 
>  The problem with additional btrfs superblocks has been already reported
>  to btrfs guys:
> 
>    http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg20957.html
> 
>  and I don't see a reply "yep, this is btrfs-progs bug" :-)

Oh, it's most definitely a btrfs-progs bug. Using stale
metadata data on the block device in preference to current, primary
metadata identifying the device to belong to a different filesystem
is, well, rather unfriendly.

In the above case, mkfs.ext4 overwrites the btrfs magic block field
so that it is not zero (as it is after wipefs runs), and hence the
btrfs tools see it as a broken superblock and continue to the next
location for recovery rather than see the device as containing a
valid but foreign filesystem.

None of the filesystem tools from ext4, btrfs and XFS handle this
sort of thing consistently, even though it is their responsibility
to do so. XFS is probably the best of them, in that *some* of the
tools will refuse to run unless you provide a force flag when the
device appears to contain primary identifiers for a different
filesystem. e.g. mkfs.xfs won't overwrite existing filesystems
without a force flag, but mkfs.ext4 and mkfs.btrfs will:

$ sudo mkfs.xfs /dev/vdb
mkfs.xfs: /dev/vdb appears to contain an existing filesystem (btrfs).
mkfs.xfs: Use the -f option to force overwrite.
$ sudo mkfs.xfs -f /dev/vdb
meta-data=/dev/vdb               isize=256    agcount=4, agsize=720896 blks
         =                       sectsz=512   attr=2, projid32bit=0
         =                       crc=0    
data     =                       bsize=4096   blocks=2883584, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo mkfs.xfs /dev/vdb
mkfs.xfs: /dev/vdb appears to contain an existing filesystem (xfs).
mkfs.xfs: Use the -f option to force overwrite.
$ sudo mkfs.btrfs /dev/vdb

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vdb
        nodesize 4096 leafsize 4096 sectorsize 4096 size 11.00GB
Btrfs Btrfs v0.19
$ sudo mkfs.ext4 /dev/vdb
mke2fs 1.42.5 (29-Jul-2012)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
720896 inodes, 2883584 blocks
144179 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=2952790016
88 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done 

$ sudo mkfs.xfs /dev/vdb
mkfs.xfs: /dev/vdb appears to contain an existing filesystem (ext4).
mkfs.xfs: Use the -f option to force overwrite.
$

IOWs, it is the responsibility of the filesystem tools to correctly
identify the filesystem being operated on, and not to
modify/trash/recover anything unless specifically directed by the
user.  When a filesystem tool gets it wrong, then that specific tool
needs to be fixed.  i.e. it is the responsibility of filesystem
tools to behave sanely, not for the rest of the world to have to
work around the dangerous behaviour of a specific filesystems'
toolset.

And that makes it a btrfs-progs bug that needs to be fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
