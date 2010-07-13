From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Disk space usage displayed incorrectly?
Date: Mon, 12 Jul 2010 21:16:50 -0400
Message-ID: <20100713011650.GN563@think>
References: <AANLkTil1adG5cmYxbjvzv7OygH9q12SyA2HL8bOWtuxp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: jck <jck@archlinux.us>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTil1adG5cmYxbjvzv7OygH9q12SyA2HL8bOWtuxp@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 10, 2010 at 07:22:26AM +0530, jck wrote:
> Hello,
> when i check diskspace usage of a btrfs partition using df i get the
> wrong free space, this is expected i think.

We do try to take the raid levels into account during df, but only for
the space that is already allocated.

> However even when i use 'btrfs filesystem df' I get wrong freespace:
> Data: total=123.58GB, used=87.31GB
> Metadata: total=61.00GB, used=396.29MB
> System: total=32.00MB, used=16.00KB
> 
> Does this mean that after the 123 GB of 'Data' fills up I wont be able
> to add more stuff to the partition?
> I'm using btrfs-progs-git (jul 10)

This does reflect the space that is allocated, but the drive itself may
have more free space.  btrfs filesystem show will give you a few more
details.

Basically btrfs allocates from the drive in chunks of about 1GB and then
puts the file data or metadata into those chunks.  So if you do a mkfs
and then create one file, you might have 1TB of space on the drive that
hasn't been allocated yet.

-chris

