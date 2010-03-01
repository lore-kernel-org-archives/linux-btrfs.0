From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: Quota Clarification
Date: Mon, 1 Mar 2010 09:23:41 -0700
Message-ID: <c5b98f841003010823k714af7bam94cabed9ed3c69cc@mail.gmail.com>
References: <c5b98f841002261951k78ad0f1cnec5450218a9ed0d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c5b98f841002261951k78ad0f1cnec5450218a9ed0d8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2010 at 8:51 PM, Robert LeBlanc <robert@leblancnet.us> wrote:
> First off, thanks for the great work on btrfs. I've been trying to
> follow the development for some time and now that Debian has
> everything in Squeeze, I've been playing around with btrfs.
>
> I would like to implement btrfs on a large file server that we are
> currently using ACLs, user and group quotas and LVM snapshots. While
> LVM is nice, it is just choking with as many snapshots as we have and
> we need more. I took part of the EXT4 file system and copied it over
> to a new partition to play with and was able to convert to btrfs
> without problems. ACLs worked just fine which is great news.
>
> I went to look at the quotas and repquota said that the mount point
> doesn't have quotas enabled. I then searched for documentation about
> quotas and it was pretty sparse. The only thing that I've found talked
> about setting a quota for a subvolume by number of blocks. When I
> toyed with ZFS, it had a similar quota system and from what I remember
> reading, the devs were getting pressured to implement a quota system
> like the previous file systems.
>
> One thing I'm not sure how it will work is grace period and soft
> quotas. It sure would be nice to have this feature with btrfs. The
> same applies to checkquota were the owner can be e-mailed. Right now
> we have one file system for home directories with user quotas and
> another file system for group space with group quotas. We take
> snapshots of these file systems and present them to the users as a
> directory which Windows interprets as a Shadow Volume copy.
>
> I thought it would be nice to have one btrfs file system and then
> create two subvolumes with appropriate user or group quotas. I would
> be able to snap the two subvolumes much like I do now. Since btrfs
> does not snapshot subvolumes when a parent is snapped, if I have to
> create a separate subvolume for each user or group I can see this
> getting very hairy to manage when we have nearly a thousand users and
> groups. Have the two subvolumes would give me great flexability to
> reallocate space quickly.
>
> Any insight would be helpful. I can't wait for btrfs to be stable, it
> got lots of great potential.
>

Another thing that I tried was to set a subvolume to a specified size,
but it changes the root and all other subvolumes to the same size. I
can understand how having subvolumes of differing sizes would be
beneficial, much like multiple logical volumes in an LVM volume group.
I fail to see the benefit of having a btrfs root fs that is less than
the disk or partition as the space can't be used for anything else. I
hope I'm just doing something wrong here.

Thanks,

Robert LeBlanc
Life Sciences & Undergraduate Education Computer Support
Brigham Young University
