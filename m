Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:56233 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab2FYXBA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 19:01:00 -0400
Message-ID: <4FE8EDA1.5090004@zytor.com>
Date: Mon, 25 Jun 2012 16:00:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Marios Titas <redneb8888@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Feature request: true RAID-1 mode
References: <4FE1F9E4.5090301@zytor.com> <CAAdM646jbr3+5stVTkX=E2Rb2SVWoMKyptr4Bv5g5-6O_6Uq4g@mail.gmail.com> <20120621005048.GA19507@shiny> <670f2f56-9918-4463-ad89-780ba80bfecc@email.android.com> <20120625152142.GD17638@shiny> <4FE8A3D9.3060400@zytor.com> <20120625225424.GG25572@carfax.org.uk>
In-Reply-To: <20120625225424.GG25572@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/25/2012 03:54 PM, Hugo Mills wrote:
> On Mon, Jun 25, 2012 at 10:46:01AM -0700, H. Peter Anvin wrote:
>> On 06/25/2012 08:21 AM, Chris Mason wrote:
>>> Yes and no.  If you have 2 drives and you add one more, we can
>>> make it do all new chunks over 3 drives.  But, turning the
>>> existing double mirror chunks into a triple mirror requires a
>>> balance.
>>> 
>>> -chris
>> 
>> So trigger one.  This is the exact analogue to the resync pass
>> that is required in classic RAID after adding new media.
> 
> You'd have to cancel and restart if a second new disk was added 
> while the first balance was ongoing. Fortunately, this isn't a
> problem these days.
> 
> Also, it occurs to me that I should just check -- are you aware 
> that the btrfs implementation of RAID-1 makes no guarantees about
> the location of any given piece of data? i.e. if I have a piece of
> data stored at block X on disk 1, it's not guaranteed to be stored
> at block X on disks 2, 3, 4, ... I'm not sure if this is important
> to you, but it's a significant difference between the btrfs
> implementation of RAID-1 and the MD implementation.
> 

I am aware of that, and it is not a problem... the one-device
bootloader can find out *which* disk it is talking to by comparing
uuids, and the btrfs data structures will tell it how to find the data
on that specific disk.  It does of course mean the bootloader needs to
be aware of the multidisk nature of btrfs, but that isn't a problem in
itself.

	-hpa

