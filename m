From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Building a RAID post-mkfs?
Date: Mon, 26 Oct 2009 18:35:00 +0900
Message-ID: <20091026093500.GE5564@think>
References: <m3skdjusvx.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3skdjusvx.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 16, 2009 at 01:54:10PM -0400, Chris Ball wrote:
> Hi,
> 
> I installed btrfs to one disk using the Fedora 12 installer; it
> doesn't allow any configuration of the mkfs command by the user,
> so it wasn't possible to mkfs with more than one disk.
> 
> I'd like to add a second disk, with either RAID0 or RAID1 between
> the two -- the equivalent of "mkfs.btrfs -m raid0/1 -d raid0/1
> /dev/sda /dev/sdb".  Is it possible to create this non-destructively
> now?  If not, should it be?  What would the implementation look like?

It's not very complex, you can take a look at how we upgrade from
single spindle dup to RAID1 for metadata when a second disk is added.
Basically once we have a block group with the new type we're able to
force new allocations to the new raid level.  btrfs-vol -b does the
rest.

-chris

