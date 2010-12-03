From: Josef Bacik <josef@redhat.com>
Subject: Re: What to do about subvolumes?
Date: Fri, 3 Dec 2010 09:00:20 -0500
Message-ID: <20101203140019.GD8805@dhcp231-156.rdu.redhat.com>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <m339qfo542.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m339qfo542.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 02, 2010 at 11:25:01PM -0500, Chris Ball wrote:
> Hi Josef,
> 
>    > 1) Scrap the 256 inode number thing.  Instead we'll just put a
>    > flag in the inode to say "Hey, I'm a subvolume" and then we can
>    > do all of the appropriate magic that way.  This unfortunately
>    > will be an incompatible format change, but the sooner we get this
>    > adressed the easier it will be in the long run.  Obviously when I
>    > say format change I mean via the incompat bits we have, so old
>    > fs's won't be broken and such.
> 
> Sorry if I've missed this elsewhere in the thread -- will we still
> have an efficient operation for enumerating subvolumes and snapshots,
> and how will that work?  We're going to want tools like plymouth and
> grub to be able to list all snapshots without running a large scan.
>

Yeah the idea is we want to fix the problems with the design without breaking
anything that currently works.  So all the changes I want to make are going to
be invisible for the user.  Thanks,

Josef 
