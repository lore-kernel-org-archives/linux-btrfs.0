Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37247 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751523AbeF3StN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Jun 2018 14:49:13 -0400
Received: by mail-lj1-f193.google.com with SMTP id c11-v6so9696429lja.4
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jun 2018 11:49:12 -0700 (PDT)
Subject: Re: Incremental send/receive broken after snapshot restore
To: Hannes Schweizer <schweizer.hannes@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAOfGOYyT2F-6jtKgpgm6iX5aK-kP1Ryuz_rcTFs=s05_FeAPoQ@mail.gmail.com>
 <1115fcb3-4e07-6fd9-17cb-56a8ba46a7ab@gmail.com>
 <CAOfGOYyFcQ5gN7z=4zEaGH0VMVUuFE5qiGwgF+c14FU228Y3iQ@mail.gmail.com>
 <0097cdf0-143e-c27a-29af-077f61928b20@gmail.com>
 <CAOfGOYwz=gkSbED7yy0RwiCCJb8L0qcj+5ZhDxUXQ1FUv3CvNw@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <b3c03ca2-0e9d-7e1b-2d64-0dfb855c2cbf@gmail.com>
Date: Sat, 30 Jun 2018 21:49:08 +0300
MIME-Version: 1.0
In-Reply-To: <CAOfGOYwz=gkSbED7yy0RwiCCJb8L0qcj+5ZhDxUXQ1FUv3CvNw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

