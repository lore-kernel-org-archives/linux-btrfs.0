Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39342 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750814AbeDYR6z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 13:58:55 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fBOem-0006dH-Ve
        for linux-btrfs@vger.kernel.org; Wed, 25 Apr 2018 19:56:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs progs release 4.16.1
Date: Wed, 25 Apr 2018 17:56:34 +0000 (UTC)
Message-ID: <pan$6c28f$e2f32d3c$d7b1a9d4$a47d6b5f@cox.net>
References: <20180424115857.25174-1-dsterba@suse.com>
        <pan$3f697$9cfd5cd2$6e9f2dc3$73937e71@cox.net>
        <20180425110234.GN21272@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Wed, 25 Apr 2018 13:02:34 +0200 as excerpted:

> On Wed, Apr 25, 2018 at 06:31:20AM +0000, Duncan wrote:
>> David Sterba posted on Tue, 24 Apr 2018 13:58:57 +0200 as excerpted:
>> 
>> > btrfs-progs version 4.16.1 have been released.  This is a bugfix
>> > release.
>> > 
>> > Changes:
>> > 
>> >   * remove obsolete tools: btrfs-debug-tree, btrfs-zero-log,
>> >   btrfs-show-super, btrfs-calc-size
>> 
>> Cue the admin-side gripes about developer definitions of micro-upgrade
>> explicit "bugfix release" that allow disappearance of "obsolete tools".
>> 
>> Arguably such removals can be expected in a "feature release", but
>> shouldn't surprise unsuspecting admins doing a micro-version upgrade
>> that's specifically billed as a "bugfix release".
> 
> A major version release would be a better time for the removal, I agree
> and should have considered that.
> 
> However, the tools have been obsoleted for a long time (since 2015 or
> 2016) so I wonder if the deprecation warnings have been ignored by the
> admins all the time.

Indeed, in practice, anybody still using the stand-alone tools in a 
current version has been ignoring deprecation warnings for awhile, and 
the difference between 4.16.1 and 4.17(.0) isn't likely to make much of a 
difference to them.

It's just that from here anyway, if I did a big multi-version upgrade and 
saw tools go missing I'd expect it, and if I did an upgrade from 4.16 to 
4.17 I'd expect it and blame myself for not getting with the program 
sooner.  But on an upgrade from 4.16 to 4.16.1, furthermore, an explicit 
"bugfix release", I'd be annoyed with upstream when they went missing, 
because it's just not expected in such a minor release, particularly when 
it's an explicit "bugfix release".

>> (Further support for btrfs being "still stabilizing, not yet fully
>> stable and mature."  But development mode habits need to end
>> /sometime/, if stability is indeed a goal.)
> 
> What happened here was a bad release management decision, a minor one in
> my oppinion but I hear your complaint and will keep that in mind for
> future releases.

That's all I was after.  A mere trifle indeed in the filesystem context 
where there's a real chance that bugs can eat data, but equally trivially 
held off for a .0 release.  What's behind is done, but it can and should 
be used to inform the future, and I simply mentioned it here with the 
goal /of/ informing future release decisions.  To the extent that it does 
so, my post accomplished its purpose. =:^)

Seems my way of saying that ended up coming across way more negative than 
intended.  So I have some changes to make in the way I handle things in 
the future as well. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

