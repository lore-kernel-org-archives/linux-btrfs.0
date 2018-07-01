Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:41423 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbeGAEyy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2018 00:54:54 -0400
Received: by mail-lf0-f65.google.com with SMTP id y127-v6so9551557lfc.8
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jun 2018 21:54:53 -0700 (PDT)
Subject: Re: Incremental send/receive broken after snapshot restore
To: Marc MERLIN <marc@merlins.org>,
        Hannes Schweizer <schweizer.hannes@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAOfGOYyT2F-6jtKgpgm6iX5aK-kP1Ryuz_rcTFs=s05_FeAPoQ@mail.gmail.com>
 <1115fcb3-4e07-6fd9-17cb-56a8ba46a7ab@gmail.com>
 <CAOfGOYyFcQ5gN7z=4zEaGH0VMVUuFE5qiGwgF+c14FU228Y3iQ@mail.gmail.com>
 <0097cdf0-143e-c27a-29af-077f61928b20@gmail.com>
 <CAOfGOYwz=gkSbED7yy0RwiCCJb8L0qcj+5ZhDxUXQ1FUv3CvNw@mail.gmail.com>
 <b3c03ca2-0e9d-7e1b-2d64-0dfb855c2cbf@gmail.com>
 <0747393d-b9a8-bc3a-05ed-0c394d4e28cd@gmail.com>
 <CAOfGOYzmg4rWjJooKN=AmPM=BE=DbYXHc0z_GnoWuJXKLGQsaw@mail.gmail.com>
 <20180630231606.GC5567@merlins.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <15830b78-c5bd-2e07-ebdc-e2ad174204f0@gmail.com>
Date: Sun, 1 Jul 2018 07:54:50 +0300
MIME-Version: 1.0
In-Reply-To: <20180630231606.GC5567@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

01.07.2018 02:16, Marc MERLIN пишет:
> Sorry that I missed the beginning of this discussion, but I think this is
> what I documented here after hitting hte same problem:

This is similar, yes. IIRC you had different starting point though. Here
it should have been possible to use only standard documented tools
without need of low level surgery if done right.

> http://marc.merlins.org/perso/btrfs/post_2018-03-09_Btrfs-Tips_-Rescuing-A-Btrfs-Send-Receive-Relationship.html
> 

M-m-m ... statement "because the source had a Parent UUID value too, I
was actually supposed to set Received UUID on the destination to it" is
entirely off mark nor does it even match subsequent command. You
probably meant to say "because the source had a *Received* UUID value
too, I was actually supposed to set Received UUID on the destination to
it". That is correct. And that is what I meant above - received_uuid is
misnomer, it is actually used as common data set identifier. Two
subvolumes with the same received_uuid are presumed to have identical
content.

Which makes the very idea of being able to freely manipulate it rather
questionable.

