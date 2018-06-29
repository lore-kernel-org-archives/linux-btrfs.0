Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36450 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934268AbeF2SbI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 14:31:08 -0400
Received: by mail-it0-f68.google.com with SMTP id j135-v6so4157896itj.1
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 11:31:08 -0700 (PDT)
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: james harvey <jamespharvey20@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>,
        Anand Jain <anand.jain@oracle.com>, Remi Gauvin <remi@georgianit.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <9bbde3a8-2498-a538-5744-c857f5a57947@oracle.com>
 <CAJCQCtSuKpcn2Or3LiCYqeFMFFoRU09BFQE_n8FAhQ2Vo+83PA@mail.gmail.com>
 <93a74ac2-c271-accd-d0c7-4822c0f75f80@libero.it>
 <CAJCQCtRUgoQPNwcM54hXnNSqcm5+0d9Ks1aWw_2VYChMxWWnEg@mail.gmail.com>
 <CA+X5Wn5JdervhGob5MGWRtYLt+Av5nYhTkKdAUQFgcxPUdMAsA@mail.gmail.com>
 <a6210485-1d7d-2543-8a1f-f43ba7eda34e@gmail.com>
 <CA+X5Wn7jVZS5USHnmj1SrHh87V1O6vgzRcLM64di4ALc81hjmQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f76a93ba-05c8-967f-d7c0-8fdc0a618a7e@gmail.com>
Date: Fri, 29 Jun 2018 14:31:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn7jVZS5USHnmj1SrHh87V1O6vgzRcLM64di4ALc81hjmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-06-29 13:58, james harvey wrote:
> On Fri, Jun 29, 2018 at 1:09 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2018-06-29 11:15, james harvey wrote:
>>>
>>> On Thu, Jun 28, 2018 at 6:27 PM, Chris Murphy <lists@colorremedies.com>
>>> wrote:
>>>>
>>>> And an open question I have about scrub is weather it only ever is
>>>> checking csums, meaning nodatacow files are never scrubbed, or if the
>>>> copies are at least compared to each other?
>>>
>>>
>>> Scrub never looks at nodatacow files.  It does not compare the copies
>>> to each other.
>>>
>>> Qu submitted a patch to make check compare the copies:
>>> https://patchwork.kernel.org/patch/10434509/
>>>
>>> This hasn't been added to btrfs-progs git yet.
>>>
>>> IMO, I think the offline check should look at nodatacow copies like
>>> this, but I still think this also needs to be added to scrub.  In the
>>> patch thread, I discuss my reasons why.  In brief: online scanning;
>>> this goes along with user's expectation of scrub ensuring mirrored
>>> data integrity; and recommendations to setup scrub on periodic basis
>>> to me means it's the place to put it.
>>
>> That said, it can't sanely fix things if there is a mismatch. At least, not
>> unless BTRFS gets proper generational tracking to handle temporarily missing
>> devices.  As of right now, sanely fixing things requires significant manual
>> intervention, as you have to bypass the device read selection algorithm to
>> be able to look at the state of the individual copies so that you can pick
>> one to use and forcibly rewrite the whole file by hand.
> 
> Absolutely.  User would need to use manual intervention as you
> describe, or restore the single file(s) from backup.  But, it's a good
> opportunity to tell the user they had partial data corruption, even if
> it can't be auto-fixed.  Otherwise they get intermittent data
> corruption, depending on which copies are read.
The thing is though, as things stand right now, you need to manually 
edit the data on-disk directly or restore the file from a backup to fix 
the file.  While it's technically true that you can manually repair this 
type of thing, both of the cases for doing it without those patches I 
mentioned, it's functionally impossible for a regular user to do it 
without potentially losing some data.

Unless that changes, scrub telling you it's corrupt is not going to help 
much aside from making sure you don't make things worse by trying to use 
it.  Given this, it would make sense to have a (disabled by default) 
option to have scrub repair it by just using the newer or older copy of 
the data.  That would require classic RAID generational tracking though, 
which BTRFS doesn't have yet.

>> A while back, Anand Jain posted some patches that would let you select a
>> particular device to direct all reads to via a mount option, but I don't
>> think they ever got merged.  That would have made manual recovery in cases
>> like this exponentially easier (mount read-only with one device selected,
>> copy the file out somewhere, remount read-only with the other device, drop
>> caches, copy the file out again, compare and reconcile the two copies, then
>> remount the volume writable and write out the repaired file).

