Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:51975 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbeF3Rte (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Jun 2018 13:49:34 -0400
Received: by mail-wm0-f66.google.com with SMTP id w137-v6so5136251wmw.1
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jun 2018 10:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAOfGOYyT2F-6jtKgpgm6iX5aK-kP1Ryuz_rcTFs=s05_FeAPoQ@mail.gmail.com>
 <1115fcb3-4e07-6fd9-17cb-56a8ba46a7ab@gmail.com> <CAOfGOYyFcQ5gN7z=4zEaGH0VMVUuFE5qiGwgF+c14FU228Y3iQ@mail.gmail.com>
 <0097cdf0-143e-c27a-29af-077f61928b20@gmail.com>
In-Reply-To: <0097cdf0-143e-c27a-29af-077f61928b20@gmail.com>
From: Hannes Schweizer <schweizer.hannes@gmail.com>
Date: Sat, 30 Jun 2018 19:49:20 +0200
Message-ID: <CAOfGOYwz=gkSbED7yy0RwiCCJb8L0qcj+5ZhDxUXQ1FUv3CvNw@mail.gmail.com>
Subject: Re: Incremental send/receive broken after snapshot restore
To: arvidjaar@gmail.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 30, 2018 at 8:24 AM Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>
> Do not reply privately to mails on list.
>
> 29.06.2018 22:10, Hannes Schweizer пишет:
> > On Fri, Jun 29, 2018 at 7:44 PM Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> >>
> >> 28.06.2018 23:09, Hannes Schweizer пишет:
> >>> Hi,
> >>>
> >>> Here's my environment:
> >>> Linux diablo 4.17.0-gentoo #5 SMP Mon Jun 25 00:26:55 CEST 2018 x86_64
> >>> Intel(R) Core(TM) i5 CPU 760 @ 2.80GHz GenuineIntel GNU/Linux
> >>> btrfs-progs v4.17
> >>>
> >>> Label: 'online'  uuid: e4dc6617-b7ed-4dfb-84a6-26e3952c8390
> >>>         Total devices 2 FS bytes used 3.16TiB
> >>>         devid    1 size 1.82TiB used 1.58TiB path /dev/mapper/online0
> >>>         devid    2 size 1.82TiB used 1.58TiB path /dev/mapper/online1
> >>> Data, RAID0: total=3.16TiB, used=3.15TiB
> >>> System, RAID0: total=16.00MiB, used=240.00KiB
> >>> Metadata, RAID0: total=7.00GiB, used=4.91GiB
> >>> GlobalReserve, single: total=512.00MiB, used=0.00B
> >>>
> >>> Label: 'offline'  uuid: 5b449116-93e5-473e-aaf5-bf3097b14f29
> >>>         Total devices 2 FS bytes used 3.52TiB
> >>>         devid    1 size 5.46TiB used 3.53TiB path /dev/mapper/offline0
> >>>         devid    2 size 5.46TiB used 3.53TiB path /dev/mapper/offline1
> >>> Data, RAID1: total=3.52TiB, used=3.52TiB
> >>> System, RAID1: total=8.00MiB, used=512.00KiB
> >>> Metadata, RAID1: total=6.00GiB, used=5.11GiB
> >>> GlobalReserve, single: total=512.00MiB, used=0.00B
> >>>
> >>> Label: 'external'  uuid: 8bf13621-01f0-4f09-95c7-2c157d3087d0
> >>>         Total devices 1 FS bytes used 3.65TiB
> >>>         devid    1 size 5.46TiB used 3.66TiB path
> >>> /dev/mapper/luks-3c196e96-d46c-4a9c-9583-b79c707678fc
> >>> Data, single: total=3.64TiB, used=3.64TiB
> >>> System, DUP: total=32.00MiB, used=448.00KiB
> >>> Metadata, DUP: total=11.00GiB, used=9.72GiB
> >>> GlobalReserve, single: total=512.00MiB, used=0.00B
> >>>
> >>>
> >>> The following automatic backup scheme is in place:
> >>> hourly:
> >>> btrfs sub snap -r online/root online/root.<date>
> >>>
> >>> daily:
> >>> btrfs sub snap -r online/root online/root.<new_offline_reference>
> >>> btrfs send -c online/root.<old_offline_reference>
> >>> online/root.<new_offline_reference> | btrfs receive offline
> >>> btrfs sub del -c online/root.<old_offline_reference>
> >>>
> >>> monthly:
> >>> btrfs sub snap -r online/root online/root.<new_external_reference>
> >>> btrfs send -c online/root.<old_external_reference>
> >>> online/root.<new_external_reference> | btrfs receive external
> >>> btrfs sub del -c online/root.<old_external_reference>
> >>>
> >>> Now here are the commands leading up to my problem:
> >>> After the online filesystem suddenly went ro, and btrfs check showed
> >>> massive problems, I decided to start the online array from scratch:
> >>> 1: mkfs.btrfs -f -d raid0 -m raid0 -L "online" /dev/mapper/online0
> >>> /dev/mapper/online1
> >>>
> >>> As you can see from the backup commands above, the snapshots of
> >>> offline and external are not related, so in order to at least keep the
> >>> extensive backlog of the external snapshot set (including all
> >>> reflinks), I decided to restore the latest snapshot from external.
> >>> 2: btrfs send external/root.<external_reference> | btrfs receive online
> >>>
> >>> I wanted to ensure I can restart the incremental backup flow from
> >>> online to external, so I did this
> >>> 3: mv online/root.<external_reference> online/root
> >>> 4: btrfs sub snap -r online/root online/root.<external_reference>
> >>> 5: btrfs property set online/root ro false
> >>>
> >>> Now, I naively expected a simple restart of my automatic backups for
> >>> external should work.
> >>> However after running
> >>> 6: btrfs sub snap -r online/root online/root.<new_external_reference>
> >>> 7: btrfs send -c online/root.<old_external_reference>
> >>> online/root.<new_external_reference> | btrfs receive external
> >>
> >> You just recreated your "online" filesystem from scratch. Where
> >> "old_external_reference" comes from? You did not show steps used to
> >> create it.
> >>
> >>> I see the following error:
> >>> ERROR: unlink root/.ssh/agent-diablo-_dev_pts_3 failed. No such file
> >>> or directory
> >>>
> >>> Which is unfortunate, but the second problem actually encouraged me to
> >>> post this message.
> >>> As planned, I had to start the offline array from scratch as well,
> >>> because I no longer had any reference snapshot for incremental backups
> >>> on other devices:
> >>> 8: mkfs.btrfs -f -d raid1 -m raid1 -L "offline" /dev/mapper/offline0
> >>> /dev/mapper/offline1
> >>>
> >>> However restarting the automatic daily backup flow bails out with a
> >>> similar error, although no potentially problematic previous
> >>> incremental snapshots should be involved here!
> >>> ERROR: unlink o925031-987-0/2139527549 failed. No such file or directory
> >>>
> >>
> >> Again - before you can *re*start incremental-forever sequence you need
> >> initial full copy. How exactly did you restart it if no snapshots exist
> >> either on source or on destination?
> >
> > Thanks for your help regarding this issue!
> >
> > Before the online crash, I've used the following online -> external
> > backup scheme:
> > btrfs sub snap -r online/root online/root.<new_external_reference>
> > btrfs send -c online/root.<old_external_reference>
> > online/root.<new_external_reference> | btrfs receive external
> > btrfs sub del -c online/root.<old_external_reference>
> >
> > By sending the existing snapshot from external to online (basically a
> > full copy of external/old_external_reference to online/root), it
> > should have been possible to restart the monthly online -> external
> > backup scheme, right?
> >
>
> You did not answer any of my questions which makes it impossible to
> actually try to reproduce or understand it. In particular, it is not
> even clear whether problem happens immediately or after some time.
>
> Educated guess is that the problem is due to stuck received_uuid on
> source which now propagates into every snapshot and makes receive match
> wrong subvolume. You should never reset read-only flag, rather create
> new writable clone leaving original read-only snapshot untouched.
>
> Showing output of "btrfs sub li -qRu" on both sides would be helpful.

Sry for being too vague...

I've tested a few restore methods beforehand, and simply creating a
writeable clone from the restored snapshot does not work for me, eg:
# create some source snapshots
btrfs sub create test_root
btrfs sub snap -r test_root test_snap1
btrfs sub snap -r test_root test_snap2

# send a full and incremental backup to external disk
btrfs send test_snap2 | btrfs receive /run/media/schweizer/external
btrfs sub snap -r test_root test_snap3
btrfs send -c test_snap2 test_snap3 | btrfs receive
/run/media/schweizer/external

# simulate disappearing source
btrfs sub del test_*

# restore full snapshot from external disk
btrfs send /run/media/schweizer/external/test_snap3 | btrfs receive .

# create writeable clone
btrfs sub snap test_snap3 test_root

# try to continue with backup scheme from source to external
btrfs sub snap -r test_root test_snap4

# this fails!!
btrfs send -c test_snap3 test_snap4 | btrfs receive
/run/media/schweizer/external
At subvol test_snap4
ERROR: parent determination failed for 2047
ERROR: empty stream is not considered valid

I need the following snapshot tree
(diablo_external.2018-06-24T19-37-39 has to be a child of diablo):
diablo
        Name:                   diablo
        UUID:                   46db1185-3c3e-194e-8d19-7456e532b2f3
        Parent UUID:            -
        Received UUID:          6c683d90-44f2-ad48-bb84-e9f241800179
        Creation time:          2018-06-23 23:37:17 +0200
        Subvolume ID:           258
        Generation:             13748
        Gen at creation:        7
        Parent ID:              5
        Top level ID:           5
        Flags:                  -
        Snapshot(s):
                                diablo_external.2018-06-24T19-37-39
                                diablo.2018-06-30T01-01-02
                                diablo.2018-06-30T05-01-01
                                diablo.2018-06-30T09-01-01
                                diablo.2018-06-30T11-01-01
                                diablo.2018-06-30T13-01-01
                                diablo.2018-06-30T14-01-01
                                diablo.2018-06-30T15-01-01
                                diablo.2018-06-30T16-01-01
                                diablo.2018-06-30T17-01-02
                                diablo.2018-06-30T18-01-01
                                diablo.2018-06-30T19-01-01

Here's the requested output:
btrfs sub li -qRu /mnt/work/backup/online/
ID 258 gen 13742 top level 5 parent_uuid -
       received_uuid 6c683d90-44f2-ad48-bb84-e9f241800179 uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 path diablo
ID 1896 gen 1089 top level 5 parent_uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
de9421c5-d160-2949-bf09-613949b4611c path
diablo_external.2018-06-24T19-37-39
ID 2013 gen 11856 top level 5 parent_uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
09c5d505-eee5-d24c-a05b-b8c79284586e path diablo.2018-06-30T01-01-02
ID 2018 gen 12267 top level 5 parent_uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
8a495ba7-71db-6343-abf2-7859f04e7ba0 path diablo.2018-06-30T05-01-01
ID 2022 gen 12674 top level 5 parent_uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
f115fd06-cef6-db44-928c-cf55fe4b738a path diablo.2018-06-30T09-01-01
ID 2024 gen 12879 top level 5 parent_uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
f4f523af-c9f3-834e-adac-44d24ed95af6 path diablo.2018-06-30T11-01-01
ID 2026 gen 13092 top level 5 parent_uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
6401603c-e71b-9947-b67d-9603a395ebc5 path diablo.2018-06-30T13-01-01
ID 2027 gen 13193 top level 5 parent_uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
027a50b6-0725-f840-b4bd-6674f88ee340 path diablo.2018-06-30T14-01-01
ID 2028 gen 13298 top level 5 parent_uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
bdb61c68-bc15-2840-b8fd-d7a99fe7723a path diablo.2018-06-30T15-01-01
ID 2029 gen 13405 top level 5 parent_uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
b96b5c6b-e719-8d47-ad03-15901ed2bf3d path diablo.2018-06-30T16-01-01
ID 2030 gen 13511 top level 5 parent_uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
22a68d4b-56ab-5444-9883-69023b6a231b path diablo.2018-06-30T17-01-02
ID 2031 gen 13615 top level 5 parent_uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
e2af192e-9311-6c4d-a3fe-5d23767bc60b path diablo.2018-06-30T18-01-01
ID 2032 gen 13718 top level 5 parent_uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
ddf39ee2-d5b9-5440-8c4e-b72b7e342444 path diablo.2018-06-30T19-01-01

btrfs sub li -qRu /run/media/schweizer/external
ID 563 gen 5036 top level 5 parent_uuid -
      received_uuid -                                    uuid
fc03e750-c26b-484b-bd00-9a7b89cfd610 path
diablo_external.2017-02-06T20-31-34
ID 3284 gen 1392 top level 5 parent_uuid -
       received_uuid bc9b22c8-e107-8a48-b14f-06b8a41a22a6 uuid
26a7792f-0157-7c4d-adf7-3d60627af8e5 path
diablo_external.2017-09-27T11-39-48
ID 5772 gen 1523 top level 5 parent_uuid
26a7792f-0157-7c4d-adf7-3d60627af8e5 received_uuid
3ae68477-b348-714c-8f87-6b5fd0809aa7 uuid
28cbeff1-5ac2-dc46-98f3-10f576acc2e4 path
diablo_external.2017-11-07T15-10-37
ID 5929 gen 6667 top level 5 parent_uuid
052624f5-2434-0941-8f0d-a03aef3e6995 received_uuid
209cfa0c-4436-824e-8ce4-f34ce815ecb1 uuid
a053ca7e-1e48-1c4c-baf7-75c4d676695f path
diablo_external.2018-01-01T15-37-41
ID 6049 gen 7575 top level 5 parent_uuid
a053ca7e-1e48-1c4c-baf7-75c4d676695f received_uuid
5b2eb743-6a40-a448-abc7-027aaa0ba770 uuid
22205837-fce9-d74d-9390-d2de6148dee9 path
diablo_external.2018-03-03T14-39-44
ID 6158 gen 8480 top level 5 parent_uuid
22205837-fce9-d74d-9390-d2de6148dee9 received_uuid
85e3d595-3979-7648-9ef7-86d0784d41aa uuid
07fe0dc9-1f8b-024b-8848-77b008cd52e5 path
diablo_external.2018-04-06T21-22-06
ID 6231 gen 9700 top level 5 parent_uuid
07fe0dc9-1f8b-024b-8848-77b008cd52e5 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
906e702f-d658-7f48-901a-afb032f504d6 path
diablo_external.2018-05-01T15-08-13
ID 6281 gen 9429 top level 5 parent_uuid
906e702f-d658-7f48-901a-afb032f504d6 received_uuid
6c683d90-44f2-ad48-bb84-e9f241800179 uuid
e41f5938-eb95-9845-b691-a4aeae0ce9d1 path
diablo_external.2018-06-24T19-37-39

Is there some way to reset the received_uuid of the following snapshot
on online?
ID 258 gen 13742 top level 5 parent_uuid -
       received_uuid 6c683d90-44f2-ad48-bb84-e9f241800179 uuid
46db1185-3c3e-194e-8d19-7456e532b2f3 path diablo


> >>> I'm a bit lost now. The only thing I could image which might be
> >>> confusing for btrfs,
> >>> is the residual "Received UUID" of online/root.<external_reference>
> >>> after command 2.
> >>> What's the recommended way to restore snapshots with send/receive
> >>> without breaking subsequent incremental backups (including reflinks of
> >>> existing backups)?
> >>>
> >>> Any hints appreciated...
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>
>
