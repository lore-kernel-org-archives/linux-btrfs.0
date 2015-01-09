Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52220 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbbAILZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 06:25:03 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Peter Waller <peter@scraperwiki.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Robert White <rwhite@pobox.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Regular rebalancing should be unnecessary? (Was: Re: BTRFS free space handling still needs more work: Hangs again)
Date: Fri, 09 Jan 2015 12:25 +0100
Message-ID: <2579943.V74ZtAn7DI@merkaba>
In-Reply-To: <CAFChkqtY-3DHbiHzwPkbr1ahGqcki8iqfs-J_WVDmd7Vz6uc1g@mail.gmail.com>
References: <CAFChkqsgJpA9N8K+CD=CnR-AXj1JeF89YvCvUBjG2C6uKTohWA@mail.gmail.com> <CAFChkqtY-3DHbiHzwPkbr1ahGqcki8iqfs-J_WVDmd7Vz6uc1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 9. Januar 2015, 11:04:32 schrieb Peter Waller:
> Apologies to those receiving this twice.
> 
> On 27 December 2014 at 09:30, Hugo Mills <hugo@carfax.org.uk> wrote:
> > Now, since you're seeing lockups when the space on your disks is
> > 
> > all allocated I'd say that's a bug. However, you're the *only* person
> > 
> > who's reported this as a regular occurrence. Does this happen with all
> > filesystems you have, or just this one?
> 
> I have experienced machine lockups on four separate cloud machines,
> and reported it in a few venues. I think I even reported it on this
> list in the past but I can't find that right now. Here's a bug report
> to Ubuntu-Kernel:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1349711
> 
> Regularly rebalancing the machines and ensuring they have >10% free
> disk (filesystem) and I don't experience this. Yet I read in this
> thread I read that regular rebalancing shouldn't be necessary?
> 
> FWIW, trying to sell BTRFS to my colleagues and they view it as a
> stupid filesystem "like the bad old windows days when you had to
> regularly defragment". They then go on to say they have never
> experienced machine lockups on EXT* (over a fairly significant length
> of time).
> 
> So what can I tell them? Are we just hitting a bug which is likely to
> get fixed, or must we regularly rebalance?
> 
> .. or is regularly rebalancing incorrect and actually regular machine
> lockups are the expected behaviour? :-)

I think it should *not* be required.

But my practical experience differs from what I think, as I described in great 
detail here and in this bugreport:

[Bug 90401] New: btrfs kworker thread uses up 100% of a Sandybridge core for 
minutes on random write into big file

https://bugzilla.kernel.org/show_bug.cgi?id=90401


So I had these hangs so far *only* when BTRFS was not able to reserve 
previously unused and unreserved space on the devices for a new chunk, as long 
as BTRFS can still allocate a new chunk, it stays fast. That said, not in all 
situation where BTRFS can´t do this, it goes slow. So for me it seems that not 
having any unreserved device space to allocate chunks from seems to be a 
*necessary* but no *sufficient* criterion for the kworker uses up 100% of one 
core issue I reported.

I suggest that you add your findings to the bug report and also share details 
there, as it may help to have more data available on when it happens.

That said, still no BTRFS developer looked into the kern.log with Sysrq-T 
triggers I uploaded there.

Robert made a test case which easily triggers the behavior for him, I didn´t 
yet take time to try out this testcase. Maybe you have a chance to? Its 
somewhere in this thread as a little shell script.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=90401#c0

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
