Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw5a-delaine.wadns.net ([196.220.39.203]:22267 "EHLO
	fw5a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754784AbaEEHsc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 03:48:32 -0400
Message-ID: <53674246.1090408@swiftspirit.co.za>
Date: Mon, 05 May 2014 09:48:22 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: How does "btrfs fi show" show full?
References: <20140505005412.GS9061@merlins.org> <53670F70.1010509@swiftspirit.co.za> <20140505055029.GM10159@merlins.org>
In-Reply-To: <20140505055029.GM10159@merlins.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/05/14 07:50, Marc MERLIN wrote:
> On Mon, May 05, 2014 at 06:11:28AM +0200, Brendan Hide wrote:
>> The "per-device" used amount refers to the amount of space that has
>> been allocated to chunks. That first one probably needs a balance.
>> Btrfs doesn't behave very well when available diskspace is so low
>> due to the fact that it cannot allocate any new chunks. An attempt
>> to allocate a new chunk will result in ENOSPC errors.
>>
>> The "Total" bytes used refers to the total actual data that is stored.
> Right. So 'Total used' is what I'm really using, whereas 'devid used' is
> actually what is being used due to the way btrfs doesn't seem to reclaim
> chunks after they're not used anymore, or some similar problem.
>
> In the second FS:
>>> Label: btrfs_pool1  uuid: 4850ee22-bf32-4131-a841-02abdb4a5ba6
>>> 	Total devices 1 FS bytes used 442.17GiB
>>> 	devid    1 size 865.01GiB used 751.04GiB path /dev/mapper/cryptroot
> The difference is huge between 'Total used' and 'devid used'.
>
> Is btrfs going to fix this on its own, or likely not and I'm stuck doing
> a full balance (without filters since I'm balancing data and not
> metadata)?
>
> If that helps.
> legolas:~# btrfs fi df /mnt/btrfs_pool1
> Data, single: total=734.01GiB, used=435.29GiB
> System, DUP: total=8.00MiB, used=96.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=8.50GiB, used=6.74GiB
> Metadata, single: total=8.00MiB, used=0.00
>
> Thanks,
> Marc
What I typically do in snapshot cleanup scripts is to use the usage= 
filter with the percentage being a simple algorithm of "halfway between 
actual data and maximum chunk allocation I'm comfortable with". As an 
example, one of my servers' diskspace was at 65% and last night the 
chunk allocation reached the 90% mark. So it automatically ran the 
balance with "dusage=77". This would have cleared out about half of the 
"unnecessary" chunks.

Balance causes a lot of load with spinning rust - of course, 
after-hours, nobody really cares. With SSDs it causes wear. This is just 
one method I felt was a sensible way for me to avoid ENOSPC issues while 
also ensuring I'm not rebalancing the entire system unnecessarily.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

