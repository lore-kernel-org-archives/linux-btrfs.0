Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:50859 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752684AbeDQLPc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 07:15:32 -0400
Subject: Re: Add udev-md-raid-safe-timeouts.rules
To: "Wol's lists" <antlists@youngman.org.uk>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, linux-lvm@redhat.com,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAJCQCtQ3r16BYYtrx9rVYauh7JeAp9omWidS4zzwxqvhU1bh+g@mail.gmail.com>
 <5425366f-f339-d6f3-26d1-d02c3ba80671@gmail.com>
 <002ab104-82ad-0187-8bd0-b0b55338ab83@youngman.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <65575762-1c14-e252-a3fd-0003ce82ca36@gmail.com>
Date: Tue, 17 Apr 2018 07:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <002ab104-82ad-0187-8bd0-b0b55338ab83@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-04-16 11:02, Wol's lists wrote:
> On 16/04/18 12:43, Austin S. Hemmelgarn wrote:
>> On 2018-04-15 21:04, Chris Murphy wrote:
>>> I just ran into this:
>>> https://github.com/neilbrown/mdadm/pull/32/commits/af1ddca7d5311dfc9ed60a5eb6497db1296f1bec 
>>>
>>>
>>> This solution is inadequate, can it be made more generic? This isn't
>>> an md specific problem, it affects Btrfs and LVM as well. And in fact
>>> raid0, and even none raid setups.
>>>
>>> There is no good reason to prevent deep recovery, which is what
>>> happens with the default command timer of 30 seconds, with this class
>>> of drive. Basically that value is going to cause data loss for the
>>> single device and also raid0 case, where the reset happens before deep
>>> recovery has a chance. And even if deep recovery fails to return user
>>> data, what we need to see is the proper error message: read error UNC,
>>> rather than a link reset message which just obfuscates the problem.
>>
>> This has been discussed at least once here before (probably more 
>> times, hard to be sure since it usually comes up as a side discussion 
>> in an only marginally related thread). 
> 
> Sorry, but where is "here"? This message is cross-posted to about three 
> lists at least ...
Oops, didn't see the extra lists listed.  In this case, discussed 
previously on the BTRFS ML.
> 
>   Last I knew, the consensus here was
>> that it needs to be changed upstream in the kernel, not by adding a 
>> udev rule because while the value is technically system policy, the 
>> default policy is brain-dead for anything but the original disks it 
>> was i9ntended for (30 seconds works perfectly fine for actual SCSI 
>> devices because they behave sanely in the face of media errors, but 
>> it's horribly inadequate for ATA devices).
>>
>> To re-iterate what I've said before on the subject:
>>
> imho (and it's probably going to be a pain to implement :-) there should 
> be a soft time-out and a hard time-out. The soft time-out should trigger 
> "drive is taking too long to respond" messages that end up in a log - so 
> that people who actually care can keep a track of this sort of thing. 
> The hard timeout should be the current set-up, where the kernel just 
> gives up.
Agreed, although as pointed out by Roger in his reply to this, it kind 
of already works this way in some cases.
