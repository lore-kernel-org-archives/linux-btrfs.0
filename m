Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33069 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756607AbeAJDvX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 22:51:23 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eZ7O7-0005bk-Uy
        for linux-btrfs@vger.kernel.org; Wed, 10 Jan 2018 04:49:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recommendations for balancing as part of regular maintenance?
Date: Wed, 10 Jan 2018 03:49:04 +0000 (UTC)
Message-ID: <pan$5d0d3$29334af9$ed04365a$f8d9747d@cox.net>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
        <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
        <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
        <796ad87c-852f-c6a0-7366-5e888d51fc5c@gmail.com>
        <01020160d7768587-50a9392c-7250-4735-9d14-66ff03a161c9-000000@eu-west-1.amazonses.com>
        <3eae37f6-3776-15c9-84ae-568e56abfa7e@rqc.ru>
        <13b5063c-a7bd-5c95-1f6e-16124d385569@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 09 Jan 2018 07:46:48 -0500 as
excerpted:

>> On 08/01/18 23:29, Martin Raiber wrote:
>>> There have been reports of (rare) corruption caused by balance (won't
>>> be detected by a scrub) here on the mailing list. So I would stay a
>>> away from btrfs balance unless it is absolutely needed (ENOSPC), and
>>> while it is run I would try not to do anything else wrt. to writes
>>> simultaneously.
>> 
>> This is my opinion too as a normal user, based upon reading this list
>> and own attempts to recover from ENOSPC. I'd rather re-create
>> filesystem from scratch, or at least make full verified backup before
>> attempting to fix problems with balance.

> While I'm generally of the same opinion (and I have a feeling most other
> people who have been server admins are too), it's not a very user
> friendly position to recommend that.  Keep in mind that many (probably
> most) users don't keep proper backups, and just targeting 'sensible'
> people as your primary audience is a bad idea.  It also needs to work at
> at least a basic level anyway though simply because you can't always
> just nuke the volume and rebuild it from scratch.
> 
> Personally though, I don't think I've ever seen issues with balance
> corrupting data, and I don't recall seeing complaints about it either
> (though I would love to see some links that prove me wrong).

AFAIK, such corruption reports re balance aren't really balance, per se, 
at all.

Instead, what I've seen in nearly all cases is a number of filesystem 
maintenance commands involving heavy I/O colliding, that is, being run at 
the same time, possibly because some of them are scheduled, and the admin 
didn't take into account scheduled commands when issuing others manually.

I don't believe anyone would recommend running balance, scrub, snapshot-
deletion, and backups (rsync or btrfs send/receive being the common 
ones), all at the same time, or even two or more at the same time, if for 
no other reason than because they're all IO intensive and running just 
/one/ of them at a time is hard /enough/ on the system and the 
performance of anything else running at the same time, even when all 
components are fully stable and mature (and as we all know, btrfs is 
stabilizing, but not yet fully stable and mature), yet that's what these 
sorts of reports invariably involve.

Of course, with a certainty btrfs /should/ be able to handle more than 
one of these at once without corruption, because anything else is a bug, 
but... btrfs /is/ still stabilizing and maturing, and it's precisely this 
sort of rare corner-case race-condition bugs where more than one 
extremely heavy IO filesystem maintenance command is being run at the 
same time that tend to be the last to be found and fixed, because they 
/are/ rare corner-cases, often depending on race conditions, that tend to 
be rare enough reported, and then extremely difficult to duplicate, so 
that's exactly the type of bugs that tend to remain around at this point.


So rather than discouraging a sane-filtered regular balance (which I'll 
discuss in a different reply), I'd suggest that the more sane 
recommendation is to be aware of other major-IO filesystem maintenance 
commands (not just btrfs commands but rsync-based backups, etc, too, 
rsync being demanding enough on its own to have triggered a number of 
btrfs bug reports and fixes over the years), including scheduled 
commands, and to only run one at a time.

IOW, don't do a balance if your scheduled backup or snapshot-deletion is 
about to kick in.  One at a time is stressful enough on the filesystem 
and hardware, don't compound the problem trying to do two or more at once!

So assuming a weekly schedule, do one a day of balance, scrub, snapshot-
deletion, backups (after ensuring that none of them take over a day, 
balance in particular could at TiB-scale+ if not sanely filtered, 
particularly if quotas are enabled due to the scaling issues of that 
feature).  And if any of those are scheduled daily or more frequently, 
space the scheduling appropriately and ensure they're done before 
starting the next task.

And keep in mind the scheduled tasks when running things manually, so as 
not to collide there either.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

