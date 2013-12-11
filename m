Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45020 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab3LKS2S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 13:28:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VqoW8-0006OE-43
	for linux-btrfs@vger.kernel.org; Wed, 11 Dec 2013 19:28:16 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 19:28:16 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 19:28:16 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
Date: Wed, 11 Dec 2013 18:27:53 +0000 (UTC)
Message-ID: <pan$dd37b$1a442a8d$594e1d2e$ae5b97e3@cox.net>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
	<01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
	<CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
	<F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com>
	<CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
	<B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com>
	<pan$cd4bd$8058fd9d$d320fdd8$6cb46f0f@cox.net>
	<CAK5rZE5oxr381MhwxdgwJs7HHJC2-_Du+N+FzZUAT2vVynuGcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Imran Geriskovan posted on Wed, 11 Dec 2013 15:19:29 +0200 as excerpted:

> Now, there is one open issue:
> In its current form "-d dup" interferes with "-M". Is it constraint of
> design?
> Or an arbitrary/temporary constraint. What will be the situation if
> there is tunable duplicates?

I believe I answered that, albeit somewhat indirectly, when I explained 
that AFAIK, the fact that -M (mixed mode) has the effect of allowing -d 
dup mode is an accident.  Mixed mode was introduced to fix the very real 
problem of small btrfs filesystems tending to run out of either data or 
metadata space very quickly, while having all sorts of the other resource 
still available, due to inappropriate separate mode allocations.  And it 
fixed that problem rather well, IMO and experience! =:^)

Thus mixed-mode wasn't designed to enable duped data at all, but rather 
to solve a very different problem (which it did very well), and I'm not 
sure the devs even realized that the dup-data it enabled as a side effect 
of forcing data and metadata to the same dup-mode, was a feature people 
might actually want on its own, until after the fact.

So I doubt very much it was a constraint of the design.  If it was 
deliberate, I expect they'd have enabled data=dup mode directly.  Rather, 
it was purely an accident, The fixed the unbalanced small-filesystem 
allocation issue by enabling a mixed mode that as a side effect of 
combining data and metadata into the same blocks, also happened to allow 
data=dup by pure accident.

Actually, it may be that they're only with this thread seeing people 
actually wanting the data=dup option on its own, and why they might want 
it.  Tho it's equally possible they realized that some time ago, shortly 
after accidentally enabling it via mixed-mode, and have it on their list 
since then but have simply been to busy fixing bugs and working on 
features such as the still unfinished raid5/6 code to get to this.  We'll 
only know if they post, but regardless of whether they saw it before or 
not, it'd be pretty hard to avoid seeing it with what this thread has 
blossomed into, so I'm sure they see it now! =:^)

> And more:
> Is "-M" good for everyday usage on large fs for efficient packing?
> What's the penalty? Can it be curable? If so, why not make it default?

I believe I addressed that in the post I just sent, which took me some 
time to compose as I kept ending up way into the weeds on other topics, 
and I ended up deleting multiple whole paragraphs in ordered to rewrite 
them hopefully better, several times.

In brief, I believe the biggest penalties won't apply in your case, since 
they're related to the dup-data effect, and that's actually what you're 
interested in, so they'd apply or not apply regardless of mixed-mode.

But I do expect there are two penalties in general, the first being the 
raw effect of mass duplicating large quantities of data (as opposed to 
generally an order of magnitude smaller metadata only) by default, the 
second having to do with what that does to IO performance, particularly 
uncached directory/metadata reads and the resulting seeks necessary to 
find a file before reading it in the first place.  That's going to 
absolutely murder cold-boot times on spinning rust, to give one highly 
performance-critical example that has been the focus of numerous articles 
and can-I-make-it-boot-faster-than-N-seconds projects over the years.  
Absolutely murder that, as mixed mode very well might on spinning rust, 
and your pet development filesystem will very likely go over like a lead 
balloon!  So it's little wonder they discourage people using it for 
anything but the smallest filesystems, where it is portrayed as a 
workaround to an otherwise very difficult problem!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

