Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43173 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752534AbdDMNTy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2017 09:19:54 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cyef2-0004B0-QO
        for linux-btrfs@vger.kernel.org; Thu, 13 Apr 2017 15:19:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Deduplication tools
Date: Thu, 13 Apr 2017 13:19:37 +0000 (UTC)
Message-ID: <pan$89623$186e96bf$35782bfe$60bde099@cox.net>
References: <37e02202-b9a9-3953-7bc8-92c4d1fd485f@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marat Khalili posted on Thu, 13 Apr 2017 14:06:07 +0300 as excerpted:

> After reading this maillist for a while I became a bit more cautious
> about using various BTRFS features, so decided to ask just in case: is
> it safe to use out-of-band deduplication tools
> <https://btrfs.wiki.kernel.org/index.php/Deduplication>, and which of
> them are considered more stable/mainstream? Also, won't running these
> tools exacerbate often mentioned stability/performance problems with
> too-many-snapshots? Any first-hand experience is very welcome.

Dedupe works by reflinking, which is how snapshots work too, so yes, 
it'll trigger the same general issues.

However, while snapshots will reflink /everything/ in the snapshot, one 
could hope dedupe won't find /that/ many duplicates and thus won't reflink 
at the scale that snapshotting does.  Tho of course if it doesn't find 
at least some reasonable number of duplicates, it's hardly worth the 
trouble to run.

So I'd say it may be worth doing, but do be aware of the scale of dedupe 
reflinking.  What I'd do here is consider that and then count it as 
roughly another snapshot or two, or whatever, depending on how much 
dedupeing you actually get.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

