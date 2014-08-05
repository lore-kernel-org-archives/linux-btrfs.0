Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50322 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546AbaHEIGa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Aug 2014 04:06:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XEZlL-0006uN-AV
	for linux-btrfs@vger.kernel.org; Tue, 05 Aug 2014 10:06:27 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Aug 2014 10:06:27 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Aug 2014 10:06:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC with mkdir and rename
Date: Tue, 5 Aug 2014 08:06:12 +0000 (UTC)
Message-ID: <pan$dbb9d$e1133995$a123d619$8316b9ab@cox.net>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
	<17833067.mzxAL4oqZq@quad>
	<CAFvQSYRtZZz00u5fg8h0bjT-W67URtNMqh6F7SZxgZVYXNyR8Q@mail.gmail.com>
	<1875052.8GFlAMfPzL@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Samuel posted on Mon, 04 Aug 2014 20:24:46 +1000 as excerpted:

> On Mon, 4 Aug 2014 11:56:46 AM Clemens Eisserer wrote:
> 
>> Which doesn't protect the *average* user from running into issues like
>> this.
> 
> No, but they need to be aware of it.

Actually, an ordinary user/admin /should/ have no more need to be aware 
of it than they do on any other filesystem.  Since that issue doesn't 
occur on ext* or reiserfs, to pick two examples I'm familiar with, they 
shouldn't need to worry about it on btrfs either.  But then, just such an 
"ordinary admin" shouldn't yet be running btrfs on their system, as it's 
simply not to that point of readiness and maturity yet.

Which is why I'm not particularly happy with seeing all the "btrfs is 
still not stable, use at your own risk" warnings disappearing.  With them 
there, people who chose to run btrfs /could/ be expected to have done 
their research and have btrfs specific knowledge such as this, because 
btrfs was clearly marked as /not/ ready for "ordinary users" not prepared 
to do such research on their own.

But now that those warnings are all being removed, btrfs should "just 
work" for all those "ordinary users".

But it doesn't.  Btrfs is still special and requires btrfs-domain 
specific knowledge to properly administer, as the fixes that would remove 
that requirement, in this case perhaps a background thread that would 
check for data/metadata imbalance and at least log a warning suggesting a 
rebalance, if not triggering that rebalance on its own, simply aren't 
there yet.

IMO, without those fixes, btrfs is still experimental, or at least not 
entirely stable yet and requiring btrfs-domain-specific knowledge, and 
should keep the warnings saying exactly that.  Unfortunately...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

