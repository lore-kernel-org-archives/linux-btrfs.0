Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob17.myregisteredsite.com ([209.17.115.57]:45767 "EHLO
	atl4mhob17.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbaAJBam (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 20:30:42 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.113])
	by atl4mhob17.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s0A1UeWe021573
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Jan 2014 20:30:40 -0500
Message-ID: <52CF4D5D.2010709@chinilu.com>
Date: Thu, 09 Jan 2014 17:31:09 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Jim Salter <jim@jrs-s.net>
CC: Clemens Eisserer <linuxhippy@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs handle bad blocks in raid1?
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com>
In-Reply-To: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/09/2014 05:06 PM, Jim Salter wrote:
> On Jan 9, 2014 7:46 PM, George Mitchell <george@chinilu.com> wrote:
>> I would prefer that the drive, even flash media type, would
>> catch and resolve write failures.  If it doesn't happen at the hardware
>> layer, according to how I understand Hugo's answer, btrfs, at least for
>> now, is not capable of it.
> Not sure what you mean by this. If a bit flips on a btrfs-raid1 block, btrfs will detect it. Then it checks the mirror's copy of that block. It returns the good copy, then immediately writes the good copy over the bad copy.
>
> I know this because I tested it directly just last week by flipping a bit in an offline btrfs filesystem manually. When I brought the volume back online and read the file containing the bit I flipped, it operated exactly as described, and logged its actions in kern.log, . :-)
Jim, my point was that IF the drive does not successfully resolve the 
bad block issue and btrfs takes a write failure every time it attempts 
to overwrite the bad data, it is not going to remap that data, but 
rather it is going to fail the drive.  In other words, if the drive has 
a bad sector which it has not done anything about at the drive level, 
btrfs will not remap the sector.  It will, rather, fail the drive. Is 
that not correct?
