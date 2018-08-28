Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42205 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbeH2Dwy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 23:52:54 -0400
Received: by mail-lj1-f196.google.com with SMTP id f1-v6so2864463ljc.9
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 16:58:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN4oSBezSLqwLaYu-OPrgomcK-RnaJhkukMoun=8JKQbMfqSWA@mail.gmail.com>
References: <CAN4oSBdfDVGmG8L2vS9h9McEs5aSuP5RfTGREB2ZhGwmAg4JhA@mail.gmail.com>
 <CAJCQCtSq5K90gpfGQN8JhqQddBg62m8EG_bFuWN5XyzdNStDfw@mail.gmail.com>
 <CAN4oSBeHwnsm5Ecz1hAQLk6s6utHfn5XeR8xMhnZpmT-sb-_iw@mail.gmail.com>
 <CAJCQCtQ=CiB5cY8RL4tzps21d=umjzNM=BKjdUBCc7WiP0QF9A@mail.gmail.com>
 <CAJCQCtSGV1gz66X9BJAJosuhMTvd2=Me-X2tVDwJ0Eg9PA7BPA@mail.gmail.com>
 <CAN4oSBfAS75x7+D2Ms93NGB5H5MG-AOR5mHg2czGCECg6api3Q@mail.gmail.com>
 <CAJCQCtT3PrcFwFq3oAyPyQTNBRdSjevFEE7V5_AoKD6hEDgvyA@mail.gmail.com>
 <CAN4oSBdLEXS8DzZ+8Y-z5BxSe_7EUsA4ZEp4OAhWOhhZMwkM=w@mail.gmail.com>
 <CAJCQCtRPxtqqfCE_fRwzbfFAFMHCdO34T+riXQfd6-=BJX37SQ@mail.gmail.com> <CAN4oSBezSLqwLaYu-OPrgomcK-RnaJhkukMoun=8JKQbMfqSWA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 28 Aug 2018 17:58:48 -0600
Message-ID: <CAJCQCtTZap+DRVe9yj-GjvJsvL=A+SoTzdTY=u2KjUV5WQhMsw@mail.gmail.com>
Subject: Re: DRDY errors are not consistent with scrub results
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 28, 2018 at 5:04 PM, Cerem Cem ASLAN <ceremcem@ceremcem.net> wrote:
> What I want to achive is that I want to add the problematic disk as
> raid1 and see how/when it fails and how BTRFS recovers these fails.
> While the party goes on, the main system shouldn't be interrupted
> since this is a production system. For example, I would never expect
> to be ended up with such a readonly state while trying to add a disk
> with "unknown health" to the system. Was it somewhat expected?

I don't know. I also can't tell you how LVM or mdraid behave in the
same situation either though. For sure I've come across bug reports
where underlying devices go read only and the file system falls over
totally and developers shrug and say they can't do anything.

This situation is a little different and difficult. You're starting
out with a one drive setup so the profile is single/DUP or
single/single, and that doesn't change when adding. So the 2nd drive
is actually *mandatory* for a brief period of time before you've made
it raid1 or higher. It's a developer question what is the design, and
if this is a bug: maybe the device being added should be written to
with placeholder supers or even just zeros in all the places for 'dev
add' metadata, and only if that succeeds, to then write real updated
supers to all devices. It's possible the 'dev add' presently writes
updated supers to all devices at the same time, and has a brief period
where the state is fragile and if it fails, it goes read only to
prevent damaging the file system.

Anyway, without a call trace, no idea why it ended up read only. So I
have to speculate.


>
> Although we know that disk is about to fail, it still survives.

That's very tenuous rationalization, a drive that rejects even a
single write is considered failed by the md driver. Btrfs is still
very tolerant of this, so if it had successfully added and you were
running in production, you should expect to see thousands of write
errors dumped to the kernel log because Btrfs never ejects a bad drive
still. It keeps trying. And keeps reporting the failures. And all
those errors being logged can end up causing more write demand if the
logs are on the same volume as the failing device, even more errors to
record, and you get an escalating situation with heavy log writing.


> Shouldn't we expect in such a scenario that when system tries to read
> or write some data from/to that BROKEN_DISK and when it recognizes it
> failed, it will try to recover the part of the data from GOOD_DISK and
> try to store that recovered data in some other part of the
> BROKEN_DISK?

Nope. Btrfs can only write supers to fixed locations on the drive,
same as any other file system. Btrfs metadata could possibly go
elsewhere because it doesn't have fixed locations, but Btrfs doesn't
do bad sector tracking. So once it decides metadata goes in location
X, if X reports a write error it will not try to write elsewhere and
insofar as I'm aware ext4 and XFS and LVM and md don't either; md does
have an optional bad block map it will use for tracking bad sectors
and remap to known good sectors. Normally the drive firmware should do
this and when that fails the drive is considered toast for production
purpose

>Or did I misunderstood the whole thing?

Well in a way this is sorta user sabotage. It's a valid test and I'd
say ideally things should fail safely, rather than fall over. But at
the same time it's not wrong for developers to say: "look if you add a
bad device there's a decent chance we're going face plant and go read
only to avoid causing worse problems, so next time you should qualify
the drive before putting it into production."

I'm willing to bet all the other file system devs would say something
like that even if Btrfs devs think something better could happen, it's
probably not a super high priority.




-- 
Chris Murphy