P.S. of course "parent" is also highly ambiguous in btrfs world. We
really need to come up with acceptable terminology to disambiguate tree
parent, snapshot parent and replication parent. The latter should
probably better be called "base snapshot" (NetApp calls it "common
snapshot"); error message "Could not find base snapshot matching UUID
xxx" would be far less ambiguous.

> Marc
> 
> On Sun, Jul 01, 2018 at 01:03:37AM +0200, Hannes Schweizer wrote:
>> On Sat, Jun 30, 2018 at 10:02 PM Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>>>
>>> 30.06.2018 21:49, Andrei Borzenkov пишет:
>>>> 30.06.2018 20:49, Hannes Schweizer пишет:
>>> ...
>>>>>
>>>>> I've tested a few restore methods beforehand, and simply creating a
>>>>> writeable clone from the restored snapshot does not work for me, eg:
>>>>> # create some source snapshots
>>>>> btrfs sub create test_root
>>>>> btrfs sub snap -r test_root test_snap1
>>>>> btrfs sub snap -r test_root test_snap2
>>>>>
>>>>> # send a full and incremental backup to external disk
>>>>> btrfs send test_snap2 | btrfs receive /run/media/schweizer/external
>>>>> btrfs sub snap -r test_root test_snap3
>>>>> btrfs send -c test_snap2 test_snap3 | btrfs receive
>>>>> /run/media/schweizer/external
>>>>>
>>>>> # simulate disappearing source
>>>>> btrfs sub del test_*
>>>>>
>>>>> # restore full snapshot from external disk
>>>>> btrfs send /run/media/schweizer/external/test_snap3 | btrfs receive .
>>>>>
>>>>> # create writeable clone
>>>>> btrfs sub snap test_snap3 test_root
>>>>>
>>>>> # try to continue with backup scheme from source to external
>>>>> btrfs sub snap -r test_root test_snap4
>>>>>
>>>>> # this fails!!
>>>>> btrfs send -c test_snap3 test_snap4 | btrfs receive
>>>>> /run/media/schweizer/external
>>>>> At subvol test_snap4
>>>>> ERROR: parent determination failed for 2047
>>>>> ERROR: empty stream is not considered valid
>>>>>
>>>>
>>>> Yes, that's expected. Incremental stream always needs valid parent -
>>>> this will be cloned on destination and incremental changes applied to
>>>> it. "-c" option is just additional sugar on top of it which might reduce
>>>> size of stream, but in this case (i.e. without "-p") it also attempts to
>>>> guess parent subvolume for test_snap4 and this fails because test_snap3
>>>> and test_snap4 do not have common parent so test_snap3 is rejected as
>>>> valid parent snapshot. You can restart incremental-forever chain by
>>>> using explicit "-p" instead:
>>>>
>>>> btrfs send -p test_snap3 test_snap4
>>>>
>>>> Subsequent snapshots (test_snap5 etc) will all have common parent with
>>>> immediate predecessor again so "-c" will work.
>>>>
>>>> Note that technically "btrfs send" with single "-c" option is entirely
>>>> equivalent to "btrfs -p". Using "-p" would have avoided this issue. :)
>>>> Although this implicit check for common parent may be considered a good
>>>> thing in this case.
>>>>
>>>> P.S. looking at the above, it probably needs to be in manual page for
>>>> btrfs-send. It took me quite some time to actually understand the
>>>> meaning of "-p" and "-c" and behavior if they are present.
>>>>
>>> ...
>>>>>
>>>>> Is there some way to reset the received_uuid of the following snapshot
>>>>> on online?
>>>>> ID 258 gen 13742 top level 5 parent_uuid -
>>>>>        received_uuid 6c683d90-44f2-ad48-bb84-e9f241800179 uuid
>>>>> 46db1185-3c3e-194e-8d19-7456e532b2f3 path diablo
>>>>>
>>>>
>>>> There is no "official" tool but this question came up quite often.
>>>> Search this list, I believe recently one-liner using python-btrfs was
>>>> posted. Note that also patch that removes received_uuid when "ro"
>>>> propery is removed was suggested, hopefully it will be merged at some
>>>> point. Still I personally consider ability to flip read-only property
>>>> the very bad thing that should have never been exposed in the first place.
>>>>
>>>
>>> Note that if you remove received_uuid (explicitly or - in the future -
>>> implicitly) you will not be able to restart incremental send anymore.
>>> Without received_uuid there will be no way to match source test_snap3
>>> with destination test_snap3. So you *must* preserve it and start with
>>> writable clone.
>>>
>>> received_uuid is misnomer. I wish it would be named "content_uuid" or
>>> "snap_uuid" with semantic
>>>
>>> 1. When read-only snapshot of writable volume is created, content_uuid
>>> is initialized
>>>
>>> 2. Read-only snapshot of read-only snapshot inherits content_uuid
>>>
>>> 3. destination of "btrfs send" inherits content_uuid
>>>
>>> 4. writable snapshot of read-only snapshot clears content_uuid
>>>
>>> 5. clearing read-only property clears content_uuid
>>>
>>> This would make it more straightforward to cascade and restart
>>> replication by having single subvolume property to match against.
>>
>> Indeed, the current terminology is a bit confusing, and the patch
>> removing the received_uuid when manually switching ro to false should
>> definitely be merged. As recommended, I'll simply create a writeable
>> clone of the restored snapshot and use -p instead of -c when restoring
>> again (which kind of snapshot relations are accepted for incremental
>> send/receive needs better documentation)
>>
>> Fortunately, with all your hints regarding received_uuid I was able to
>> successfully restart the incremental-chain WITHOUT restarting from
>> scratch:
>> # replace incorrectly propagated received_uuid on destination with
>> actual uuid of source snapshot
>> btrfs property set
>> /run/media/schweizer/external/diablo_external.2018-06-24T19-37-39 ro
>> false
>> set_received_uuid.py de9421c5-d160-2949-bf09-613949b4611c 1089 0.0
>> /run/media/schweizer/external/diablo_external.2018-06-24T19-37-39
>> btrfs property set
>> /run/media/schweizer/external/diablo_external.2018-06-24T19-37-39 ro
>> true
>>
>> # remove incorrectly propagated received_uuid on source
>> btrfs property set
>> /mnt/work/backup/online/diablo_external.2018-06-24T19-37-39 ro false
>> set_received_uuid.py 00000000-0000-0000-0000-000000000000 8572 0.0
>> /mnt/work/backup/online/diablo_external.2018-06-24T19-37-39
>> btrfs property set
>> /mnt/work/backup/online/diablo_external.2018-06-24T19-37-39 ro true
>>
>> # works now!
>> btrfs sub snap -r /mnt/work/backup/online/diablo
>> /mnt/work/backup/online/diablo_external.2018-07-01T00-19-46
>> btrfs send -q -p
>> /mnt/work/backup/online/diablo_external.2018-06-24T19-37-39
>> /mnt/work/backup/online/diablo_external.2018-07-01T00-19-46 | btrfs
>> receive /run/media/schweizer/external
>>
>> Time will tell whether the incremental-chain is really consistent, but
>> I suppose all the changes in the heavily used filesystem should've
>> already caused massive unlink/whatever errors otherwise.
>>
>> Thanks a lot!
>> You've really saved me hours by not having to restart the source from scratch.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

