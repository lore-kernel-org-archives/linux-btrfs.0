Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35993 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbcIGOfV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2016 10:35:21 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Christian Rohmann <crohmann@netcologne.de>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: kworker threads may be working saner now instead of using 100% of a CPU core for minutes (Re: Still not production ready)
Date: Wed, 07 Sep 2016 16:28:33 +0200
Message-ID: <6016832.i1fnAvs7A3@merkaba>
In-Reply-To: <a208120b-f6e1-7173-9cfc-e898d50c6f9d@netcologne.de>
References: <8336788.myI8ELqtIK@merkaba> <2314143.TOm3LuQPV3@merkaba> <a208120b-f6e1-7173-9cfc-e898d50c6f9d@netcologne.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 7. September 2016, 11:53:04 CEST schrieb Christian Rohmann:
> On 03/20/2016 12:24 PM, Martin Steigerwald wrote:
> >> btrfs kworker thread uses up 100% of a Sandybridge core for minutes on
> >> 
> >> > random write into big file
> >> > https://bugzilla.kernel.org/show_bug.cgi?id=90401
> > 
> > I think I saw this up to kernel 4.3. I think I didn´t see this with 4.4
> > anymore and definately not with 4.5.
> > 
> > So it may be fixed.
> > 
> > Did anyone else see kworker threads using 100% of a core for minutes with
> > 4.4 / 4.5?
> 
> I run 4.8rc5 and currently see this issue. kworking has been running at
> 100% for hours now, seems stuck there.
> 
> Anything I should look at in order to narrow this down to a root cause?

I didn´t see any issues since my last post, currently running 4.8-rc5 myself.

I suggest you look at kernel log and probably review this thread and my bug 
report for what other information I came up with. Particulary in my case the 
issue only happened when BTRFS allocated all device spaces into chunks, but 
the space in the chunks was not fully used up yet. I.e. when BTRFS had to seek 
for new space in chunks and couldn´t just allocate a new chunk anymore. In 
addition to that your BTRFS configuration, storage configuration, yada. Just 
review what I reported to get an idea.

If you are sufficiently sure that your issue is the same from looking at the 
kernel log… so if the backtraces look sufficiently similar, then I´d add to my 
bug report. Otherwise I´d hope a new one.

Good luck.
-- 
Martin
