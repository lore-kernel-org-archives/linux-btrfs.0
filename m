Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49648 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755929AbcIKRL0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 13:11:26 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bj8Hn-0002ov-EK
        for linux-btrfs@vger.kernel.org; Sun, 11 Sep 2016 19:11:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is stability a joke?
Date: Sun, 11 Sep 2016 17:11:05 +0000 (UTC)
Message-ID: <pan$3e415$d77ee400$5f659e58$3c9cc8bb@cox.net>
References: <57D51BF9.2010907@online.no> <57D53E3A.1030106@online.no>
        <15194548.valIGHoaRh@merkaba> <2682119.DRdtbgPpNZ@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sun, 11 Sep 2016 14:05:03 +0200 as excerpted:

> Just add another column called "Production ready". Then research / ask
> about production stability of each feature. The only challenge is: Who
> is authoritative on that? I´d certainly ask the developer of a feature,
> but I´d also consider user reports to some extent.

Just a note that I'd *not* call it "production ready".  Btrfs in general 
is considered "stabilizing, not yet fully stable and mature", as I 
normally put it.  Thus, I'd call that column "stabilized to the level of 
btrfs in general", or perhaps just "stabilized", with a warning note with 
the longer form.

Because "production ready" can mean many things to many people.  The term 
seems to come from a big enterprise stack, with enterprise generally both 
somewhat conservative in deployment, and having backups and often hot-
spare-redundancy available, because lost time is lost money, and lost 
data has serious legal and financial implications.

But by the same token, /because/ they have the resources for fail-over, 
etc, large enterprises can and occasionally do deploy still stabilizing 
technologies, knowing they have fall-backs if needed, that smaller 
businesses and individuals often don't have.

Which is in my mind what's going on here.  Some places may be using it in 
production, but if they're sane, they have backups and even fail-over 
available.  Which is quite a bit different than saying it's "production 
ready" on an only machine, possibly with backups available but which 
would take some time to bring systems back up, and if it's a time is 
money environment, then...

Which again is far different than individual users, some of which 
unfortunately may not even have backups.

If "production ready" is taken to be the first group, with fail-overs 
available, etc, it means something entirely different than it does in the 
second and third cases, and I'd argue that while btrfs is ready for the 
first and can in some cases be ready for the second and the third if they 
have backups, it's definitely *not* "production ready" for the segment of 
the third that don't even have backups.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

