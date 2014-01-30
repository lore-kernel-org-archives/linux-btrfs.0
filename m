Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48066 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752728AbaA3SZk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 13:25:40 -0500
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: lost with degraded RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140130175831.GU3314@carfax.org.uk>
Date: Thu, 30 Jan 2014 11:25:41 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <C3B0EA86-0CBA-4500-81A8-7F3A99306E76@colorremedies.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com> <C0AD9885-8F81-4642-809F-BDC3933A5932@colorremedies.com> <20140130175831.GU3314@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 30, 2014, at 10:58 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Thu, Jan 30, 2014 at 10:33:21AM -0700, Chris Murphy wrote:
>> 
>> On Jan 29, 2014, at 12:16 PM, Johan Kröckel <johan.kroeckel@gmail.com> wrote:
>> 
>>> My situation:
>>> 
>>> Former btrfs-RAID1 on two luks encrypted partitions (bunkerA and bunkerB).
>>> Disk holding bunkerB died online.
>>> Now I started rebalancing bunkerA to single,
>> 
>> 
>> You're doing an online conversion of a degraded raid1 volume into single? Does anyone know if this is expected or intended to work?
> 
>   I don't see why not. One suggested method of recovering RAID from a
> degraded situation is to rebalance over just the remaining devices
> (space permitting, of course).

Right but that's not a conversion. That's a regular balance on a degraded mount, with multiple remaining devices: e.g. a 4 disk raid1, drive fails, mount -o degraded, delete missing, then balance will replicate any missing 2nd copies onto three drives.

The bigger problem at the moment is that -o degraded isn't working for Johan. The too many missing devices message seems like a bug and with limited information it may even be whatever that bug is, that cause the conversion to fail. Some 11GB were converted prior to the failure.


Chris Murphy

