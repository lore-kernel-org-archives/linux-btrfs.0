Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39665 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422708AbbEOPgU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 11:36:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YtHer-0000QQ-K0
	for linux-btrfs@vger.kernel.org; Fri, 15 May 2015 17:36:17 +0200
Received: from c-73-47-108-123.hsd1.ma.comcast.net ([73.47.108.123])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 17:36:17 +0200
Received: from cdysthe by c-73-47-108-123.hsd1.ma.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 17:36:17 +0200
To: linux-btrfs@vger.kernel.org
From: Christian <cdysthe@gmail.com>
Subject: Re: Mysterious device (id 0).
Date: Fri, 15 May 2015 11:36:10 -0400
Message-ID: <mj53pb$qlu$1@ger.gmane.org>
References: <mj3dg9$h3k$1@ger.gmane.org> <5555D78D.5040909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <5555D78D.5040909@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/15/2015 07:25 AM, Austin S Hemmelgarn wrote:

> On 2015-05-14 20:09, Christian wrote:
>> Hi,
>>
>> My laptop has a small ext4 /boot partition /dev/sda1 and a large btrfs
>> partition containing / and /home as a sub volume /dev/sda3
>>
>> When I run scrub on /dev/sda3 and check status with sudo btrfs scrub
>> status -d /dev/sda3 I get:
>>
>> scrub status for 3d52dc93-c89f-453f-965d-8601d11e7710
>> scrub device /dev/sda3 (id 1) history
>>      scrub started at Thu May 14 19:54:02 2015 and finished after 235
>> seconds
>>      total bytes scrubbed: 111.03GiB with 0 errors
>> scrub device  (id 0) history
>>      scrub started at Thu May 14 19:54:02 2015 and was aborted after 0
>> seconds
>>      total bytes scrubbed: 0.00B with 0 errors
>>
>> As device (id 0) is indicated, but I have no idea what it is.
>>
>> When I run scrub with a script (cron) the same device (id 0) shows up in
>> a warning:
>>
>> /etc/cron.daily/btrfs-scrub:
>> WARNING: device 0 not present
>> scrub device /dev/sda3 (id 1) done
>>      scrub started at Sat May  2 08:03:46 2015 and finished after 241
>> seconds
>>      total bytes scrubbed: 109.06GiB with 0 errors
>> scrub device  (id 0) canceled
>>      scrub started at Sat May  2 08:03:46 2015 and was aborted after 0
>> seconds
>>      total bytes scrubbed: 0.00B with 0 errors
>>
>> What is this device (id 0) which never gets scrubbed but always shows up?
>>
>> I'm running Ubuntu 15.04 with the 3.19.0-16-generic kernel.
>>
> Have you ever run 'btrfs replace' to replace a device in the filesystem?
>   I know that new device in a replace operation get's tagged as device
> id 0 until the replace operation completes (at which point it gets the
> devid of the device it replaced).  Personally, this is the only case
> that I know of that devid 0 is actually used in the code.  Thinking
> further though, it might also be an off-by-one error somewhere, although
> I have no idea where.
>
>
No, I have never run 'btrfs replace'. This problem was discussed in a 
previous thread covering the script I am using for daily scrub. The 
author had the same problem, but for him it simply went away. Not for me 
though. The thread was

"Re: 3.19.3: check tree block failed + WARNING: device 0 not present on 
scrub".

I have had some problems with btrfs in the past so I am very ware of any 
error message! I can't live without the snapshots anymore though :)


-- 
//Christian


