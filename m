Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:39443 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaA0QJA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 11:09:00 -0500
Received: by mail-qc0-f182.google.com with SMTP id c9so8303941qcz.13
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 08:09:00 -0800 (PST)
Message-ID: <1390838938.1692.14.camel@sasami.ottawa.blindsidenetworks.com>
Subject: Re: btrfs and ECC RAM
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Mon, 27 Jan 2014 11:08:58 -0500
In-Reply-To: <75B4E5E0-07FF-401B-BE23-1B3D768AB0EF@colorremedies.com>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
	 <CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com>
	 <52DC9453.4000705@gmail.com>
	 <96091903-E1B0-4455-9EDC-EF94EE2E5110@aei.mpg.de>
	 <52DD426A.5020104@shiftmail.org> <52DD49F3.8050100@chinilu.com>
	 <75B4E5E0-07FF-401B-BE23-1B3D768AB0EF@colorremedies.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-01-24 at 17:45 -0700, Chris Murphy wrote:
> On Jan 20, 2014, at 9:08 AM, George Mitchell <george@chinilu.com> wrote:
> 
> > After reading the recent posts on this topic I am beginning to think
> there is some real confusion between "check sums" and "parity". 
> 
> Yes, I often see conventional raid6 assumed to always be capable of
> detecting and correcting corruption, not merely the ability to rebuild
> missing data of known location and length in a stripe (known either
> due to the drive reporting read error along with LBA; or a physical
> device becoming unavailable or unresponsive).
> 
> > But I CAN see how bad RAM could affect parity calculations and
> resulting data IN THE ABSENCE of protective checksums and cannot help
> but wonder if THAT is what the original article is describing.
> 
> Does Btrfs (and I'd presume ZFS) raid5/6 checksum both data and parity
> chunks? And in the case of raid6 are the two parities separately
> checksummed?

The checksumming in Btrfs is actually the other way around; the file
extents and filesystem metadata structures are checksummed before the
RAID parity is applied. The resulting blocks containing both data and
checksums are split over multiple drives with parity.

Presumably once scrub is implemented in btrfs RAID5/6, it will work by
first reconstructing the filesystem structure using data chunks, then
checking the checksum; if the checksum fails, it will attempt to
reconstruct the filesystem structure using the parity chunks instead of
data chunks and then re-check the checksum to confirm the reconstruction
was successful.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

