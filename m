Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45026 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbdHNCtM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 22:49:12 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dh5R2-0004Yd-2J
        for linux-btrfs@vger.kernel.org; Mon, 14 Aug 2017 04:48:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs data recovery
Date: Mon, 14 Aug 2017 02:48:47 +0000 (UTC)
Message-ID: <pan$effce$b89465ea$9a575516$efd8eafa@cox.net>
References: <1386d7aa-10c2-4463-a26b-50f2b022f6b6@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christian Rene Thelen posted on Sun, 13 Aug 2017 19:12:48 +0200 as
excerpted:

> I have formated an encrypted disk, containing a LVM with a btrfs system.
> 
> All superblocks appear to be destroyed; the btrfs-progs tools can't find
> the root tree anymore and scalpel, binwalk, foremost & co return only
> scrap. The filesystem was on an ssd and mounted with -o compression=lzo.
> 
> How screwed am I? Any chances to recover some files? Is there a
> plausible way to rebuild the superblock manually? Checking the raw image
> with xxd gives me not a single readable word.
> 
> I managed to decrypt the LV and dd it to an image. What can I do?

Sysadmin's rule #1 of backups:  The value of your data is not defined by
arbitrary claims, but by the number of backups you consider it worth the
trouble to make.  No backups, you defined the data as worth less to you
than the trouble and resources it would take to make them, and unlike
words, actions, or lack thereof, are facts that don't lie.

So regardless, you're not screwed, because if you had backups you can
always recover from them, and if you didn't, then you considered the time
and trouble to make backups worth more than the data itself, so in either
case, you saved what your actions defined as of most importance to you,
and actions don't lie.

It sounds like you can be happy that you saved the real important time and
resources you would have otherwise put into making those backups, which
means you can be happy, because the data was self-evidently worth less to
you than the time and resources you saved.

=:^)

Meanwhile/alternatively, because I've learned the value of my data as
defined by backups too... Consider the lesson of Hurricane Katrina.

During the hurricane and the immediate aftermath, Intercosmos/drectNIC (a
hosting company located in New Orleans) had a small team that stayed on-
site, keeping the servers up and the data available, and blogging about
their experience.

Many sysadmins and other technically inclined users were glued to that
blog, living for each update.  I was certainly among them. (2005)

https://www.feld.com/archives/2005/09/blogging-from-a-new-orleans-data-center.html

But at the same time I was seeing the wider news out of New Orleans.  The
looting.  The people who /thought/ they were safe on that bridge, only to
be slain by the police that were /supposed/ to be protecting them.  The
aftermath with the raw sewage, and bloated and decaying animal and
occasional human bodies floating by.

Of course that got me thinking about /real/ tragedy.  I am (If you are)
still relatively healthy, have a home to go to at night, food on the
table, in the fridge, or money to buy it at the burger/taco/sandwich shop
down the street, and a family and/or friends likewise fortunate, you have
the /truly/ important stuff, and with a bit of perspective, the triviality
of loss of some data in the bigger picture can be seen.  Even if that data
was irreplaceable family photos, consider how much more fortunate you are
than the folks who just lost all that and more to a fire or flood... or as
refugees just robbed of the last /truly/ valuable thing they had other
than life itself, their family, or part of it, washed overboard.

https://en.wikipedia.org/wiki/Death_of_Alan_Kurdi (2015)

And if your lack of backups defined the data as trivial and you now regret
it, well... be glad you'll live another day and get the chance to create
more... this time, defining the data as more valuable than what you lost,
by having more and/or more frequently updated backups thereof.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

