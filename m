Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:38215 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbdFWSp1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jun 2017 14:45:27 -0400
Received: by mail-it0-f53.google.com with SMTP id b205so12621882itg.1
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Jun 2017 11:45:27 -0700 (PDT)
Subject: Re: Exactly what is wrong with RAID5/6
To: =?UTF-8?Q?Micha=c5=82_Soko=c5=82owski?= <michal@sarach.com.pl>,
        linux-btrfs@vger.kernel.org
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <594D4F03.5050507@sarach.com.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6880a54f-9951-6f95-8414-6e3fa5761ea8@gmail.com>
Date: Fri, 23 Jun 2017 14:45:18 -0400
MIME-Version: 1.0
In-Reply-To: <594D4F03.5050507@sarach.com.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-06-23 13:25, Michał Sokołowski wrote:
> Hello group.
> 
> I am confused: Can somebody please confirm/deny, which RAID subsystem is
> affected? BTRFS' RAID5/6 or mdadm (Linux kernel raid) RAID 5/6 ?
All of the issues mentioned here are specific to BTRFS raid5/raid6 
profiles, with the exception of the write-hole, which inherently affects 
any raid5/raid6 system that does not specifically account for it (which 
means that it does affect MD RAID5 and RAID6 modes if you aren't using 
the journaling).
> 
> Are there some gotchas (in terms of broken reliability) when using
> kernel one?
> 
> The web is full of legends, it seems that this confusion is quite common...
Which brings up one of the reasons I really hate the choice to use the 
term 'raid' in the profile names.  At a minimum, we should have gone a 
similar route to ZFS in naming the striped parity implementations 
(RAID-B1 and RAID-B2 for example), but personally I really would have 
preferred if they were just called what they are (namely, (n,n+1) and 
(n,n+2) erasure coding for raid5 and raid6 respectively, with mirroring, 
striping and striped mirroring for raid1, raid0, and raid10), or at 
least used some naming scheme that wasn't obviously going to cause such 
issues.

> 
> On 06/21/2017 12:57 AM, waxhead wrote:
>> I am trying to piece together the actual status of the RAID5/6 bit of
>> BTRFS.
>> The wiki refer to kernel 3.19 which was released in February 2015 so I
>> assume that the information there is a tad outdated (the last update
>> on the wiki page was July 2016)
>> https://btrfs.wiki.kernel.org/index.php/RAID56
>>
>> Now there are four problems listed
>>
>> 1. Parity may be inconsistent after a crash (the "write hole")
>> Is this still true, if yes - would not this apply for RAID1 / RAID10
>> as well? How was it solved there , and why can't that be done for RAID5/6
>>
>> 2. Parity data is not checksummed
>> Why is this a problem? Does it have to do with the design of BTRFS
>> somehow?
>> Parity is after all just data, BTRFS does checksum data so what is the
>> reason this is a problem?
>>
>> 3. No support for discard? (possibly -- needs confirmation with cmason)
>> Does this matter that much really?, is there an update on this?
>>
>> 4. The algorithm uses as many devices as are available: No support for
>> a fixed-width stripe.
>> What is the plan for this one? There was patches on the mailing list
>> by the SnapRAID author to support up to 6 parity devices. Will the
>> (re?) resign of btrfs raid5/6 support a scheme that allows for
>> multiple parity devices?
>>
>> I do have a few other questions as well...
>>
>> 5. BTRFS does still (kernel 4.9) not seem to use the device ID to
>> communicate with devices.
>>
>> If you on a multi device filesystem yank out a device, for example
>> /dev/sdg and it reappear as /dev/sdx for example btrfs will still
>> happily try to write to /dev/sdg even if btrfs fi sh /mnt shows the
>> correct device ID. What is the status for getting BTRFS to properly
>> understand that a device is missing?
>>
>> 6. RAID1 needs to be able to make two copies always. E.g. if you have
>> three disks you can loose one and it should still work. What about
>> RAID10 ? If you have for example 6 disk RAID10 array, loose one disk
>> and reboots (due to #5 above). Will RAID10 recognize that the array
>> now is a 5 disk array and stripe+mirror over 2 disks (or possibly 2.5
>> disks?) instead of 3? In other words, will it work as long as it can
>> create a RAID10 profile that requires a minimum of four disks?
> 

