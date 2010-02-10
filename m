From: Chris Ball <cjb@laptop.org>
Subject: Re: Using snapshots as quick restore point
Date: Wed, 10 Feb 2010 09:12:41 -0500
Message-ID: <m3mxzh18o6.fsf@pullcord.laptop.org>
References: <1265796562.8697.110.camel@rupert-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Robert Pankowecki <robert@cubiware.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1265796562.8697.110.camel@rupert-desktop> (Robert Pankowecki's
	message of "Wed, 10 Feb 2010 11:09:22 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > * create snapshot
   > * mount it somewhere (read-write)
   > * operate on the snapshot, change some files etc...
   > * revert changes made to the snapshot to its original state

Make two snapshots instead of one, and only modify one of them?
Because of CoW, new snapshots have very low overhead.

   > with or without unmounting it.

You would have to unmount it if it had any open files.

   > If not, is there any filesystem that can do that ?

I don't know of any filesystem that lets you discard changes to a
snapshot, but I've just described a method for doing so where you
always make a read-only -pristine version of that snapshot and have
tools that base your read-write snapshots on that.

I don't think it would be possible for any filesystem to handle
changing snapshot on a mounted filesystem with files open, so it
makes sense that it's a remount operation.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