30.06.2018 20:49, Hannes Schweizer пишет:
> On Sat, Jun 30, 2018 at 8:24 AM Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>>
>> Do not reply privately to mails on list.
>>
>> 29.06.2018 22:10, Hannes Schweizer пишет:
>>> On Fri, Jun 29, 2018 at 7:44 PM Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>>>>
>>>> 28.06.2018 23:09, Hannes Schweizer пишет:
>>>>> Hi,
>>>>>
>>>>> Here's my environment:
>>>>> Linux diablo 4.17.0-gentoo #5 SMP Mon Jun 25 00:26:55 CEST 2018 x86_64
>>>>> Intel(R) Core(TM) i5 CPU 760 @ 2.80GHz GenuineIntel GNU/Linux
>>>>> btrfs-progs v4.17
>>>>>
>>>>> Label: 'online'  uuid: e4dc6617-b7ed-4dfb-84a6-26e3952c8390
>>>>>         Total devices 2 FS bytes used 3.16TiB
>>>>>         devid    1 size 1.82TiB used 1.58TiB path /dev/mapper/online0
>>>>>         devid    2 size 1.82TiB used 1.58TiB path /dev/mapper/online1
>>>>> Data, RAID0: total=3.16TiB, used=3.15TiB
>>>>> System, RAID0: total=16.00MiB, used=240.00KiB
>>>>> Metadata, RAID0: total=7.00GiB, used=4.91GiB
>>>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>>>
>>>>> Label: 'offline'  uuid: 5b449116-93e5-473e-aaf5-bf3097b14f29
>>>>>         Total devices 2 FS bytes used 3.52TiB
>>>>>         devid    1 size 5.46TiB used 3.53TiB path /dev/mapper/offline0
>>>>>         devid    2 size 5.46TiB used 3.53TiB path /dev/mapper/offline1
>>>>> Data, RAID1: total=3.52TiB, used=3.52TiB
>>>>> System, RAID1: total=8.00MiB, used=512.00KiB
>>>>> Metadata, RAID1: total=6.00GiB, used=5.11GiB
>>>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>>>
>>>>> Label: 'external'  uuid: 8bf13621-01f0-4f09-95c7-2c157d3087d0
>>>>>         Total devices 1 FS bytes used 3.65TiB
>>>>>         devid    1 size 5.46TiB used 3.66TiB path
>>>>> /dev/mapper/luks-3c196e96-d46c-4a9c-9583-b79c707678fc
>>>>> Data, single: total=3.64TiB, used=3.64TiB
>>>>> System, DUP: total=32.00MiB, used=448.00KiB
>>>>> Metadata, DUP: total=11.00GiB, used=9.72GiB
>>>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>>>
>>>>>
>>>>> The following automatic backup scheme is in place:
>>>>> hourly:
>>>>> btrfs sub snap -r online/root online/root.<date>
>>>>>
>>>>> daily:
>>>>> btrfs sub snap -r online/root online/root.<new_offline_reference>
>>>>> btrfs send -c online/root.<old_offline_reference>
>>>>> online/root.<new_offline_reference> | btrfs receive offline
>>>>> btrfs sub del -c online/root.<old_offline_reference>
>>>>>
>>>>> monthly:
>>>>> btrfs sub snap -r online/root online/root.<new_external_reference>
>>>>> btrfs send -c online/root.<old_external_reference>
>>>>> online/root.<new_external_reference> | btrfs receive external
>>>>> btrfs sub del -c online/root.<old_external_reference>
>>>>>
>>>>> Now here are the commands leading up to my problem:
>>>>> After the online filesystem suddenly went ro, and btrfs check showed
>>>>> massive problems, I decided to start the online array from scratch:
>>>>> 1: mkfs.btrfs -f -d raid0 -m raid0 -L "online" /dev/mapper/online0
>>>>> /dev/mapper/online1
>>>>>
>>>>> As you can see from the backup commands above, the snapshots of
>>>>> offline and external are not related, so in order to at least keep the
>>>>> extensive backlog of the external snapshot set (including all
>>>>> reflinks), I decided to restore the latest snapshot from external.
>>>>> 2: btrfs send external/root.<external_reference> | btrfs receive online
>>>>>
>>>>> I wanted to ensure I can restart the incremental backup flow from
>>>>> online to external, so I did this
>>>>> 3: mv online/root.<external_reference> online/root
>>>>> 4: btrfs sub snap -r online/root online/root.<external_reference>
>>>>> 5: btrfs property set online/root ro false
>>>>>
>>>>> Now, I naively expected a simple restart of my automatic backups for
>>>>> external should work.
>>>>> However after running
>>>>> 6: btrfs sub snap -r online/root online/root.<new_external_reference>
>>>>> 7: btrfs send -c online/root.<old_external_reference>
>>>>> online/root.<new_external_reference> | btrfs receive external
>>>>
>>>> You just recreated your "online" filesystem from scratch. Where
>>>> "old_external_reference" comes from? You did not show steps used to
>>>> create it.
>>>>
>>>>> I see the following error:
>>>>> ERROR: unlink root/.ssh/agent-diablo-_dev_pts_3 failed. No such file
>>>>> or directory
>>>>>
>>>>> Which is unfortunate, but the second problem actually encouraged me to
>>>>> post this message.
>>>>> As planned, I had to start the offline array from scratch as well,
>>>>> because I no longer had any reference snapshot for incremental backups
>>>>> on other devices:
>>>>> 8: mkfs.btrfs -f -d raid1 -m raid1 -L "offline" /dev/mapper/offline0
>>>>> /dev/mapper/offline1
>>>>>
>>>>> However restarting the automatic daily backup flow bails out with a
>>>>> similar error, although no potentially problematic previous
>>>>> incremental snapshots should be involved here!
>>>>> ERROR: unlink o925031-987-0/2139527549 failed. No such file or directory
>>>>>
>>>>
>>>> Again - before you can *re*start incremental-forever sequence you need
>>>> initial full copy. How exactly did you restart it if no snapshots exist
>>>> either on source or on destination?
>>>
>>> Thanks for your help regarding this issue!
>>>
>>> Before the online crash, I've used the following online -> external
>>> backup scheme:
>>> btrfs sub snap -r online/root online/root.<new_external_reference>
>>> btrfs send -c online/root.<old_external_reference>
>>> online/root.<new_external_reference> | btrfs receive external
>>> btrfs sub del -c online/root.<old_external_reference>
>>>
>>> By sending the existing snapshot from external to online (basically a
>>> full copy of external/old_external_reference to online/root), it
>>> should have been possible to restart the monthly online -> external
>>> backup scheme, right?
>>>
>>
>> You did not answer any of my questions which makes it impossible to
>> actually try to reproduce or understand it. In particular, it is not
>> even clear whether problem happens immediately or after some time.
>>
>> Educated guess is that the problem is due to stuck received_uuid on
>> source which now propagates into every snapshot and makes receive match
>> wrong subvolume. You should never reset read-only flag, rather create
>> new writable clone leaving original read-only snapshot untouched.
>>
>> Showing output of "btrfs sub li -qRu" on both sides would be helpful.
> 
> Sry for being too vague...
> 
> I've tested a few restore methods beforehand, and simply creating a
> writeable clone from the restored snapshot does not work for me, eg:
> # create some source snapshots
> btrfs sub create test_root
> btrfs sub snap -r test_root test_snap1
> btrfs sub snap -r test_root test_snap2
> 
> # send a full and incremental backup to external disk
> btrfs send test_snap2 | btrfs receive /run/media/schweizer/external
> btrfs sub snap -r test_root test_snap3
> btrfs send -c test_snap2 test_snap3 | btrfs receive
> /run/media/schweizer/external
> 
> # simulate disappearing source
> btrfs sub del test_*
> 
> # restore full snapshot from external disk
> btrfs send /run/media/schweizer/external/test_snap3 | btrfs receive .
> 
> # create writeable clone
> btrfs sub snap test_snap3 test_root
> 
> # try to continue with backup scheme from source to external
> btrfs sub snap -r test_root test_snap4
> 
> # this fails!!
> btrfs send -c test_snap3 test_snap4 | btrfs receive
> /run/media/schweizer/external
> At subvol test_snap4
> ERROR: parent determination failed for 2047
> ERROR: empty stream is not considered valid
> 

