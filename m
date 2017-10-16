Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37388 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbdJPGJL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 02:09:11 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9G69AXd002028
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 06:09:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9G69AV7016361
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 06:09:10 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9G69A7O001153
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 06:09:10 GMT
Subject: Re: [PATCH v8 2/2] btrfs: check device for critical errors and mark
 failed
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
References: <20171003155920.24925-1-anand.jain@oracle.com>
 <20171003155920.24925-3-anand.jain@oracle.com>
 <20171004201154.GB4902@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <881db992-2240-ce30-4d05-d0bd1faa2aa4@oracle.com>
 <20171006235645.GC19068@lim.localdomain>
 <634a15da-a831-d196-55c6-8684a7288572@oracle.com>
 <20171013184628.GD1553@lim.localdomain>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <102872ae-6db0-2bb1-9acb-c5b407e4c845@oracle.com>
Date: Mon, 16 Oct 2017 14:09:03 +0800
MIME-Version: 1.0
In-Reply-To: <20171013184628.GD1553@lim.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/14/2017 02:46 AM, Liu Bo wrote:
> On Sun, Oct 08, 2017 at 10:23:58PM +0800, Anand Jain wrote:
>>
>>
>> On 10/07/2017 07:56 AM, Liu Bo wrote:
>>> On Thu, Oct 05, 2017 at 09:56:59PM +0800, Anand Jain wrote:
>>>>
>>>>
>>>> On 10/05/2017 04:11 AM, Liu Bo wrote:
>>>>> On Tue, Oct 03, 2017 at 11:59:20PM +0800, Anand Jain wrote:
>>>>>> From: Anand Jain <Anand.Jain@oracle.com>
>>>>>>
>>>>>> Write and flush errors are critical errors, upon which the device fd
>>>>>> must be closed and marked as failed.
>>>>>>
>>>>>
>>>>> Can we defer the job of closing device to umount?
>>>>
>>>>    Originally I think it was designed to handle the bad disk
>>>>    same as missing device. as below [1]. This patch just does that.
>>
>>>>    But I am curious to know if there is any issue to close failed
>>>>    device ?
>>
>>     Anything on this ?
> 
> No big deal, it's just different with md's behavior, but surely it
> doesn't make a big difference whether we close device fd here or not.

  Ok.

>>
>>
>>>> [1]
>>>> -----
>>>> static int read_one_dev(struct btrfs_fs_info *fs_info,
>>>>                           struct extent_buffer *leaf,
>>>>                           struct btrfs_dev_item *dev_item)
>>>> ::
>>>>               /*
>>>>                * this happens when a device that was properly setup
>>>>                * in the device info lists suddenly goes bad.
>>>>                * device->bdev is NULL, and so we have to set
>>>>                * device->missing to one here
>>>>                */
>>>> ------
>>>>
>>>>    So here I misuse the device missing scenario (device->bdev = NULL)
>>>>    to the failed device scenario. (code comment mentioned it).
>>>>
>>>
>>> This is OK to me, we can unify these stuff later, for now, ->missing
>>> is to bypass this failed disk for r/w.
>>>
>>>>    Secondly as in the patch 1/2 commit log and also Austin mentioned it,
>>>>    if failed device close is deferred it will also defer the cleanup of
>>>>    the failed device at the block layer.
>>>>
>>>>    But yes block layer can still clean up when btrfs closes the
>>>>    device at the time of replace, also where in the long run, pulling
>>>>    out of the failed disk would (planned) trigger a udev notification
>>>>    into the btrfs sysfs interface and it can close the device.
>>>>
>>>>    Anything that I have missed ?
>>>>
>>>
>>> I'm more inclined to do cleanup by making udev call 'device remove',
>>> which is supposed to do all the validation checks you need to done
>>> here.
>>
>>     Validation check like what ?
> 
> OK, just realize that I was talking about what we should do upon
> device getting pulled out, in that case, validation check about raid
> profile is needed, such as can we keep the raid profile or do we need
> to degrade raid proflie, and 'device delete' can do that.

  OK.

> Although I agree with the fact that write/flush errors are critical
> ones,


> it's still too strict if it got only a few write/flush errors,
> given cable issues or timeout from some layers may also lead to those
> errors.  A compromised way is to have a threshold to give drives
> another chance.


  Fundamentally IO retries are property of the IO module to deal with it.
  It knows what type of IO error is worth a retry. If FS receives an IO
  has failed it should trust IO module has done its best effort. Adding
  additional retires at the FS layer is _not_ a good idea - it would
  affect the time to fail-over, which is very crucial for HA (high
  availability) configurations.

  Instead to deal with spurious IO error its planned to create an offline
  device state, as I wrote about it here [1].

    [1]
    https://www.spinics.net/lists/linux-btrfs/msg49643.html

  I removed offline part here to keep the changes specific to the trigger
  as in here, and it can be added later.


Thanks, Anand

> thanks,
> 
> -liubo
> 
>>
>> Thanks, Anand
>>
>>>>    Further, jfyi closing of failed device isn't related to the
>>>>    looping for device failure though.
>>>>
>>>>> We can go mark the device failed and skip it while doing read/write,
>>>>> and umount can do the cleanup work.
>>>>
>>>>    In servers a need of umount is considered as downtime, things
>>>>    shouldn't wait for umount to cleanup.
>>>>
>>>
>>> OK.
>>>
>>>>> That way we don't need a dedicated thread looping around to detect a
>>>>> rare situation.
>>>>
>>>>    I think its better to make it event based instead of thread looping,
>>>>    pls take a look..
>>>>
>>>>      [PATCH v8.1 2/2] btrfs: mark device failed for write and flush errors
>>>>
>>>
>>> Event based is good, for anything about failing disk, we would have to
>>> follow what md is doing eventually, i.e. let udev handle it.
>>>
>>> thanks,
>>> -liubo
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
