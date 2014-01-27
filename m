Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41887 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753138AbaA0Qmy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 11:42:54 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs and ECC RAM
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1390838938.1692.14.camel@sasami.ottawa.blindsidenetworks.com>
Date: Mon, 27 Jan 2014 09:42:48 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <6200BC40-0DAE-431B-80EA-E4BF038300CE@colorremedies.com>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de> <CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com> <52DC9453.4000705@gmail.com> <96091903-E1B0-4455-9EDC-EF94EE2E5110@aei.mpg.de> <52DD426A.5020104@shiftmail.org> <52DD49F3.8050100@chinilu.com> <75B4E5E0-07FF-401B-BE23-1B3D768AB0EF@colorremedies.com> <1390838938.1692.14.camel@sasami.ottawa.blindsidenetworks.com>
To: Calvin Walton <calvin.walton@kepstin.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 27, 2014, at 9:08 AM, Calvin Walton <calvin.walton@kepstin.ca> wrote:

> On Fri, 2014-01-24 at 17:45 -0700, Chris Murphy wrote:
>> On Jan 20, 2014, at 9:08 AM, George Mitchell <george@chinilu.com> wrote:
>> 
>>> After reading the recent posts on this topic I am beginning to think
>> there is some real confusion between "check sums" and "parity". 
>> 
>> Yes, I often see conventional raid6 assumed to always be capable of
>> detecting and correcting corruption, not merely the ability to rebuild
>> missing data of known location and length in a stripe (known either
>> due to the drive reporting read error along with LBA; or a physical
>> device becoming unavailable or unresponsive).
>> 
>>> But I CAN see how bad RAM could affect parity calculations and
>> resulting data IN THE ABSENCE of protective checksums and cannot help
>> but wonder if THAT is what the original article is describing.
>> 
>> Does Btrfs (and I'd presume ZFS) raid5/6 checksum both data and parity
>> chunks? And in the case of raid6 are the two parities separately
>> checksummed?
> 
> The checksumming in Btrfs is actually the other way around; the file
> extents and filesystem metadata structures are checksummed before the
> RAID parity is applied. The resulting blocks containing both data and
> checksums are split over multiple drives with parity.

Got it, thanks, that makes sense. Layout wise, I've read it's better for reduced latency if metadata profile is raid1 rather than raid5/6, when data profile is raid 5/6. I'm pretty sure with multiple devices if a metadata profile isn't explicitly stated at mkfs time, that it's assumed to be raid1, which sounds like a good default. With n mirrors, it may one day make sense to have the number of metadata copies scale automatically based on the number of devices (and always could be explicitly set or changed by the user).


Chris Murphy

