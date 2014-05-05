Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw6a-delilah.wadns.net ([196.220.39.210]:32607 "EHLO
	fw6a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750939AbaEEELj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 00:11:39 -0400
Message-ID: <53670F70.1010509@swiftspirit.co.za>
Date: Mon, 05 May 2014 06:11:28 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: How does "btrfs fi show" show full?
References: <20140505005412.GS9061@merlins.org>
In-Reply-To: <20140505005412.GS9061@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/05 02:54 AM, Marc MERLIN wrote:
> More slides, more questions, sorry :)
> (thanks for the other answers, I'm still going through them)
>
> If I have:
> gandalfthegreat:~# btrfs fi show
> Label: 'btrfs_pool1'  uuid: 873d526c-e911-4234-af1b-239889cd143d
> 	Total devices 1 FS bytes used 214.44GB
> 	devid    1 size 231.02GB used 231.02GB path /dev/dm-0
>
> I'm a bit confused.
>
> It tells me
> 1) FS uses 214GB out of 231GB
> 2) Device uses 231GB out of 231GB
>
> I understand how the device can use less than the FS if you have
> multiple devices that share a filesystem.
> But I'm not sure how a filesystem can use less than what's being used on
> a single device.
>
> Similarly, my current laptop shows:
> legolas:~# btrfs fi show
> Label: btrfs_pool1  uuid: 4850ee22-bf32-4131-a841-02abdb4a5ba6
> 	Total devices 1 FS bytes used 442.17GiB
> 	devid    1 size 865.01GiB used 751.04GiB path /dev/mapper/cryptroot
>
> So, am I 100GB from being full, or am I really only using 442GB out of 865GB?
>
> If so, what does the device used value really mean if it can be that
> much higher than the filesystem used value?
>
> Thanks,
> Marc
The "per-device" used amount refers to the amount of space that has been 
allocated to chunks. That first one probably needs a balance. Btrfs 
doesn't behave very well when available diskspace is so low due to the 
fact that it cannot allocate any new chunks. An attempt to allocate a 
new chunk will result in ENOSPC errors.

The "Total" bytes used refers to the total actual data that is stored.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

