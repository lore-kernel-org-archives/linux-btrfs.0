From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Suggestion for sticky-compression mount setting (default mount
 options)
Date: Sat, 5 Feb 2011 13:18:46 +0100
Message-ID: <20110205131846.0000748c@unknown>
References: <1296873843.7800.36.camel@KWOLFF03>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Kirk Wolff <kirk@wolffelectronicdesign.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296873843.7800.36.camel@KWOLFF03>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I don't think that the fs is a good place to store default mountoptions.

If you want to auto mount usb devices with compression, just write a
udev rule or whatever ubuntu uses to mount usb devices.


Regards,
Felix

Am Fri, 04 Feb 2011 20:44:03 -0600
schrieb Kirk Wolff <kirk@wolffelectronicdesign.com>:

> As I've been using btrfs with an external USB drive, I wonder how to
> handle efficiently the compression setting.  When I plug a drive in to
> ubuntu, it is automatically mounted.  Its mounted without the
> compression option as its not in fstab.  I don't see it as desirable
> to install each usb drive in fstab on each computer that it may be
> used just so that compression is automatically enabled.  In
> discussion with cjb on irc, I came to realize that the compression
> setting shouldn't be filesystem-wide therefore it doesn't make sense
> to have default mount options for an entire btrfs filesystem as you
> may want compression on one subvolume and not on another.  Therefore,
> it seems to me that default mount options should be able to be
> configured for each subvolume.  If you follow this idea through, this
> means that you would need to be able to both override each of the
> default mount options from the mount command (or fstab).  For
> example, if a subvolume has its default mount option set to compress,
> you should be able to disable compression if you manually mount it
> with "-o nocompress".  If mount default mount options were able to be
> configured through btrfs for each subvolume, then for the case when
> you have a simple USB drive that you're using for backups, the
> default subvolume could have compress automatically set when its
> plugged into a PC.  Then you can use snapshots alongside the default
> subvolume to perform a type of differential backups (similar to
> rsnapshot, but using COW instead of hard links).  I can guess there
> are people out there that may want other mount options to be carried
> around with the subvolume such as disabling COW or whatever.  What
> are your thoughts on the above?  Please advise.
> 
> - Kirk
> 

