Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56411 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614Ab3LLP5i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 10:57:38 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <clm@fb.com>
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
 <01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
 <CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
 <F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com>
 <CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
 <B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com>
 <pan$cd4bd$8058fd9d$d320fdd8$6cb46f0f@cox.net>
 <CAK5rZE5oxr381MhwxdgwJs7HHJC2-_Du+N+FzZUAT2vVynuGcw@mail.gmail.com>
 <pan$dd37b$1a442a8d$594e1d2e$ae5b97e3@cox.net>
In-Reply-To: <pan$dd37b$1a442a8d$594e1d2e$ae5b97e3@cox.net>
Message-ID: <20131212155720.11479.7400@ret>
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
Date: Thu, 12 Dec 2013 10:57:33 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Duncan (2013-12-11 13:27:53)
> Imran Geriskovan posted on Wed, 11 Dec 2013 15:19:29 +0200 as excerpted:
> 
> > Now, there is one open issue:
> > In its current form "-d dup" interferes with "-M". Is it constraint of
> > design?
> > Or an arbitrary/temporary constraint. What will be the situation if
> > there is tunable duplicates?
> 
> I believe I answered that, albeit somewhat indirectly, when I explained 
> that AFAIK, the fact that -M (mixed mode) has the effect of allowing -d 
> dup mode is an accident.  Mixed mode was introduced to fix the very real 
> problem of small btrfs filesystems tending to run out of either data or 
> metadata space very quickly, while having all sorts of the other resource 
> still available, due to inappropriate separate mode allocations.  And it 
> fixed that problem rather well, IMO and experience! =:^)
> 
> Thus mixed-mode wasn't designed to enable duped data at all, but rather 
> to solve a very different problem (which it did very well), and I'm not 
> sure the devs even realized that the dup-data it enabled as a side effect 
> of forcing data and metadata to the same dup-mode, was a feature people 
> might actually want on its own, until after the fact.
> 
> So I doubt very much it was a constraint of the design.  If it was 
> deliberate, I expect they'd have enabled data=dup mode directly.  Rather, 
> it was purely an accident, The fixed the unbalanced small-filesystem 
> allocation issue by enabling a mixed mode that as a side effect of 
> combining data and metadata into the same blocks, also happened to allow 
> data=dup by pure accident.

For me anyway, data=dup in mixed mode is definitely an accident ;)

I personally think data dup is a false sense of security, but drives
have gotten so huge that it may actually make sense in a few
configurations.

Someone asks for it roughly once a year, so it probably isn't a horrible
idea.

The biggest problem with mixed mode is just that it isn't very common.
You'll end up finding corners that others do not.  Also mixed mode
forces your metadata block size down to 4K, which does increase
fragmentation over time.  The new default of 16K is overall much faster.

-chris
