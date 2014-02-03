Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:50867 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750836AbaBCVIb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 16:08:31 -0500
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: lost with degraded RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CABgvyo8ZG=pk=i-7iXzoOWqZj_fVvUd6xiaXef1KWR8QLibhXg@mail.gmail.com>
Date: Mon, 3 Feb 2014 14:08:28 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <6C293A14-9A38-4DAA-A720-1F77B9CB083D@colorremedies.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com> <C0AD9885-8F81-4642-809F-BDC3933A5932@colorremedies.com> <20140130175831.GU3314@carfax.org.uk> <C3B0EA86-0CBA-4500-81A8-7F3A99306E76@colorremedies.com> <CABgvyo8ZG=pk=i-7iXzoOWqZj_fVvUd6xiaXef1KWR8QLibhXg@mail.gmail.com>
To: =?iso-8859-1?Q?Johan_Kr=F6ckel?= <johan.kroeckel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 3, 2014, at 1:55 PM, Johan Kröckel <johan.kroeckel@gmail.com> wrote:

> 2014-01-30 Chris Murphy <lists@colorremedies.com>:
>> 
>> On Jan 30, 2014, at 10:58 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> 
>>> On Thu, Jan 30, 2014 at 10:33:21AM -0700, Chris Murphy wrote:
>>>> You're doing an online conversion of a degraded raid1 volume into single? Does anyone know if this is expected or intended to work?
>>> 
>>>  I don't see why not. One suggested method of recovering RAID from a
>>> degraded situation is to rebalance over just the remaining devices
>>> (space permitting, of course).
>> 
>> Right but that's not a conversion. That's a regular balance on a degraded mount, with multiple remaining devices: e.g. a 4 disk raid1, drive fails, mount -o degraded, delete missing, then balance will replicate any missing 2nd copies onto three drives.
>> 
>> The bigger problem at the moment is that -o degraded isn't working for Johan. The too many missing devices message seems like a bug and with limited information it may even be whatever that bug is, that cause the conversion to fail. Some 11GB were converted prior to the failure.
> Which usefull information can provide. On the weekend I was at the
> server and found out, that the vanishing of the drive at reboot was
> strange behavior of the bios. So the drive is online again. but the
> filesystem is still showing strange behavior, but now I can mount it
> rw.

I'd like to see btrfs fi df results for the volume. And new btrfs check. And then a backup if needed, and then a scrub to see if that fixes anything broken between them. I'm not sure what happens if a new generation object is broken and the old generation is OK, what scrub will do? Maybe it just reports it, I'm not sure. If you want you could do a btrfs scrub -r which is read only and just reports what the problems are.

You also have an incomplete balance, right? So it's possible some things might not be fixable if the conversion to single was successful. You'll need to decide if you want to reconvert back to data/metadata raid1/raid from whatever you're at now.


Chris Murphy