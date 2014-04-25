Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out-02.shaw.ca ([64.59.136.138]:16789 "EHLO
	smtp-out-02.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaDYSpz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 14:45:55 -0400
Message-ID: <535AAB24.4000206@shaw.ca>
Date: Fri, 25 Apr 2014 12:36:20 -0600
From: Steve Leung <sjleung@shaw.ca>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: safe/necessary to balance system chunks?
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung> <75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com>
In-Reply-To: <75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/25/2014 11:24 AM, Chris Murphy wrote:
>
> On Apr 25, 2014, at 8:57 AM, Steve Leung <sjleung@shaw.ca> wrote:
>
>> I've got a 3-device RAID1 btrfs filesystem that started out life as single-device.
>>
>> btrfs fi df:
>>
>> Data, RAID1: total=1.31TiB, used=1.07TiB
>> System, RAID1: total=32.00MiB, used=224.00KiB
>> System, DUP: total=32.00MiB, used=32.00KiB
>> System, single: total=4.00MiB, used=0.00
>> Metadata, RAID1: total=66.00GiB, used=2.97GiB
>>
>> This still lists some system chunks as DUP, and not as RAID1.  Does this mean that if one device were to fail, some system chunks would be unrecoverable?  How bad would that be?
>
> Anyway, it's probably a high penalty for losing only 32KB of data.  I think this could use some testing to try and reproduce conversions where some amount of "system" or "metadata" type chunks are stuck in DUP. This has come up before on the list but I'm not sure how it's happening, as I've never encountered it.

As for how it occurred, I'm not sure.  I created this filesystem some 
time ago (not sure exactly, but I'm guessing with a 3.4-era kernel?) so 
it's quite possible it's not reproducible on newer kernels.

It's also nice to know I've been one failed device away from a dead 
filesystem for a long time now, but better to notice it late than never.  :)

Steve
