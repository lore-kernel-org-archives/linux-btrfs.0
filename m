Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:64906 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755743Ab3HaRm3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 13:42:29 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Device delete returns "unable to go below four devices on raid10" on 5 drive setup
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1377943975.5426.17.camel@pc-steven.LAN>
Date: Sat, 31 Aug 2013 11:42:28 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <A4758013-22BA-4552-B391-9492B42D85C5@colorremedies.com>
References: <1377943975.5426.17.camel@pc-steven.LAN>
To: Steven Post <redalert.commander@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 31, 2013, at 4:12 AM, Steven Post <redalert.commander@gmail.com> wrote:
> 
> The system is running Debian Wheezy (kernel 3.2.0-4-amd64 #1 SMP Debian
> 3.2.46-1 x86_64).
> 
> Is this something known (and possibly resolved in a later version), or
> should I open a bug report about it?

Try 3.10 or 3.11 before filing a bug on it.

> Could it be that the device removal
> was completed, but still shows as part of the array for some reason?

Yes. It might take a few minutes after the chunks are reallocated for the device to be removed from the volume. I've had some cases where even a reboot was needed for the information in fi sh to refresh.


> The reason for the remove is actually that I want to (gradually) replace
> the 3TB drives with 1 TB ones, and somewhere in the middle move some of
> the data of the array, to another machine, that currently has the 1 TB
> drives which I intend to replace with the 3TB ones.

Use a newer kernel for sure. What you suggest should work. If you're testing to see if it does work, and you're prepared for it not working (i.e. totally losing the entire file system) and prepared to find a consistent reproducer if it doesn't work, then have at it.

Otherwise, create a whole new btrfs volume with recent kernel and btrfs-progs on the other machine; and then rsync everything from old to new. Rsync has a checksum option, it will take longer, but you can then be reasonably assured of file integrity.


Chris Murphy