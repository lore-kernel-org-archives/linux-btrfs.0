Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45494 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbeHKGEb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Aug 2018 02:04:31 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1foKar-0000s6-OV
        for linux-btrfs@vger.kernel.org; Sat, 11 Aug 2018 05:29:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
Date: Sat, 11 Aug 2018 03:29:27 +0000 (UTC)
Message-ID: <pan$37ed4$1f39572a$7dd0a77a$b6954c8@cox.net>
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
        <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
        <20180809174811.GA27001@polanet.pl>
        <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
        <CAJCQCtQS+yiSQ4Cu-F_Spi5_6fEw_FuGdXCafJLxBe1swacabQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 10 Aug 2018 12:07:34 -0600 as excerpted:

> But whether data is shared or exclusive seems potentially ephemeral, and
> not something a sysadmin should even be able to anticipate let alone
> individual users.

Define "user(s)".

Arguably, in the context of btrfs tool usage, "user" /is/ the admin, the 
one who cares that it's btrfs in the first place, who should have chosen 
btrfs based on the best-case match for the use-case, and who continues to 
maintain the system's btrfs filesystems using btrfs tools.

Arguably, in this context "user" is /not/ the other users the admin is 
caring for the system in behalf of, who don't care /what/ is under the 
covers so long as it works, to which should be made available more 
appropriate-to-their-needs tools should they be found necessary or useful.

> Going back to the example, I'd expect to give the user a 2GiB quota,
> with 1GiB of initially provisioned data via snapshot, so right off the
> bat they are at 50% usage of their quota. If they were to modify every
> single provisioned file, they'd in effect go from 100% shared data to
> 100% exclusive data, but their quota usage would still be 50%. That's
> completely sane and easily understandable by a regular user. The idea
> that they'd start modifying shared files, and their quota usage climbs
> is weird to me. The state of files being shared or exclusive is not user
> domain terminology anyway.

It's user-domain terminology if the "user" is the admin, who will care 
about shared/exclusive usage in the context of how it affects the usage 
of available storage resources.

"Regular users" as you use the term, that is the non-admins who just need 
to know how close they are to running out of their allotted storage 
resources, shouldn't really need to care about btrfs tool usage in the 
first place, and btrfs commands in general, including btrfs quota related 
commands, really aren't targeted at them, and aren't designed to report 
the type of information they are likely to find useful.  Other tools will 
be more appropriate.

>> The most common case is, you do a snapshot, user would only care how
>> much new space can be written into the subvolume, other than the total
>> subvolume size.
> 
> I think that's expecting a lot of users.

Not really.  Remember, "users" in this context are admins, those to whom 
the duty of maintaining their btrfs falls, and the ones at whom btrfs * 
commands are normally targeted, since this is the btrfs tool designed to 
help them with that job.

And said "users" will (presumably) be concerned about shared/exclusive if 
they're using btrfs quotas because they are trying to well manage the 
filesystem space utilization per subvolume.

(FWIW, "presumably" is thrown in there because here I don't use 
subvolumes /or/ sub-filesystem-level quotas as personally, I prefer to 
manage that at the filesystem level, with multiple independent 
filesystems and the size of individual filesystems enforcing limits on 
how much the stuff stored in them can grow.)

> I also wonder if it expects a lot from services like samba and NFS who
> have to communicate all of this in some sane way to remote clients? My
> expectation is that a remote client shows Free Space on a quota'd system
> to be based on the unused amount of the quota. I also expect if I delete
> a 1GiB file, that my quota consumption goes down. But you're saying it
> would be unchanged if I delete a 1GiB shared file, and would only go
> down if I delete a 1GiB exclusive file. Do samba and NFS know about
> shared and exclusive files? If samba and NFS don't understand this, then
> how is a user supposed to understand it?

There's a reason btrfs quotas don't work with standard VFS level quotas.  
They're managing two different things, and I'd assume the btrfs quota 
information isn't typically what samba/NFS information exporting is 
designed to deal with in the first place.  Just because a screwdriver 
/can/ be used as a hammer doesn't make it the appropriate tool for the 
job.

> And now I'm sufficiently confused I'm ready for the weekend!

LOL!

(I had today/Friday off, arguably why I'm even taking the time to reply, 
but my second day off this "week" is next Tuesday, the last day of the 
schedule-week.  I had actually forgotten that this was the last day of 
the work-week for most, until I saw that, but then, LOL!)

> And we can't have quotas getting busted all of a sudden because the
> sysadmin decides to do -dconvert -mconvert raid1, without requiring the
> sysadmin to double everyone's quota before performing the operation.

Not every_one's_, every-subvolume's.  "Everyone's" quotas shouldn't be 
affected, because that's not what btrfs quotas manage.  There are other 
(non-btrfs) tools for that.

>>> In short: values representing quotas are user-oriented ("the numbers
>>> one bought"), not storage-oriented ("the numbers they actually
>>> occupy").

Btrfs quotas are storage-oriented, and if you're using them, at least 
directly, for user-oriented, you're using the proverbial screwdriver as a 
proverbial hammer.

> What is VFS disk quotas and does Btrfs use that at all? If not, why not?
> It seems to me there really should be a high level basic per directory
> quota implementation at the VFS layer, with a single kernel interface as
> well as a single user space interface, regardless of the file system.
> Additional file system specific quota features can of course have their
> own tools, but all of this re-invention of the wheel for basic directory
> quotas is a mystery to me.

As mentioned above and by others, btrfs quotas don't use vfs quotas (or 
the reverse, really, it'd be vfs quotas using information exposed by 
btrfs quotas... if it worked that way), because there's an API mis-match 
because their intended usage and the information they convey and control 
is different, and (AFAIK) was never intended or claimed to be the same.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
