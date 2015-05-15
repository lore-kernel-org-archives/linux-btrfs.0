Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43851 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbbEOQhq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 12:37:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YtIcK-00005m-26
	for linux-btrfs@vger.kernel.org; Fri, 15 May 2015 18:37:44 +0200
Received: from c-73-47-108-123.hsd1.ma.comcast.net ([73.47.108.123])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 18:37:44 +0200
Received: from cdysthe by c-73-47-108-123.hsd1.ma.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 18:37:44 +0200
To: linux-btrfs@vger.kernel.org
From: Christian <cdysthe@gmail.com>
Subject: Re: Mysterious device (id 0).
Date: Fri, 15 May 2015 12:37:29 -0400
Message-ID: <mj57ca$tou$1@ger.gmane.org>
References: <mj3dg9$h3k$1@ger.gmane.org> <55561CE6.3080807@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <55561CE6.3080807@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/15/2015 12:20 PM, Anand Jain wrote:
>
>
> On 05/15/2015 08:09 AM, Christian wrote:
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
>
>   we are reading an uninitialized device struct and that uninitialized
>   devid happens to be 0. looks like num_devices count went haywire.
>
>   in this config was there any device delete ? or a reduce in # of
>   devices? and has the system been rebooted after that ?
>
> Thanks, Anand

Not sure I understand fully what you are asking, but I deleted a swap 
partition on the drive a while back and increased the size of the btrfs 
partition (with gparted). I have rebooted many times since then. That is 
all the changes I have done to this SSD recently.

Thanks.
>
>
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
>> P.S. I am not a developer.
>>
> --



-- 
//Christian


