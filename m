Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44797 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932238AbeF3Gf5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Jun 2018 02:35:57 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fZ9S1-00010O-To
        for linux-btrfs@vger.kernel.org; Sat, 30 Jun 2018 08:33:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
Date: Sat, 30 Jun 2018 06:33:35 +0000 (UTC)
Message-ID: <pan$d561f$1f780d41$c875436f$9e055ce0@cox.net>
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
        <9bbde3a8-2498-a538-5744-c857f5a57947@oracle.com>
        <CAJCQCtSuKpcn2Or3LiCYqeFMFFoRU09BFQE_n8FAhQ2Vo+83PA@mail.gmail.com>
        <93a74ac2-c271-accd-d0c7-4822c0f75f80@libero.it>
        <CAJCQCtRUgoQPNwcM54hXnNSqcm5+0d9Ks1aWw_2VYChMxWWnEg@mail.gmail.com>
        <CA+X5Wn5JdervhGob5MGWRtYLt+Av5nYhTkKdAUQFgcxPUdMAsA@mail.gmail.com>
        <a6210485-1d7d-2543-8a1f-f43ba7eda34e@gmail.com>
        <CA+X5Wn7jVZS5USHnmj1SrHh87V1O6vgzRcLM64di4ALc81hjmQ@mail.gmail.com>
        <f76a93ba-05c8-967f-d7c0-8fdc0a618a7e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Fri, 29 Jun 2018 14:31:04 -0400 as
excerpted:

> On 2018-06-29 13:58, james harvey wrote:
>> On Fri, Jun 29, 2018 at 1:09 PM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>> On 2018-06-29 11:15, james harvey wrote:
>>>>
>>>> On Thu, Jun 28, 2018 at 6:27 PM, Chris Murphy
>>>> <lists@colorremedies.com>
>>>> wrote:
>>>>>
>>>>> And an open question I have about scrub is weather it only ever is
>>>>> checking csums, meaning nodatacow files are never scrubbed, or if
>>>>> the copies are at least compared to each other?
>>>>
>>>>
>>>> Scrub never looks at nodatacow files.  It does not compare the copies
>>>> to each other.
>>>>
>>>> Qu submitted a patch to make check compare the copies:
>>>> https://patchwork.kernel.org/patch/10434509/
>>>>
>>>> This hasn't been added to btrfs-progs git yet.
>>>>
>>>> IMO, I think the offline check should look at nodatacow copies like
>>>> this, but I still think this also needs to be added to scrub.  In the
>>>> patch thread, I discuss my reasons why.  In brief: online scanning;
>>>> this goes along with user's expectation of scrub ensuring mirrored
>>>> data integrity; and recommendations to setup scrub on periodic basis
>>>> to me means it's the place to put it.
>>>
>>> That said, it can't sanely fix things if there is a mismatch. At
>>> least,
>>> not unless BTRFS gets proper generational tracking to handle
>>> temporarily missing devices.  As of right now, sanely fixing things
>>> requires significant manual intervention, as you have to bypass the
>>> device read selection algorithm to be able to look at the state of the
>>> individual copies so that you can pick one to use and forcibly rewrite
>>> the whole file by hand.
>> 
>> Absolutely.  User would need to use manual intervention as you
>> describe, or restore the single file(s) from backup.  But, it's a good
>> opportunity to tell the user they had partial data corruption, even if
>> it can't be auto-fixed.  Otherwise they get intermittent data
>> corruption, depending on which copies are read.

> The thing is though, as things stand right now, you need to manually
> edit the data on-disk directly or restore the file from a backup to fix
> the file.  While it's technically true that you can manually repair this
> type of thing, both of the cases for doing it without those patches I
> mentioned, it's functionally impossible for a regular user to do it
> without potentially losing some data.

[Usual backups rant, user vs. admin variant, nowcow/tmpfs edition.  
Regulars can skip as the rest is already predicted from past posts, for 
them. =;^]

"Regular user"?  

"Regular users" don't need to bother with this level of detail.  They 
simply get their "admin" to do it, even if that "admin" is their kid, or 
the kid from next door that's good with computers, or the geek squad (aka 
nsa-agent-squad) guy/gal, doing it... or telling them to install "a real 
OS", meaning whatever MS/Apple/Google something that they know how to 
deal with.

If the "user" is dealing with setting nocow, choosing btrfs in the first 
place, etc, then they're _not_ a "regular user" by definition, they're 
already an admin.

And as any admin learns rather quickly, the value of data is defined by 
the number of backups it's worth having of that data.

Which means it's not a problem.  Either the data had a backup and it's 
(reasonably) trivial to restore the data from that backup, or the data 
was defined by lack of having that backup as of only trivial value, so 
low as to not be worth the time/trouble/resources necessary to make that 
backup in the first place.

Which of course means what was defined as of most value, either the data 
of there was a backup, or the time/trouble/resources that would have gone 
into creating it if not, is *always* saved.

(And of course the same goes for "I had a backup, but it's old", except 
in this case it's the value of the data delta between the backup and 
current.  As soon as it's worth more than the time/trouble/hassle of 
updating the backup, it will by definition be updated.  Not having a 
newer backup available thus simply means the value of the data that 
changed between the last backup and current was simply not enough to 
justify updating the backup, and again, what was of most value is 
*always* saved, either the data, or the time that would have otherwise 
gone into making the newer backup.)

Because while a "regular user" may not know it because it's not his /job/ 
to know it, if there's anything an admin knows *well* it's that the 
working copy of data **WILL** be damaged.  It's not a matter of if, but 
of when, and of whether it'll be a fat-finger mistake, or a hardware or 
software failure, or wetware (theft, ransomware, etc), or wetware (flood, 
fire and the water that put it out damage, etc), tho none of that 
actually matters after all, because in the end, the only thing that 
matters was how the value of that data was defined by the number of 
backups made of it, and how quickly and conveniently at least one of 
those backups can be retrieved and restored.


Meanwhile, an admin worth the label will also know the relative risk 
associated with various options they might use, including nocow, and 
knowing that downgrades the stability rating of the storage approximately 
to the same degree that raid0 does, they'll already be aware that in such 
a case the working copy can only be defined as "throw-away" level in case 
of problems in the first place, and will thus not even consider their 
working copy to be a permanent copy at all, just a temporary garbage 
copy, only slightly more reliable than one stored on tmpfs, and will thus 
consider the first backup thereof the true working copy, with an 
additional level of backup beyond what they'd normally have thrown in to 
account for that fact.

So in case of problems people can simply restore nocow files from a near-
line stable working copy, much as they'd do after reboot or a umount/
remount cycle for a file stored in tmpfs.  And if they didn't have even a 
stable working copy let alone a backup... well, much like that file in 
tmpfs, what did they expect?  They *really* defined that data as of no 
more than trivial value, didn't they?


All that said, making the NOCOW warning labels a bit more bold print 
couldn't hurt; and making scrub in the nocow case at least compare copies 
and report differences, simply makes it easier for people to know they 
need to reach for that near-line stable working copy, or mkfs and start 
from scratch if they defined the data value as not worth the trouble of 
(in this case) even a stable working copy, let alone a backup, so that'd 
be a good thing too. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

