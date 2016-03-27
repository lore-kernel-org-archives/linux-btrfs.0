Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60574 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbcC0MPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 08:15:37 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue (was: Again, no space left on device while rebalancing and recipe doesnt work)
Date: Sun, 27 Mar 2016 14:15:34 +0200
Message-ID: <4486208.AzVcMjpYiB@merkaba>
In-Reply-To: <20160315070722.GK2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de> <CAPmG0jYfEnvLEHskv8uy+FjnRtv4yY8HA7bqMqZ8ScqVuAHatA@mail.gmail.com> <20160315070722.GK2334@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Dienstag, 15. März 2016 08:07:22 CEST Marc Haber wrote:
> On Mon, Mar 14, 2016 at 09:39:51PM +0100, Henk Slager wrote:
> > >> BTW, I restored and mounted your 20160307-fanbtr-image:
> > >> 
> > >> [266169.207952] BTRFS: device label fanbtr devid 1 transid 22215732
> > >> /dev/loop0 [266203.734804] BTRFS info (device loop0): disk space
> > >> caching is enabled [266203.734806] BTRFS: has skinny extents
> > >> [266204.022175] BTRFS: checking UUID tree
> > >> [266239.407249] attempt to access beyond end of device
> > >> [266239.407252] loop0: rw=1073, want=715202688, limit=705760000
> > >> [266239.407254] BTRFS error (device loop0): bdev /dev/loop0 errs: wr
> > >> 1, rd 0, flush 0, corrupt 0, gen 0
> > >> [266239.407272] attempt to access beyond end of device
> > >> .. and 16 more
> > >> 
> > >> As a quick fix/workaround, I truncated the image to 1T
> > > 
> > > The original fs was 417 GiB in size. What size does the image claim?
> > 
> > ls -alFh  of the restored image showed 337G I remember.
> > btrfs fi us showed also a number over 400G, I don't have the
> > files/loopdev anymore.
> 
> sounds legit.
> 
> > It could some side effect of btrfs-image, I only have used it for
> > multi-device, where dev id's are ignore, but total image size did not
> > lead to problems.
> 
> The original "ofanbtr" seems to have a problem, since btrfs check
> 
> /media/tempdisk says:
> > > [10/509]mh@fan:~$ sudo btrfs check /media/tempdisk/
> > > Superblock bytenr is larger than device size
> > > Couldn't open file system
> > > [11/509]mh@fan:~$
> > > 
> > > Can this be fixed?
> > 
> > What I would do in order to fix it, is resize the fs to let's say
> > 190GiB. That should write correct values to the superblocks I /hope/.
> > And then resize back to max.
> 
> It doesn't:
> [20/518]mh@fan:~$ sudo btrfs filesystem resize 300G /media/tempdisk/
> Resize '/media/tempdisk/' of '300G'
> [22/520]mh@fan:~$ sudo btrfs check /media/tempdisk/
> Superblock bytenr is larger than device size
> Couldn't open file system
> [23/521]mh@fan:~$ df -h

Are you trying the check on the *mounted* filesystem? "media/tempdisk" appears 
to be a mount point, not a device file.

Unmount it and use the / one device file of the filesystem to check.

Thanks,
-- 
Martin
