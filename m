From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
Date: Thu, 22 Jul 2010 20:07:23 +0200
Message-ID: <201007222007.24574.johannes.hirte@fem.tu-ilmenau.de>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de> <201007152014.52924.johannes.hirte@fem.tu-ilmenau.de> <4C44066A.3080701@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Dave Chinner <david@fromorbit.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	zheng.yan@oracle.com, Jens Axboe <axboe@kernel.dk>,
	linux-fsdevel@vger.kernel.org
To: miaox@cn.fujitsu.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C44066A.3080701@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag 19 Juli 2010, 10:01:46 schrieb Miao Xie:
> On Thu, 15 Jul 2010 20:14:51 +0200, Johannes Hirte wrote:
> > Am Donnerstag 15 Juli 2010, 02:11:04 schrieb Dave Chinner:
> >> On Wed, Jul 14, 2010 at 05:25:23PM +0200, Johannes Hirte wrote:
> >>> Am Donnerstag 08 Juli 2010, 16:31:09 schrieb Chris Mason:
> >>> I'm not sure if btrfs is to blame for this error. After the errors I
> >>> switched to XFS on this system and got now this error:
> >>> 
> >>> ls -l .kde4/share/apps/akregator/data/
> >>> ls: cannot access .kde4/share/apps/akregator/data/feeds.opml: Structure
> >>> needs cleaning
> >>> total 4
> >>> ?????????? ? ?    ?        ?            ? feeds.opml
> >> 
> >> What is the error reported in dmesg when the XFS filesytem shuts down?
> > 
> > Nothing. I double checked the logs. There are only the messages when
> > mounting the filesystem. No other errors are reported than the
> > inaccessible file and the output from xfs_check.
> 
> Is there anything wrong with your disks or memory?
> Sometimes the bad memory can break the filesystem. I have met this kind of
> problem some time ago.

I don't think that's the case. I've checked the RAM with memtest86+ and got no 
errors. I got the errors with two different disks, the first one with btrfs the 
second one now with XFS. Before changing to the second disk, I've run 
badblocks on it to be sure it has no errors.

> 
> If there is no problem with your disk and memory, Could you tell us the
> parameter of mkfs.btrfs and mount?

I'm not sure what parameters I've used for mkbtrfs. It was either none ore '-m 
single'. mount parameters are only noatime. Some time ago I've played a little 
with max_inline.

On the actual disk with XFS I got now some more errors on my root-fs. Similar 
error on one file:

ls: cannot access /var/tmp/portage/app-
office/krita-2.2.1/work/krita-2.2.1/krita/image/tiles3/tests/dm_consistancy_test/dm_consistancy_test.pr: 
Invalid argument

xfs_check shows on this fs:

localhost ~ # xfs_check /dev/sda1
agi unlinked bucket 10 is 7279754 in ag 0 (inode=7279754)
agi unlinked bucket 11 is 7279755 in ag 0 (inode=7279755)
dir 91466358 entry dm_consistancy_test.pr bad inode number 1862628266
dir 91466358 size is 36, should be 35
agi unlinked bucket 48 is 11677104 in ag 2 (inode=78785968)
agi unlinked bucket 49 is 11677105 in ag 2 (inode=78785969)
agi unlinked bucket 50 is 11677106 in ag 2 (inode=78785970)
agi unlinked bucket 51 is 11677107 in ag 2 (inode=78785971)
agi unlinked bucket 52 is 11677108 in ag 2 (inode=78785972)
agi unlinked bucket 53 is 11677109 in ag 2 (inode=78785973)
agi unlinked bucket 54 is 11677110 in ag 2 (inode=78785974)
agi unlinked bucket 55 is 11677111 in ag 2 (inode=78785975)
agi unlinked bucket 58 is 11677114 in ag 2 (inode=78785978)
agi unlinked bucket 59 is 11677115 in ag 2 (inode=78785979)
agi unlinked bucket 60 is 11677116 in ag 2 (inode=78785980)
agi unlinked bucket 61 is 11677117 in ag 2 (inode=78785981)
allocated inode 7279754 has 0 link count
allocated inode 7279755 has 0 link count
disconnected inode 91466360, nlink 1
allocated inode 78785968 has 0 link count
allocated inode 78785969 has 0 link count
allocated inode 78785970 has 0 link count
allocated inode 78785971 has 0 link count
allocated inode 78785972 has 0 link count
allocated inode 78785973 has 0 link count
allocated inode 78785974 has 0 link count
allocated inode 78785975 has 0 link count
allocated inode 78785978 has 0 link count
allocated inode 78785979 has 0 link count
allocated inode 78785980 has 0 link count
allocated inode 78785981 has 0 link count

And again I don't find any related message in dmesg.

regards,
  Johannes
