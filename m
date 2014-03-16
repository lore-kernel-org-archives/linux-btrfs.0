Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58918 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755735AbaCPXUr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 19:20:47 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to handle a RAID5 arrawy with a failing drive? 
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com>
Date: Sun, 16 Mar 2014 17:20:43 -0600
Message-Id: <9BD2ECEC-A976-4265-BA95-303B305B7EC3@colorremedies.com>
To: Btrfs <linux-btrfs@vger.kernel.org>, Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20140316222026.GU16946@merlins.org>
 <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com>
 <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com>


On Mar 16, 2014, at 5:12 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Mar 16, 2014, at 4:55 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
>> Then use btrfs replace start.
> 
> Looks like in 3.14rc6 replace isn't yet supported. I get "dev_replace cannot yet handle RAID5/RAID6".
> 
> When I do:
> btrfs device add <new> <mp>
> 
> The command hangs, no kernel messages.

So even though the device add command hangs, another shell with btrfs fi show reports that it succeeded:

Label: none  uuid: d50b6c0f-518a-455f-9740-e29779649250
	Total devices 4 FS bytes used 5.70GiB
	devid    1 size 7.81GiB used 4.02GiB path /dev/sdb
	devid    2 size 7.81GiB used 3.01GiB path /dev/sdc
	devid    3 size 7.81GiB used 4.01GiB path 
	devid    4 size 7.81GiB used 0.00 path /dev/sdd

Yet umount <mp> says the target is busy. ps reports the command status D+. And it doesn't cancel. So at the moment I'm stuck coming up with a work around.


Chris Murphy