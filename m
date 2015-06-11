Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33415 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbbFKAEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 20:04:14 -0400
References: <2227931.EqpnWnc32X@malu-aspire-v3-771> <1631897.Efqz0Ef53G@malu-aspire-v3-771> <5577EB6C.6090405@oracle.com> <4768404.UTQo4H2Sip@term0>
In-Reply-To: <4768404.UTQo4H2Sip@term0>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <FA615B68-27BB-4FFD-A1C6-AEC6027C476C@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: rw-mount-problem after raid1-failure
Date: Thu, 11 Jun 2015 08:04:04 +0800
To: Martin <develop@imagmbh.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> On 10 Jun 2015, at 5:35 pm, Martin <develop@imagmbh.de> wrote:
> 
> Hello Anand,
> 
> the failed disk was removed. My procedure was the following:
> 
> - I found some write errors in the kernel log, so
> - I shutdown the system
> - I removed the failed disk
> - I powered on the system
> - I mounted the remaining disk degraded,rw (works OK)
> - the system works an and was rebooted some times, mounting degraded,rw works
> - suddentlym mounting degraded,rw stops working and only degraded,ro works.

any logs to say why. ?
Or
If these (above) stages are reproducible, could you fetch them afresh?

Thanks Anand

> Thanks, Martin
> 
> 
> Am Mittwoch, 10. Juni 2015, 15:46:52 schrieb Anand Jain:
>> On 06/10/2015 02:58 PM, Martin wrote:
>>> Hello Anand,
>>> 
>>> the
>>> 
>>>> mount -o degraded <good-disk> <-- this should work
>>> 
>>> is my problem. The fist times it works but suddently, after a reboot, it
>>> fails with message "BTRFS: too many missing devices, writeable mount is
>>> not allowed" in kernel log.
>> 
>>  the failed(ing) disk is it still physically in the system ?
>>  when btrfs finds EIO on the intermittently failing disk,
>>  ro-mode kicks in, (there are some opportunity for fixes which
>>  I am trying). To recover, the approach is to make the failing
>>  disk a missing disk instead, by pulling out the failing disk
>>  from the system and boot. When system finds disk missing
>>  (not EIO rather) it should mount rw,degraded (from the VM part
>>  at least) and then replace (with a new disk) should work.
>> 
>> Thanks, Anand
>> 
>>> "btrfs fi show /backup2" shows:
>>> Label: none  uuid: 6d755db5-f8bb-494e-9bdc-cf524ff99512
>>> 
>>>    Total devices 2 FS bytes used 3.50TiB
>>>    devid    4 size 7.19TiB used 4.02TiB path /dev/sdb2
>>>    *** Some devices missing
>>> 
>>> I suppose there is a "marker", telling the system only to mount in
>>> ro-mode?
>>> 
>>> Due to the ro-mount I can't replace the missing one because all the btrfs-
>>> commands need rw-access ...
>>> 
>>> Martin
>>> 
>>> Am Mittwoch, 10. Juni 2015, 14:38:38 schrieb Anand Jain:
>>>> Ah thanks David. So its 2 disks RAID1.
>>>> 
>>>> Martin,
>>>> 
>>>>   disk pool error handle is primitive as of now. readonly is the only
>>>>   action it would take. rest of recovery action is manual. thats
>>>>   unacceptable in a data center solutions. I don't recommend btrfs VM
>>>>   productions yet. But we are working to get that to a complete VM.
>>>> 
>>>>   For now, for your pool recovery: pls try this.
>>>> 
>>>>      - After reboot.
>>>>      - modunload and modload (so that kernel devlist is empty)
>>>>      - mount -o degraded <good-disk> <-- this should work.
>>>>      - btrfs fi show -m <-- Should show missing if you don't let me
>>>>      know.
>>>>      - Do a replace of the missing disk without reading the source disk.
>>>> 
>>>> Good luck.
>>>> 
>>>> Thanks, Anand
>>>> 
>>>>> On 06/10/2015 11:58 AM, Duncan wrote:
>>>>> Anand Jain posted on Wed, 10 Jun 2015 09:19:37 +0800 as excerpted:
>>>>>>> On 06/09/2015 01:10 AM, Martin wrote:
>>>>>>> Hello!
>>>>>>> 
>>>>>>> I have a raid1-btrfs-system (Kernel 3.19.0-18-generic, Ubuntu Vivid
>>>>>>> Vervet, btrfs-tools 3.17-1.1). One disk failed some days ago. I could
>>>>>>> remount the remaining one with "-o degraded". After one day and some
>>>>>>> write-operations (with no errrors) I had to reboot the system. And now
>>>>>>> I can not mount "rw" anymore, only "-o degraded,ro" is possible.
>>>>>>> 
>>>>>>> In the kernel log I found BTRFS: too many missing devices, writeable
>>>>>>> mount is not allowed.
>>>>>>> 
>>>>>>> I read about https://bugzilla.kernel.org/show_bug.cgi?id=60594 but I
>>>>>>> did no conversion to a single drive.
>>>>>>> 
>>>>>>> How can I mount the disk "rw" to remove the "missing" drive and add a
>>>>>>> new one?
>>>>>>> Because there are many snapshots of the filesystem, copying the system
>>>>>>> would be only the last alternative ;-)
>>>>>> 
>>>>>> How many disks you had in the RAID1. How many are failed ?
>>>>> 
>>>>> The answer is (a bit indirectly) in what you quoted.  Repeating:
>>>>>>> One disk failed[.] I could remount the remaining one[.]
>>>>> 
>>>>> So it was a two-device raid1, one failed device, one remaining,
>>>>> unfailed.
>>>> 
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
