Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:36772 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbcCNUFs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 16:05:48 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afYkM-0005Fh-I2
	for linux-btrfs@vger.kernel.org; Mon, 14 Mar 2016 21:05:46 +0100
Date: Mon, 14 Mar 2016 21:05:46 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Message-ID: <20160314200546.GG2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <20160314120703.GD2334@torres.zugschlus.de>
 <CAPmG0jbwDjf6L1-9VPCwwzqj44Th9ZHaGVcY-PhoQF=eHo5hnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPmG0jbwDjf6L1-9VPCwwzqj44Th9ZHaGVcY-PhoQF=eHo5hnA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Henk,

On Mon, Mar 14, 2016 at 02:46:54PM +0100, Henk Slager wrote:
> On Mon, Mar 14, 2016 at 1:07 PM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> > Mar 14 10:23:49 fan mh: BEGIN btrfs-balance script
> > Mar 14 10:23:49 fan mh: btrfs fi df /
> > Mar 14 10:23:49 fan root: Data, single: total=79.00GiB, used=78.42GiB
> > Mar 14 10:23:49 fan root: System, single: total=32.00MiB, used=16.00KiB
> > Mar 14 10:23:49 fan root: Metadata, single: total=10.00GiB, used=2.46GiB
> > Mar 14 10:23:49 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B
> > Mar 14 10:23:49 fan mh: btrfs fi show /
> > Mar 14 10:23:49 fan root: Label: 'fanbtr'  uuid: 90f8d728-6bae-4fca-8cda-b368ba2c008e
> > Mar 14 10:23:49 fan root: #011Total devices 1 FS bytes used 80.89GiB
> > Mar 14 10:23:49 fan root: #011devid    1 size 200.00GiB used 89.03GiB path /dev/mapper/fanbtr
> > Mar 14 10:23:49 fan root:
> > Mar 14 10:23:49 fan mh: btrfs fi usage /
> > Mar 14 10:23:49 fan root: Overall:
> > Mar 14 10:23:49 fan root:     Device size:#011#011 200.00GiB
> > Mar 14 10:23:49 fan root:     Device allocated:#011#011  89.03GiB
> > Mar 14 10:23:49 fan root:     Device unallocated:#011#011 110.97GiB
> > Mar 14 10:23:49 fan root:     Device missing:#011#011     0.00B
> > Mar 14 10:23:49 fan root:     Used:#011#011#011  80.89GiB
> > Mar 14 10:23:49 fan root:     Free (estimated):#011#011 111.54GiB#011(min: 111.54GiB)
> > Mar 14 10:23:49 fan root:     Data ratio:#011#011#011      1.00
> > Mar 14 10:23:49 fan root:     Metadata ratio:#011#011      1.00
> > Mar 14 10:23:49 fan root:     Global reserve:#011#011 512.00MiB#011(used: 0.00B)
> It it looks a bit strange to me that this is already 512MiB for and fs
> of 200GiB. Just after creation (4.4 tools) it should be something like
> 16MiB. And grows when fs is used, but 512MiB... An fs created with
> older tools had 512MiB from start AFAIK

Confirmed, a new btrfs of 200 GB made on a rotating disk has 16 MiB of
global reserve. Unfortunately, I do not have history about how this
grew over time. The first btrfs fi usage I have on file was about half
a day into this fs' existence on Mar 7, after copying data on to it,
and Global reserve was already at 512 MiB.

> > Mar 14 10:51:06 fan root: BEGIN btrfs balance start -mprofiles=dup /
> 
> This probably should have been  -mprofiles=single
> So that its gets more clear where and when the enospc errors occur

Good catch. So I'd need to parse btrfs fi df's output to call the
right balance option. I blindly copied that over from the script I
wrote for the older btrfs which still has DUP metadata and system.

> BTW, I restored and mounted your 20160307-fanbtr-image:
> 
> [266169.207952] BTRFS: device label fanbtr devid 1 transid 22215732 /dev/loop0
> [266203.734804] BTRFS info (device loop0): disk space caching is enabled
> [266203.734806] BTRFS: has skinny extents
> [266204.022175] BTRFS: checking UUID tree
> [266239.407249] attempt to access beyond end of device
> [266239.407252] loop0: rw=1073, want=715202688, limit=705760000
> [266239.407254] BTRFS error (device loop0): bdev /dev/loop0 errs: wr
> 1, rd 0, flush 0, corrupt 0, gen 0
> [266239.407272] attempt to access beyond end of device
> .. and 16 more
> 
> As a quick fix/workaround, I truncated the image to 1T

The original fs was 417 GiB in size. What size does the image claim?

> After re-loop and mount and while doing a balance of the metadata I got this:
> [266667.431704] BTRFS error (device loop0): bad tree block start 0 5827368812544
>
> So something is/was wrong with the fs. Did you do a btrfs check before imaging?

No, I didn't. And there is indeed something wrong:

[10/509]mh@fan:~$ sudo btrfs check /media/tempdisk/
Superblock bytenr is larger than device size
Couldn't open file system
[11/509]mh@fan:~$

Can this be fixed?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
