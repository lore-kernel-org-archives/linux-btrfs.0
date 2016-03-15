Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:39298 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbcCONYc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 09:24:32 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afoxa-0002DN-GS
	for linux-btrfs@vger.kernel.org; Tue, 15 Mar 2016 14:24:30 +0100
Date: Tue, 15 Mar 2016 14:24:30 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Message-ID: <20160315132430.GN2334@torres.zugschlus.de>
References: <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <20160314120703.GD2334@torres.zugschlus.de>
 <CAPmG0jbwDjf6L1-9VPCwwzqj44Th9ZHaGVcY-PhoQF=eHo5hnA@mail.gmail.com>
 <20160314200546.GG2334@torres.zugschlus.de>
 <CAPmG0jYfEnvLEHskv8uy+FjnRtv4yY8HA7bqMqZ8ScqVuAHatA@mail.gmail.com>
 <CAJCQCtQHZsvQyAfWO4HGY7Jr+PGdW5L=LUTqM+5E=ys0+Ypzqw@mail.gmail.com>
 <CAPmG0jaf7TaU2Nt3ULRm3651ByiwW-2PdYart318ceLDN7JqbQ@mail.gmail.com>
 <20160315071611.GL2334@torres.zugschlus.de>
 <CAPmG0jb1QMCqG9HdouzTntgwzKbcLmZtNmRSAN876x5-kT9Chg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPmG0jb1QMCqG9HdouzTntgwzKbcLmZtNmRSAN876x5-kT9Chg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2016 at 01:15:33PM +0100, Henk Slager wrote:
> On Tue, Mar 15, 2016 at 8:16 AM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> > On Tue, Mar 15, 2016 at 12:22:00AM +0100, Henk Slager wrote:
> >> The other question is: What is mounted on /media/tempdisk/  ?
> >
> > The "old" btrfs filesystem "ofanbtr", formerly 417 GB in size, now
> > resized to 300 GB. Does it need to be umounted to be checked?
> 
> Yes, that's the whole point
> 
> >> At least I think a check of the current 200GiB fs is needed. As it is
> >> a rootfs and encrypted, some work is needed to make that happen.
> >
> > You suggested a btrfs check after looking at the image of "ofanbtr".
> > Do you want me to check the new "fanbtr" also?
> 
> I was not sure if 'ofanbtr' is an image created by btrfs-image or a
> extra dd created image you might have locally. Both 'ofanbtr' and
> 'fanbtr' have the same balance issue, but 'fanbtr' is created with
> newer and known kernel+tools version I assume, so that's why the
> suggestion.

ofanbtr is the old btrfs, on /dev/mapper/ofanbtr:
Label: 'ofanbtr'  uuid: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
        Total devices 1 FS bytes used 80.63GiB
        devid    1 size 300.00GiB used 122.06GiB path /dev/mapper/ofanbtr
it was created as 'fanbtr' in September, 300 GiB in Size, then - in
February, I think, resized to 417 MiB to make room for more data and
for balancing, used until March 7, and then renamed to ofanbtr with
lvrename and btrfs fi label. It was then imaged, and then resized back
to 300 GiB in the hope that this will fix the size issue.

fanbtr is the new btrfs, on /dev/mapper/fanbtr:
Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
        Total devices 1 FS bytes used 82.45GiB
        devid    1 size 200.00GiB used 113.03GiB path /dev/mapper/fanbtr
it was created on march 7, had the data from ofanbtr cp'ed over, and
is being used as the active filesystem since then. It is smaller
because I don't have much more room on the SSD.

Both do have the same balance issue, yes.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
