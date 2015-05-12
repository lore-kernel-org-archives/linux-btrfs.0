Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 206-248-167-68.dsl.teksavvy.com ([206.248.167.68]:35709 "EHLO
	mail.isoar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbbELAlK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 20:41:10 -0400
Message-ID: <555147C6.9070000@isoar.ca>
Date: Mon, 11 May 2015 20:22:30 -0400
From: "Andrew E. Mileski" <andrewm@isoar.ca>
MIME-Version: 1.0
To: Hendrik Friedel <hendrik@friedels.name>, linux-btrfs@vger.kernel.org
Subject: Re: raid 5 and different device size
References: <55510B14.7090204@friedels.name>
In-Reply-To: <55510B14.7090204@friedels.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/05/15 04:03 PM, Hendrik Friedel wrote:
> I do have three -identical- 3TB HDD.
>
> Now I intend to:
> * increase the available disc space
> * stop worrying how much space is available on which drive
> * create redundancy
> * have low operating cost (power-consumption)
>
> So, I need to buy one additional HDD.
> And I want to combine the drives to one big volume.
>
> I am aware that raid is no backup.
> Thus, I backup the HomeVideos and the Photos on an external drive not
> connected to the power supply and USB.

In my experience, people tend to GREATLY undervalue their data, until it 
is lost!

Your proposed 12 TB (4x3TB) of storage is > 10^14 bits, so you are very 
likely to to encounter an unrecoverable sector on a full-read with most 
typically error-rated drives.

Also consider drive wear (average lifespan of 3 years), spares, and how 
you will deal with a single or multi-drive failure.

You may want to rethink your plan, and the value of your data.

> Now the last point: Power consumption: Under which conditions can the
> drives spin down in case of raid5? I assume that all drives have to run
> as in case the data is written on any one of the drives, right?
> Is that also true during reading of data, i.e. is the parity also
> checked for read operations?

In RAID-5/6, parity is only checked when an error or failure is reported 
by the drive.  This can lead to undetected errors from "bit rot".  Hence 
regular scrubbing (reading of all data) is recommended.

Note that BTRFS checksums data, and verifies data read, so even if the 
drive doesn't detect an error BTRFS is likely to, but BTRFS can't 
recover without additional redundancy.

Personally, I use BTRFS formatted with "-mdup -dsingle" on top of either 
hardware RAID-6 (primary array) or software RAID-5 (backup array), so I 
don't really rely upon BTRFS for recovery.

Most external consumer-grade enclosures are best used with "Green" 
drives, which tend to be 5400 RPM max, as these enclosures often have 
very limited cooling.  Make sure your drives are compatible with the 
enclosure.

I have even seen server-grade rack enclosures with reduced temperature 
ratings when using 7200 RPM or faster drives.  Heat and vibration are 
important considerations with arrays.

I prefer Seagate enterprise drives and WD consumer drives.

Note that WD "Red Label" drives are identical to their "Green Label" 
drives, except "Red Label" drives have time-limited error recovery 
(TLER) firmware for use in arrays.  However, it is possible to increase 
the error timeout in Linux, so even non-TLER drives can be used in 
arrays, but it isn't as convenient nor recommended.  Both are 
error-rated 1 unrecoverable sector in 10^14 bits read.

~~Andrew E. Mileski
