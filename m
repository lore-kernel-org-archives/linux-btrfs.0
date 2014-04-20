Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55054 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750887AbaDTUyZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Apr 2014 16:54:25 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Slow Write Performance w/ No Cache Enabled and Different Size Drives
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53540367.4050707@aeb.io>
Date: Sun, 20 Apr 2014 14:54:23 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <D954AF21-BC14-4ADC-9C62-254753AF1998@colorremedies.com>
References: <53540367.4050707@aeb.io>
To: Adam Brenner <adam@aeb.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 20, 2014, at 11:27 AM, Adam Brenner <adam@aeb.io> wrote:
> 
>    mkfs.btrfs -d single /dev/sda3 /dev/sdb /dev/sdc -f
> 
> Once setup, I transferred roughly 3.1TB of data and noticed the write speed was limited to 200MB/s. This is the same write speed that I would see across a single device. I used dd with oflag=direct and a block size of 1M and a count of 1024 from /dev/zero. Both showed the same speeds.

This is expected. And although I haven't tested it, I think you'd get the same results with multiple threads writing at the same time: the allocation would aggregate the threads to one chunk at a time until full, which means writing to one device at a time, then writing a new chunk on a different device until full, and so on in round robin fashion.

I also haven't tested this, so I'm not sure if different behavior happens for reading files located in different chunks on different devices, if those are effectively single threaded reads, or if the files can be read simultaneously.

> 
> So my question is, should I have setup the BTRFS filesystem with -d raid0? Would this have worked with multiple devices with different sizes?

raid0 does work with multiple devices of different sizes, but it won't use the full capacity of the last drive with the most space.

For example: 2GB, 3GB, and 4GB devices as raid0.

The first 2GB copies using 3 stripes, one per device, until the 2GB device is full. The next 1GB copies using 2 stripes, one per remaining device (the 3GB and 4GB ones) until the 3GB device is full. Additional copying results in "cp: error writing ‘./IMG_2892.dng’: No space left on device"

Label: none  uuid: 7dfde9eb-04a8-4920-95c0-51253b2483f8
	Total devices 3 FS bytes used 7.33GiB
	devid    1 size 2.00GiB used 2.00GiB path /dev/sdb
	devid    2 size 3.00GiB used 3.00GiB path /dev/sdc
	devid    3 size 4.00GiB used 3.00GiB path /dev/sdd


Ergo, there is no such thing as single device raid0, so the point at which all but 1 drive is full, writes fail.


Chris Murphy

