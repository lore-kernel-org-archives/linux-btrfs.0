Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58113 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754444AbcIEOdp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Sep 2016 10:33:45 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bguxv-0000Py-SN
        for linux-btrfs@vger.kernel.org; Mon, 05 Sep 2016 16:33:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Security implications of btrfs receive?
Date: Mon, 5 Sep 2016 14:33:28 +0000 (UTC)
Message-ID: <pan$7ef49$a651be36$e2e9c638$c9b8a81e@cox.net>
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Graham Cobb posted on Mon, 05 Sep 2016 10:59:30 +0100 as excerpted:

> Lastly, even if receive is designed to be very secure, it is possible
> that it could trigger/use code paths in the btrfs kernel code which are
> not normally used during normal file operations and so could trigger
> bugs not normally seen.  Has any work been done on testing for that (for
> example tests using malicious streams, including ones which btrfs-send
> cannot generate)?

As a btrfs user and list regular (not a dev) I'll only answer this part, 
as it's the part I know an answer to. =:^)

Btrfs in general is not fuzz- or malicious-content resistant, yet.  In 
general, btrfs is considered stabilizing, but not yet fully stable, and 
fuzzer-related bug reports, as others, are taken and worked on, but the 
emphasis has been primarily on getting things working and bugs fixed in 
general, not yet on security hardening of any sort, so no claims as to 
btrfs hardening or resistance to malicious content can be made at this 
point, except that it's known to be pretty soft in that regard ATM.

As I said, fuzz-generated bugs are accepted and fixed, but I don't know 
that the intent is to ever "harden" btrfs in that regard, more to simply 
make it resilient to corruptions in general.

There has been, for instance, some discussion of attacks by simply 
leaving maliciously engineered btrfs thumb drives around to be inserted 
and automounted, but the attitude seems to be once they have physical 
access to plug them in, hardening is an exercise in futility, so the 
object isn't to prevent that attack vector, but rather, to make btrfs 
more resilient to normal (as opposed to deliberate) corruption that may 
occur, including that which is easiest to /find/ by fuzzing, but which 
may "just happen" in the real world, as well.

Of course that's not in the specific scope of receive, but I'd put it in 
the same boat.  IOW, treat potential send clients much as you would 
people with accounts on the machine.  If you wouldn't trust them with a 
basic shell account, don't trust their send-streams either.

Meanwhile, the stabilizing but not fully stable and mature status also 
means backups are even more strongly recommended than they would be with 
a fully stable filesystem.  Which means, to the extent that backups can 
mitigate the issue, they'd certainly be prudent and may to that extent 
solve the practical issue.  However, as always, if it's not backed up and 
you lose it, you've simply lost the low-value data that wasn't of enough 
value to you to be worth the hassle of backup, defined by your actions as 
such, regardless of any words claiming the contrary.  To the extent that 
you can trust your people as much as your backups, great, but not having 
those backups really /is/ defining that data as not worth the hassle, 
regardless of whether it's lost to malicious attack or to hardware/
software/wetware bug.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

