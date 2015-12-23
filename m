Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43702 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbbLWCQq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 21:16:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBYyo-0000r8-4L
	for linux-btrfs@vger.kernel.org; Wed, 23 Dec 2015 03:16:42 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 03:16:42 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 03:16:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: defrag vs autodefrag
Date: Wed, 23 Dec 2015 02:16:37 +0000 (UTC)
Message-ID: <pan$b661e$77b105fa$ec9a6b6f$a75b850c@cox.net>
References: <CAC=t97A1S6599aHWCCin7KnFWARs_ebfK6GptAXZQbFnSio7eA@mail.gmail.com>
	<20151221081432.GR26782@carfax.org.uk>
	<CAL3q7H6TGU2rz+zP8hcHxaDGx47nTrCndYvP9ArS+Z0HmZ86=A@mail.gmail.com>
	<20151222203041.GD1586@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Tue, 22 Dec 2015 20:30:41 +0000 as excerpted:

> On Mon, Dec 21, 2015 at 09:28:37AM +0000, Filipe Manana wrote:

>> On Mon, Dec 21, 2015 at 8:14 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

>> > On Sun, Dec 20, 2015 at 07:26:07PM -0600, Donald Pearson wrote:

>> >> I read an implication in a different thread that defrag and
>> >> autodefrag behave differently in that autodefrag is more snapshot
>> >> friendly for COW data.

>> >    Correct.

>> How is that so? Snapshot-aware defrag was disabled almost 2 years ago,
>> and that piece of code is used both by a "manual" defrag (ioctl) and by
>> automatic defrag.

> Then I realised that actually, we're both right. :)
> 
> If autodefrag behaves as you say (and I'm sure it does, since you
> know the code), then when you write data to a file, a piece of the file
> around the write(s) can be copied and written elsewhere by autodefrag.
> That's going to be the same as the manual defrag. However,
> it's a relatively small separation effect that's likely lost in the
> noise. If you rewrite the whole file, then it'll separate the file
> completely -- which is what manual defrag does -- but then, you'd expect
> that behaviour without autodefrag, too.
> 
> So, ultimately, autodefrag *does* separate reflink copies, but only
> near where writes are made to the file, so the overall effect is very
> similar to the effect you'd have from writing to the file without
> autodefrag.
> 
> And I am now better informed than I was before. :)

And now so are we.  Thanks, Hugo.

I /knew/ there had to be a good explanation, as what you were saying just 
didn't fit in with what I knew.  Now I have that explanation, and it 
makes perfect sense. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

