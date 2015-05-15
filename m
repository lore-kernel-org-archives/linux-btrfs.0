Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46524 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933793AbbEORRd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 13:17:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YtJEo-0004sL-U0
	for linux-btrfs@vger.kernel.org; Fri, 15 May 2015 19:17:31 +0200
Received: from c-73-47-108-123.hsd1.ma.comcast.net ([73.47.108.123])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 19:17:30 +0200
Received: from cdysthe by c-73-47-108-123.hsd1.ma.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 19:17:30 +0200
To: linux-btrfs@vger.kernel.org
From: Christian <cdysthe@gmail.com>
Subject: Re: Mysterious device (id 0).
Date: Fri, 15 May 2015 13:17:24 -0400
Message-ID: <mj59n5$5v3$1@ger.gmane.org>
References: <mj3dg9$h3k$1@ger.gmane.org> <55561CE6.3080807@oracle.com> <mj57ca$tou$1@ger.gmane.org> <55562408.9010308@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <55562408.9010308@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/15/2015 12:51 PM, Anand Jain wrote:
>
>
> On 05/16/2015 12:37 AM, Christian wrote:
>> On 05/15/2015 12:20 PM, Anand Jain wrote:
>>>
>>>
>>> On 05/15/2015 08:09 AM, Christian wrote:
>>>> Hi,
>>>>
>>>> My laptop has a small ext4 /boot partition /dev/sda1 and a large btrfs
>>>> partition containing / and /home as a sub volume /dev/sda3
>>>>
>>>> When I run scrub on /dev/sda3 and check status with sudo btrfs scrub
>>>> status -d /dev/sda3 I get:
>>>>
>>>> scrub status for 3d52dc93-c89f-453f-965d-8601d11e7710
>>>> scrub device /dev/sda3 (id 1) history
>>>>      scrub started at Thu May 14 19:54:02 2015 and finished after 235
>>>> seconds
>>>>      total bytes scrubbed: 111.03GiB with 0 errors
>>>> scrub device  (id 0) history
>>>>      scrub started at Thu May 14 19:54:02 2015 and was aborted after 0
>>>> seconds
>>>>      total bytes scrubbed: 0.00B with 0 errors
>>>
>>>   we are reading an uninitialized device struct and that uninitialized
>>>   devid happens to be 0. looks like num_devices count went haywire.
>>>
>>>   in this config was there any device delete ? or a reduce in # of
>>>   devices? and has the system been rebooted after that ?
>>>
>>> Thanks, Anand
>>
>> Not sure I understand fully what you are asking, but I deleted a swap
>> partition on the drive a while back and increased the size of the btrfs
>> partition (with gparted). I have rebooted many times since then. That is
>> all the changes I have done to this SSD recently.
>
>   ok got it. now do you have any other disk in the system with the same
>   fsid ? what does the btrfs fi show -d or blkid show.
>
> Thanks

btrfs fi show -d
Label: none  uuid: 3d52dc93-c89f-453f-965d-8601d11e7710
	Total devices 1 FS bytes used 108.94GiB
	devid    1 size 222.84GiB used 111.03GiB path /dev/sda3


blkid
/dev/sda1: UUID="82348a5a-6c11-47dc-a4aa-884431c7cc1a" TYPE="ext4" 
PARTUUID="8e3b64c9-0f7d-4720-be83-8de7a63ec246"
/dev/sda3: UUID="3d52dc93-c89f-453f-965d-8601d11e7710" 
UUID_SUB="91c64b93-2eb7-4e98-b940-57a2ae3edd6e" TYPE="btrfs" 
PARTUUID="40fcadee-050e-4f5d-8538-6abdfc57c7b8"

It probably doesn't matter but the drive is an INTEL SSD on a Lenovo 
Thinkpad X1 Carbon with Ubuntu 15.04

>
>
>> Thanks.
>>>
>>>
>>>> As device (id 0) is indicated, but I have no idea what it is.
>>>>
>>>> When I run scrub with a script (cron) the same device (id 0) shows
>>>> up in
>>>> a warning:
>>>>
>>>> /etc/cron.daily/btrfs-scrub:
>>>> WARNING: device 0 not present
>>>> scrub device /dev/sda3 (id 1) done
>>>>      scrub started at Sat May  2 08:03:46 2015 and finished after 241
>>>> seconds
>>>>      total bytes scrubbed: 109.06GiB with 0 errors
>>>> scrub device  (id 0) canceled
>>>>      scrub started at Sat May  2 08:03:46 2015 and was aborted after 0
>>>> seconds
>>>>      total bytes scrubbed: 0.00B with 0 errors
>>>>
>>>> What is this device (id 0) which never gets scrubbed but always shows
>>>> up?
>>>>
>>>> I'm running Ubuntu 15.04 with the 3.19.0-16-generic kernel.
>>>>
>>>> P.S. I am not a developer.
>>>>
>>> --
>>
>>
>>
> --


-- 
//Christian


