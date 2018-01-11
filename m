Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55951 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932238AbeAKIxX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 03:53:23 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eZYZx-0001xO-9J
        for linux-btrfs@vger.kernel.org; Thu, 11 Jan 2018 09:51:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recommendations for balancing as part of regular maintenance?
Date: Thu, 11 Jan 2018 08:51:01 +0000 (UTC)
Message-ID: <pan$a8821$aad3535$b0ccabc8$e01f785b@cox.net>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
        <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
        <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
        <796ad87c-852f-c6a0-7366-5e888d51fc5c@gmail.com>
        <01020160d7768587-50a9392c-7250-4735-9d14-66ff03a161c9-000000@eu-west-1.amazonses.com>
        <3eae37f6-3776-15c9-84ae-568e56abfa7e@rqc.ru>
        <13b5063c-a7bd-5c95-1f6e-16124d385569@gmail.com>
        <pan$5d0d3$29334af9$ed04365a$f8d9747d@cox.net>
        <BE09A377-4702-4D51-ACB9-44950865D26E@thefsb.org>
        <3e353e79-3a13-d2cf-e098-6074a3e17918@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 10 Jan 2018 12:01:42 -0500 as
excerpted:

>> - Some experienced users say that, to resolve a problem with DoUS, they
>> would rather recreate the filesystem than run balance.

> This is kind of independent of BTRFS.  A lot of seasoned system
> administrators are going to be more likely to just rebuild a broken
> filesystem from scratch if possible than repair it simply because it's
> more reliable and generally guaranteed to fix the issue.  It largely
> comes down to the mentality of the individual, and how confident they
> are that they can fix a problem in a reasonable amount of time without
> causing damage elsewhere.

Specific to this one...

I'm known around here for harping on the backup point (hold on, I'll 
explain how that ties in).  A/the sysadmin's first rule of backups: The 
(true) value of your data is defined not by any arbitrary claims, but by 
how many backups of that data you consider it worth having.  No backups 
defines the data as of only trivial value, worth less than the time/
trouble/resources necessary to make that backup.

It therefore follows that in the event of data mishap, a sysadmin can 
always rest happy, because regardless of what might have been lost, what 
actions defined as of *MOST* value, either the data if it was backed up, 
or the time/trouble/resources that would have otherwise gone into that 
backup if not, was *ALWAYS* saved.

Understanding that puts an entirely different spin on backups and data 
mishaps, taking a lot of the pressure off when things /do/ go wrong, 
because one understands that the /true/ value of that data was defined 
long before, and now we're simply dealing with the results of our 
decision to define it that way, only playing out the story we setup for 
ourselves long before.

But how does that apply to the current discussion?

Simply this way:  For someone understanding the above, repair is never a 
huge problem or priority, because the data was either of such trivial 
value as to make it no big deal, or there were backups, thus making this 
particular instance of the data, and the necessity of repair, no big deal.

Once /that/ is understood, the question of repair vs. rebuild from 
scratch (or even simply fail-over to the hot-spare and send the old 
filesystem component devices to be tested for reuse or recycle) becomes 
purely one of efficiency, and the answer ends up being pretty 
predictable, because rebuild from scratch and restore from backup should 
be near 100% reliable on a reasonable/predictable time frame, vs. 
/attempting/ a repair with unknown likelihood of success and a much 
/less/ predictable time frame, especially since there's a non-trivial 
chance one will have to fall back to the rebuild from scratch and backups 
method anyway, after repair attempts fail.


Once one is thinking in those terms and already has backups accordingly, 
even for home or other one-off systems where actual formatting and 
restore from backups is going to be manual and thus will take longer than 
a trivial fix, the practical limits on the extents to which one is 
willing to go to get a fix are pretty narrow, and while one might try a 
couple fixes if they're easy and quick enough, beyond that it very 
quickly becomes restore from backups time if the data was considered 
valuable enough to be worth making them, or simply throw it away and 
start over if the data wasn't considered valuable enough to be worth 
making a backup in the first place.


So it's really independent of btrfs and not reflective on the reliability 
of balance, etc, at all.  It's simply a reflection of understanding the 
realities of possible repair... or not and having to replace anyway... 
without a good estimate on the time required either way... vs. a (near) 
100% guaranteed fix and back in business, in a relatively tightly 
predictable timeframe.  Couple that with the possibility that a repair 
may leave other problems latent and ready to be exposed later, while 
starting over from scratch gives you a "clean starting point", and it's 
pretty much a no-brainer, regardless of the filesystem... or whatever 
else (hardware, software layers other than the filesystem) may be in use.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

