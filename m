Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40833 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751290AbaBICVi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 21:21:38 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Provide a better free space estimate on RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140209075533.26b4b730@natsu>
Date: Sat, 8 Feb 2014 19:21:37 -0700
Cc: Kai Krakow <hurikhan77+btrfs@gmail.com>, linux-btrfs@vger.kernel.org
Message-Id: <38386895-51E4-4A9E-AA3D-4D941DDCC793@colorremedies.com>
References: <20140206021516.304732cd@natsu> <52F3EED4.7030603@fb.com> <agsfsa-mks.ln1@hurikhan77.spdns.de> <20140208173310.1f90af3b@natsu> <9hqisa-46c.ln1@hurikhan77.spdns.de> <20140209075533.26b4b730@natsu>
To: Roman Mamedov <rm@romanrm.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 8, 2014, at 6:55 PM, Roman Mamedov <rm@romanrm.net> wrote:
> 
> Not sure what exactly becomes problematic if a 2-device RAID1 tells the user
> they can store 1 TB of their data on it, and is no longer lying about the 
> possibility to store 2 TB on it as currently.
> 
> Two 1TB disks in RAID1.

OK but while we don't have a top level switch for variable raid on a volume yet, the on-disk format doesn't consider the device to be raid1 at all. Not the device, nor the volume, nor the subvolume have this attribute. It's a function of the data, metadata or system chunk via their profiles.

I can do a partial conversion on a volume, and even could do this multiple times and end up with some chunks in every available option, some chunks single, some raid1, some raid0, some raid5. All I have to do is cancel the conversion before each conversion is complete, successively shortening the time.

And it's not fair to say this has no application because such conversions take a long time. I might not want to fully do a conversion all at once. There's no requirement that I do so.

In any case I object to the language being used that implicitly indicates the 'raidness' is a device or disk attribute.


Chris Murphy

