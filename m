Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:35430 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752046AbcK2Hfj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 02:35:39 -0500
Date: Tue, 29 Nov 2016 08:35:26 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Goffredo Baroncelli <kreijack@inwind.it>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
Message-ID: <20161129073526.GA2441@angband.pl>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
 <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
 <20161125043119.GG8685@hungrycats.org>
 <cd7ee5cc-d384-7c9c-d656-cef2569b749a@inwind.it>
 <1480304269.6254.6.camel@scientia.net>
 <2b15ae6f-51ce-45ff-47c0-699506de4e56@inwind.it>
 <20161128214829.GO8685@hungrycats.org>
 <1480384367.6747.46.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480384367.6747.46.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2016 at 02:52:47AM +0100, Christoph Anton Mitterer wrote:
> On Mon, 2016-11-28 at 16:48 -0500, Zygo Blaxell wrote:
> > If a drive's embedded controller RAM fails, you get corruption on the
> > majority of reads from a single disk, and most writes will be corrupted
> > (even if they were not before).
> 
> Administrating a multi-PiB Tier-2 for the LHC Computing Grid with quite
> a number of disks for nearly 10 years now, I'd have never stumbled on
> such a case of breakage so far...
> 
> Actually most cases are as simple as HDD fails to work and this is
> properly signalled to the controller.

I administer no real storage at this time, and got only 16 disks (plus a few
disk-likes) to my name right now.  Yet in a ~2 months span I've seen three
cases of silent data corruption:

* a RasPi I used for DNS recursor/DHCP/aiccu started mangling some writes,
  with no notification that something is amiss.  With ext4 being a
  silentdatalossfs, there was no clue it was a disk (ok, SD) problem at all,
  making it really "fun" to debug.  Happens on multiple SD cards, thus it's
  the machine that's at fault.

* a HDD had some link resets and silent data corruption, diagnosed to a bad
  SATA cable, the disk works fine since (obviously after extensive tests).

* a HDD that has link resets and silent data corruption (apparently
  write-time only(?)), Marduk knows why.  Happens with multiple cables and
  two machines, putting the blame somewhere on the disk.

Thus, assumption that the controller will be notified about read errors is
quite invalid.  In the above cases, if recovery was possible it'd be
beneficial to rewrite a good copy of the data.


Meow!
-- 
The bill declaring Jesus as the King of Poland fails to specify whether
the addition is at the top or end of the list of kings.  What should the
historians do?