Yes, that's expected. Incremental stream always needs valid parent -
this will be cloned on destination and incremental changes applied to
it. "-c" option is just additional sugar on top of it which might reduce
size of stream, but in this case (i.e. without "-p") it also attempts to
guess parent subvolume for test_snap4 and this fails because test_snap3
and test_snap4 do not have common parent so test_snap3 is rejected as
valid parent snapshot. You can restart incremental-forever chain by
using explicit "-p" instead:

btrfs send -p test_snap3 test_snap4

Subsequent snapshots (test_snap5 etc) will all have common parent with
immediate predecessor again so "-c" will work.

Note that technically "btrfs send" with single "-c" option is entirely
equivalent to "btrfs -p". Using "-p" would have avoided this issue. :)
Although this implicit check for common parent may be considered a good
thing in this case.

P.S. looking at the above, it probably needs to be in manual page for
btrfs-send. It took me quite some time to actually understand the
meaning of "-p" and "-c" and behavior if they are present.

> I need the following snapshot tree
> (diablo_external.2018-06-24T19-37-39 has to be a child of diablo):
> diablo
>         Name:                   diablo
>         UUID:                   46db1185-3c3e-194e-8d19-7456e532b2f3
>         Parent UUID:            -
>         Received UUID:          6c683d90-44f2-ad48-bb84-e9f241800179
>         Creation time:          2018-06-23 23:37:17 +0200
>         Subvolume ID:           258
>         Generation:             13748
>         Gen at creation:        7
>         Parent ID:              5
>         Top level ID:           5
>         Flags:                  -
>         Snapshot(s):
>                                 diablo_external.2018-06-24T19-37-39
>                                 diablo.2018-06-30T01-01-02
>                                 diablo.2018-06-30T05-01-01
>                                 diablo.2018-06-30T09-01-01
>                                 diablo.2018-06-30T11-01-01
>                                 diablo.2018-06-30T13-01-01
>                                 diablo.2018-06-30T14-01-01
>                                 diablo.2018-06-30T15-01-01
>                                 diablo.2018-06-30T16-01-01
>                                 diablo.2018-06-30T17-01-02
>                                 diablo.2018-06-30T18-01-01
>                                 diablo.2018-06-30T19-01-01
> 
> Here's the requested output:
> btrfs sub li -qRu /mnt/work/backup/online/
> ID 258 gen 13742 top level 5 parent_uuid -
>        received_uuid 6c683d90-44f2-ad48-bb84-e9f241800179 uuid
> 46db1185-3c3e-194e-8d19-7456e532b2f3 path diablo

Yes, as expected. From now on every read-only snapshot created from it
will inherit the same received_uuid which will be looked for on
destination instead of source uuid, so on destination wrong subvolume
will be cloned. I.o.w, on source it will compute changes against one
subvolume but apply changes on destination to clone of entirely
different subvolume. Actually I could reproduce destination corruption
easily (in my case destination snapshot had extra content but for the
same reason).

...

> 
> Is there some way to reset the received_uuid of the following snapshot
> on online?
> ID 258 gen 13742 top level 5 parent_uuid -
>        received_uuid 6c683d90-44f2-ad48-bb84-e9f241800179 uuid
> 46db1185-3c3e-194e-8d19-7456e532b2f3 path diablo
> 

There is no "official" tool but this question came up quite often.
Search this list, I believe recently one-liner using python-btrfs was
posted. Note that also patch that removes received_uuid when "ro"
propery is removed was suggested, hopefully it will be merged at some
point. Still I personally consider ability to flip read-only property
the very bad thing that should have never been exposed in the first place.
