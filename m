Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:34201 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbeH2Kx6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 06:53:58 -0400
Received: by mail-vk0-f50.google.com with SMTP id l143-v6so2029673vke.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 23:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAN4oSBdfDVGmG8L2vS9h9McEs5aSuP5RfTGREB2ZhGwmAg4JhA@mail.gmail.com>
 <CAJCQCtSq5K90gpfGQN8JhqQddBg62m8EG_bFuWN5XyzdNStDfw@mail.gmail.com>
 <CAN4oSBeHwnsm5Ecz1hAQLk6s6utHfn5XeR8xMhnZpmT-sb-_iw@mail.gmail.com>
 <CAJCQCtQ=CiB5cY8RL4tzps21d=umjzNM=BKjdUBCc7WiP0QF9A@mail.gmail.com>
 <CAJCQCtSGV1gz66X9BJAJosuhMTvd2=Me-X2tVDwJ0Eg9PA7BPA@mail.gmail.com>
 <CAN4oSBfAS75x7+D2Ms93NGB5H5MG-AOR5mHg2czGCECg6api3Q@mail.gmail.com>
 <CAJCQCtT3PrcFwFq3oAyPyQTNBRdSjevFEE7V5_AoKD6hEDgvyA@mail.gmail.com>
 <CAN4oSBdLEXS8DzZ+8Y-z5BxSe_7EUsA4ZEp4OAhWOhhZMwkM=w@mail.gmail.com>
 <CAJCQCtRPxtqqfCE_fRwzbfFAFMHCdO34T+riXQfd6-=BJX37SQ@mail.gmail.com>
 <CAN4oSBezSLqwLaYu-OPrgomcK-RnaJhkukMoun=8JKQbMfqSWA@mail.gmail.com> <CAJCQCtTZap+DRVe9yj-GjvJsvL=A+SoTzdTY=u2KjUV5WQhMsw@mail.gmail.com>
In-Reply-To: <CAJCQCtTZap+DRVe9yj-GjvJsvL=A+SoTzdTY=u2KjUV5WQhMsw@mail.gmail.com>
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Wed, 29 Aug 2018 09:58:21 +0300
Message-ID: <CAN4oSBdvw2BnL7NJeFNmWbnQfhiZzGM=bi4kPVLb3G1BykBL=g@mail.gmail.com>
Subject: Re: DRDY errors are not consistent with scrub results
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com>, 29 Ağu 2018 Çar, 02:58
tarihinde şunu yazdı:
>
> On Tue, Aug 28, 2018 at 5:04 PM, Cerem Cem ASLAN <ceremcem@ceremcem.net> wrote:
> > What I want to achive is that I want to add the problematic disk as
> > raid1 and see how/when it fails and how BTRFS recovers these fails.
> > While the party goes on, the main system shouldn't be interrupted
> > since this is a production system. For example, I would never expect
> > to be ended up with such a readonly state while trying to add a disk
> > with "unknown health" to the system. Was it somewhat expected?
>
> I don't know. I also can't tell you how LVM or mdraid behave in the
> same situation either though. For sure I've come across bug reports
> where underlying devices go read only and the file system falls over
> totally and developers shrug and say they can't do anything.
>
> This situation is a little different and difficult. You're starting
> out with a one drive setup so the profile is single/DUP or
> single/single, and that doesn't change when adding. So the 2nd drive
> is actually *mandatory* for a brief period of time before you've made
> it raid1 or higher. It's a developer question what is the design, and
> if this is a bug: maybe the device being added should be written to
> with placeholder supers or even just zeros in all the places for 'dev
> add' metadata, and only if that succeeds, to then write real updated
> supers to all devices. It's possible the 'dev add' presently writes
> updated supers to all devices at the same time, and has a brief period
> where the state is fragile and if it fails, it goes read only to
> prevent damaging the file system.

Thinking again, this is totally acceptable. If the requirement was a
good health disk, then I think I must check the disk health by myself.
I may believe that the disk is in a good state, or make a quick test
or make some very detailed tests to be sure.

Likewise, ending up with readonly state is not the end of the world,
even over SSH, because system still functions and all I need to do is
a reboot in the worst case. That's also acceptable *while adding a new
disk*.

>
> Anyway, without a call trace, no idea why it ended up read only. So I
> have to speculate.
>

I may try adding the disk again any time and provide any requested
logs, it is still attached to the server. I'm only not sure if this is
a useful experiment from the point of view of the rest of the people.

>
> >
> > Although we know that disk is about to fail, it still survives.
>
> That's very tenuous rationalization, a drive that rejects even a
> single write is considered failed by the md driver. Btrfs is still
> very tolerant of this, so if it had successfully added and you were
> running in production, you should expect to see thousands of write
> errors dumped to the kernel log

That's exactly what I expected :)

because Btrfs never ejects a bad drive
> still. It keeps trying. And keeps reporting the failures. And all
> those errors being logged can end up causing more write demand if the
> logs are on the same volume as the failing device, even more errors to
> record, and you get an escalating situation with heavy log writing.
>

Good to point this. Maybe I should arrange an on-ram virtual machine
that writes back to local disk if no hardware errors found and start
sending logs in a different server *if* such a hardware failure
occurs.

>
> > Shouldn't we expect in such a scenario that when system tries to read
> > or write some data from/to that BROKEN_DISK and when it recognizes it
> > failed, it will try to recover the part of the data from GOOD_DISK and
> > try to store that recovered data in some other part of the
> > BROKEN_DISK?
>
> Nope. Btrfs can only write supers to fixed locations on the drive,
> same as any other file system. Btrfs metadata could possibly go
> elsewhere because it doesn't have fixed locations, but Btrfs doesn't
> do bad sector tracking. So once it decides metadata goes in location
> X, if X reports a write error it will not try to write elsewhere and
> insofar as I'm aware ext4 and XFS and LVM and md don't either; md does
> have an optional bad block map it will use for tracking bad sectors
> and remap to known good sectors. Normally the drive firmware should do
> this and when that fails the drive is considered toast for production
> purpose

That's also plausible. Thinking again (again? :) if BTRFS would behave
as I expected, that retries might never end if the disk is in a very
bad situation and that would add very intensive IO load on a
production system.

I think in such a situation I should remove the raid device, try to
reformat it and attach it again.

>
> >Or did I misunderstood the whole thing?
>
> Well in a way this is sorta user sabotage. It's a valid test and I'd
> say ideally things should fail safely, rather than fall over. But at
> the same time it's not wrong for developers to say: "look if you add a
> bad device there's a decent chance we're going face plant and go read
> only to avoid causing worse problems, so next time you should qualify
> the drive before putting it into production."

Agreed.

>
> I'm willing to bet all the other file system devs would say something
> like that even if Btrfs devs think something better could happen, it's
> probably not a super high priority.
>
>

Devs doing lots of things already and yes, this is not an urgent task.

I appreciate your helps, thank you!

>
>
> --
> Chris Murphy
