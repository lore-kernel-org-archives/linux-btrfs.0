From: Chris Mason <chris.mason@oracle.com>
Subject: Re: resize ate my root node
Date: Thu, 10 Mar 2011 09:04:04 -0500
Message-ID: <1299765769-sup-265@think>
References: <20110307174820.5100.qmail@stuge.se> <1299620014-sup-698@think> <20110310062333.13172.qmail@stuge.se> <1299762537-sup-5020@think> <1299763154-sup-2900@think> <20110310134509.13787.qmail@stuge.se>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Peter Stuge <peter@stuge.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110310134509.13787.qmail@stuge.se>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Peter Stuge's message of 2011-03-10 08:45:09 -0500:
> Chris Mason wrote:
> > Which tool and which version of the tool did you use to delete the
> > partition?
> 
> fdisk from util-linux-2.18

Straight from util-linux, or with distro patches?

> 
> The non-working partition was deleted and the current one created
> with fdisk from util-linux-2.14.2.
> 
> > > It's a 64GB CF card with two partitions; one 40MB ext2 and "the rest"
> > > is btrfs. This is the current fdisk output:
> > 
> > Ok, going back to your original email, the block you're failing on
> > is probably right in the middle of the drive.
> 
> Right.
> 
> > We can't be sure without looking at the mapping tree (which we
> > don't have),
> 
> Could we guess at where it was put?

Until you do something funky like balance the drive, there's a 1:1
mapping.  The easy way to guess is to strace btrfsck and see where it
read.

> 
> > > I say current, because by now I have changed the sdb2 partition
> > > twice.
> > 
> > Have you ever changed the start of the partition?
> 
> No.
> 
> > If the start had changed the superblock should be in the wrong
> > place, so the mount wouldn't have gotten this far.
> 
> Right.
> 
> > > In any case changing the partition table shouldn't affect the
> > > filesystem, right? Also, I changed the partition with the filesystem
> > > mounted, so the kernel did not start using the new partition table.
> > 
> > I'd have to repeat the test on this flash card to say for sure.
> > Deleting then recreating the partition with the FS mounted isn't
> > very high up on the list of things that get tested often, so my
> > guess is that's where the problem is.
> 
> As I understand it, fdisk writes the new partition table to disk, and
> asks the kernel to re-read it from there. That ioctl failed, I expect
> because the filesystem was mounted.
> 
> > Right, we've got a block full with zeros where they don't belong. 
> > Can you run dump the block contents with gdb please?
> 
> Will do!
> 
> > Ok, we talked about power offs and barriers in a different thread,
> > but I didn't realize you were on a CF device.  I'd want to do some
> > tests on this device to see how well it really reacted in power
> > offs, but lets do that after we pull your data some where safer.
> 
> I'm of course happy to help test anything!

Great, thanks.

-chris
