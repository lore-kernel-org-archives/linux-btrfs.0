From: Chris Ball <cjb@laptop.org>
Subject: Re: What to do about subvolumes?
Date: Thu, 02 Dec 2010 23:25:01 -0500
Message-ID: <m339qfo542.fsf@pullcord.laptop.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> (Josef Bacik's
	message of "Wed, 1 Dec 2010 09:21:36 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

   > 1) Scrap the 256 inode number thing.  Instead we'll just put a
   > flag in the inode to say "Hey, I'm a subvolume" and then we can
   > do all of the appropriate magic that way.  This unfortunately
   > will be an incompatible format change, but the sooner we get this
   > adressed the easier it will be in the long run.  Obviously when I
   > say format change I mean via the incompat bits we have, so old
   > fs's won't be broken and such.

Sorry if I've missed this elsewhere in the thread -- will we still
have an efficient operation for enumerating subvolumes and snapshots,
and how will that work?  We're going to want tools like plymouth and
grub to be able to list all snapshots without running a large scan.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
