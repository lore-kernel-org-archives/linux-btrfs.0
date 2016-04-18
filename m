Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:35812 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbcDRMTl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 08:19:41 -0400
Received: by mail-ig0-f195.google.com with SMTP id fn8so10656558igb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 05:19:41 -0700 (PDT)
Subject: Re: Missing device handling
To: Chris Murphy <lists@colorremedies.com>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
 <CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
 <57064231.2070201@gmail.com>
 <CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
 <5707961D.6000803@gmail.com>
 <CAJCQCtT1Pt__k+aYqSjNPLmcgpH7F4N+ueJ3b+z+aVTYTYtGEg@mail.gmail.com>
 <57080530.7030805@gmail.com> <20160408195259.GA23661@jeknote.loshitsa1.net>
 <pan$b9ec0$9af87166$9880d70a$1ad778e5@cox.net> <570B8B4F.3070805@gmail.com>
 <CAJCQCtQZaqip8jJ3uED61WMB2aSaXECh1bGqze0jB1_ohJS3ow@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5714D0A3.1090807@gmail.com>
Date: Mon, 18 Apr 2016 08:18:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQZaqip8jJ3uED61WMB2aSaXECh1bGqze0jB1_ohJS3ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-17 20:55, Chris Murphy wrote:
> On Mon, Apr 11, 2016 at 5:32 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-04-09 03:24, Duncan wrote:
>>>
>>> Yauhen Kharuzhy posted on Fri, 08 Apr 2016 22:53:00 +0300 as excerpted:
>>>
>>>> On Fri, Apr 08, 2016 at 03:23:28PM -0400, Austin S. Hemmelgarn wrote:
>>>>>
>>>>>
>>>>> I would personally suggest adding a per-filesystem node in sysfs to
>>>>> handle both 2 and 5. Having it open tells BTRFS to not automatically
>>>>> attempt countermeasures when degraded, select/epoll on it will return
>>>>> when state changes, reads will return (at minimum): what devices
>>>>> comprise the FS, per disk state (is it working, failed, missing, a
>>>>> hot-spare, etc), and what effective redundancy we have (how many
>>>>> devices we can lose and still be mountable, so 1 for raid1, raid10, and
>>>>> raid5, 2 for raid6, and 0 for raid0/single/dup, possibly higher for
>>>>> n-way replication (n-1), n-order parity (n), or erasure coding). This
>>>>> would make it trivial to write a daemon to monitor the filesystem,
>>>>> react when something happens, and handle all the policy decisions.
>>>>
>>>>
>>>> Hm, good proposal. Personally I tried to use uevents for this but they
>>>> cause locking troubles, and I didn't continue this attempt.
>>>
>>>
>>> Except that... in sysfs (unlike proc) there's a rather strictly enforced
>>> rule of one property per file.
>>
>> Good point, I had forgotten about this.
>
> I just ran across this:
> https://www.kernel.org/doc/Documentation/block/stat.txt
>
> Q. Why are there multiple statistics in a single file?  Doesn't sysfs
>     normally contain a single value per file?
> A. By having a single file, the kernel can guarantee that the statistics
>     represent a consistent snapshot of the state of the device.
>
> So there might be an exception. I'm using a zram device as a sprout
> for a Btrfs seed. And this is what I'm seeing:
>
> [root@f23m 0]# cat /sys/block/zram0/stat
>     64258        0   514064       19    19949        0   159592
> 214        0      233      233
>
> Anyway there might be a plausible exception, if there's a good reason,
> for the one property per file rule.
Part of the requirement for that though is that we have to provide a 
consistent set of info.  IOW, we would probably need to use something 
like RCU or locks to handle the data so we could get a consistent 
snapshot of the state.

