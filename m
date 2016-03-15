Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:38108 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbcCOHHY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 03:07:24 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afj4d-0000Oo-1j
	for linux-btrfs@vger.kernel.org; Tue, 15 Mar 2016 08:07:23 +0100
Date: Tue, 15 Mar 2016 08:07:22 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Message-ID: <20160315070722.GK2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <20160314120703.GD2334@torres.zugschlus.de>
 <CAPmG0jbwDjf6L1-9VPCwwzqj44Th9ZHaGVcY-PhoQF=eHo5hnA@mail.gmail.com>
 <20160314200546.GG2334@torres.zugschlus.de>
 <CAPmG0jYfEnvLEHskv8uy+FjnRtv4yY8HA7bqMqZ8ScqVuAHatA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPmG0jYfEnvLEHskv8uy+FjnRtv4yY8HA7bqMqZ8ScqVuAHatA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 09:39:51PM +0100, Henk Slager wrote:
> >> BTW, I restored and mounted your 20160307-fanbtr-image:
> >>
> >> [266169.207952] BTRFS: device label fanbtr devid 1 transid 22215732 /dev/loop0
> >> [266203.734804] BTRFS info (device loop0): disk space caching is enabled
> >> [266203.734806] BTRFS: has skinny extents
> >> [266204.022175] BTRFS: checking UUID tree
> >> [266239.407249] attempt to access beyond end of device
> >> [266239.407252] loop0: rw=1073, want=715202688, limit=705760000
> >> [266239.407254] BTRFS error (device loop0): bdev /dev/loop0 errs: wr
> >> 1, rd 0, flush 0, corrupt 0, gen 0
> >> [266239.407272] attempt to access beyond end of device
> >> .. and 16 more
> >>
> >> As a quick fix/workaround, I truncated the image to 1T
> >
> > The original fs was 417 GiB in size. What size does the image claim?
> 
> ls -alFh  of the restored image showed 337G I remember.
> btrfs fi us showed also a number over 400G, I don't have the
> files/loopdev anymore.

sounds legit.

> It could some side effect of btrfs-image, I only have used it for
> multi-device, where dev id's are ignore, but total image size did not
> lead to problems.

The original "ofanbtr" seems to have a problem, since btrfs check
/media/tempdisk says:

> > [10/509]mh@fan:~$ sudo btrfs check /media/tempdisk/
> > Superblock bytenr is larger than device size
> > Couldn't open file system
> > [11/509]mh@fan:~$
> >
> > Can this be fixed?
> 
> What I would do in order to fix it, is resize the fs to let's say
> 190GiB. That should write correct values to the superblocks I /hope/.
> And then resize back to max.

It doesn't:
[20/518]mh@fan:~$ sudo btrfs filesystem resize 300G /media/tempdisk/
Resize '/media/tempdisk/' of '300G'
[22/520]mh@fan:~$ sudo btrfs check /media/tempdisk/
Superblock bytenr is larger than device size
Couldn't open file system
[23/521]mh@fan:~$ df -h

> Maybe btrfs check --repair can also fix it, but before doing --repair
> or other actions, I would see what else besides btrfs could be wrong,
> see also suggestion of Holger.

Like putting the filesystem on an unencrypted medium? Sorry, no,
private data, paranoia.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
