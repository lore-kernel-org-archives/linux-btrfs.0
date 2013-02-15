Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moltke.seatribe.se ([178.63.100.209]:32890 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3BOV4Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 16:56:25 -0500
Date: Fri, 15 Feb 2013 22:56:19 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
cc: linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
In-Reply-To: <201302151005.29014.Martin@lichtvoll.de>
Message-ID: <alpine.DEB.2.02.1302152250280.8810@shack.dolda2000.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <201302141544.05747.Martin@lichtvoll.de> <alpine.DEB.2.02.1302150435450.8810@shack.dolda2000.com> (sfid-20130215_095505_610309_779D53E5) <201302151005.29014.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 15 Feb 2013, Martin Steigerwald wrote:
> So or so I think a kernel bug is involved here.

Well, *some* kernel bug is certainly involved. :)

I did wipe the filesystem off the device and reinserted it as a new device 
into the filesystem. After that, "btrfs fi show" gave me the following:

> $ sudo ./btrfs fi show
> Label: none  uuid: 40d346bb-2c77-4a78-8803-1e441bf0aff7
>         Total devices 3 FS bytes used 2.66TB
>         devid    3 size 2.73TB used 0.00 path /dev/sdi1
>         devid    2 size 2.73TB used 2.67TB path /dev/sde1
>         *** Some devices missing

I then proceeded to try to remove the missing devices with "btrfs dev del 
missing /mnt", but it made no difference whatever, with the kernel saying 
the following:

Feb 15 07:12:29 nerv kernel: [262110.799823] btrfs: no missing devices found to remove

This seems odd enough, seeing as how "btrfs fi show" says there are 
missing devices, and the kernel contradicting that.

Either way, I tried to start a scrub on the filesystem, too, seeing if 
that would make a difference, but that oopsed the kernel. :)

The oops cut can be found here: <http://www.dolda2000.com/~fredrik/tmp/btrfs-oops>

So with that, I'm certainly going to reboot the machine. :)

--

Fredrik Tolf
