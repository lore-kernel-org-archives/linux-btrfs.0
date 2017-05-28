Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:35526 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbdE1Kj7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 May 2017 06:39:59 -0400
Received: by mail-yw0-f170.google.com with SMTP id l74so19297639ywe.2
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 03:39:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170527215608.23a40176@ws>
References: <20170527215608.23a40176@ws>
From: Ivan P <chrnosphered@gmail.com>
Date: Sun, 28 May 2017 12:39:38 +0200
Message-ID: <CADzmB21OO273fXqTsh-qAnRk_y8xeTXbCoyeRbDB9eO2S9ASug@mail.gmail.com>
Subject: Re: btrfs-tools/linux 4.11: btrfs-cleaner misbehaving
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 28, 2017 at 6:56 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> [This mail was also posted to gmane.comp.file-systems.btrfs.]
>
> Ivan P posted on Sat, 27 May 2017 22:54:31 +0200 as excerpted:
>
>>>>>> Please add me to CC when replying, as I am not
>>>>>> subscribed to the mailing list.
>
>> Hmm, remounting as you suggested has shut it up immediately - hurray!
>>
>> I don't really have any special write pattern from what I can tell.
>> About the only thing different from all the other btrfs systems I've
>> set up is that the data is also on the same volume as the system.
>> Normal usage, no VMs or heavy file generation. I'm also only taking
>> snapshots of the system and @home, with the latter only containing
>> my .config, .cache and symlinks to some folders in @data.
>
> Systemd?  Journald with journals on btrfs?  Regularly snapshotting that
> subvolume?
>
> If yes to all of the above, that might be the issue.  Normally systemd
> will set the journal directory NOCOW, so the journal files inherit it
> at creation, in ordered to avoid heavy fragmentation due to the COW-
> unfriendly database-style file-internal-rewrite pattern with the
> journal files.
>
> Great.  Except that snapshotting locks the existing version of the file
> in place with the snapshot, so the next write to any block must be COW
> anyway.  This is sometimes referred to as COW1, since it's a
> single-time COW, and the effect isn't too bad with a one-time
> snapshot.  But if you're regularly snapshotting the journal files, that
> will trigger COW1 on every snapshot, which if you're snapshotting often
> enough can be almost as bad as regular COW in terms of fragmentation.
>
> The fix is to make the journal dir a subvolume instead, thereby
> excluding it from the snapshot taken on the parent subvolume, and just
> don't snapshot the journal subvolume then, so the NOCOW that systemd
> should already set on that subdir and its contents will actually be
> NOCOW, without interference from snapshotting repeatedly forcing COW1.
>
>
> Of course an alternative fix, the one I use here (and am happy with)
> instead, is to have a normal syslog (I use syslog-ng, but others have
> reported using rsyslog) handling your saved logs in traditional text
> form (most modern syslogs should cooperate with systemd's journald),
> and configure journald to only use tmpfs (see the journald.conf
> manpage). Traditional text logs are append-only and not nearly as bad
> in COW terms.  Meanwhile, journald is still active, just writing to
> tmpfs only, so you get a journal for the current boot session and thus
> can still take advantage of all the usual systemd/journald features
> such as systemctl status spitting out the last 10 log entries for that
> service, etc.  It's just limited to the current boot session, and you
> use the normal text logs for anything older than that.  For me anyway
> that's the best of both worlds, and I don't have to worry about how the
> journal files behave on btrfs at all, because they're not written to
> btrfs at all. =:^)
>
>
> Meanwhile, since you mentioned snapshots, a word of caution there.  If
> you do have scripted snapshots being taken, be sure you have a script
> thinning down your snapshot history as well.  More than 200-300
> snapshots per subvolume scales very poorly in btrfs maintenance terms
> (and qgroups make the problem far worse, if you have them active at
> all).  But if for instance you're taking snapshots ever hour, if you
> need something from one say a month old, are you really going to
> remember or care which exact hour it was, or will the daily either
> before or after that hour be fine, and actually much easier to find if
> you've trimmed to daily by then, as opposed to having hundreds and
> hundreds of hourly snapshots accumulating?
>
> So snapshots are great but they don't come without cost, and if you
> keep under 200 and if possible under 100 per subvolume, you'll find
> maintenance such as balance and check (fsck) go much faster than they
> do with even 500, let alone thousands.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman

I haven't had any issues like this before on another two boxes which ran
for years with systemd and journald, so I'm rather surprised this is a problem.

It does make sense for journald to fragment the disk, but isn't that what
autodefrag is for? The weird thing is that btrfs-cleaner can't seem to be
able to ever finish the work it is doing. Which would mean the work piles up
constantly, without getting done...

At the moment I am at 9 system snapshots and 5 @home snapshots, which
IMHO btrfs should be able to handle. The other boxes have about the same
number of snapshots and one of them is running 24/7 as a home server.

The snapshots are not automated, I take a snapshot of @arch_current and
@home using a script before updating my system. So the snapshot interval
is very irregular. I also try clean up old snapshots, only leaving about three
newest system snapshots on disk, though I haven't done that recently.

Oh, an I'm not using any qgroups, not that I know, at least.

Regards,
Ivan.
