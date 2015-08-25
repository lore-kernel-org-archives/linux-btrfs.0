Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fed1rmfepi107.cox.net ([68.230.241.138]:40549 "EHLO
	fed1rmfepi107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbbHYXv7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 19:51:59 -0400
Received: from eastrmimpo306 ([68.230.241.238]) by eastrmfepo102.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20150825232727.IFSH6891.eastrmfepo102.cox.net@eastrmimpo306>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 25 Aug 2015 19:27:27 -0400
Date: Tue, 25 Aug 2015 16:32:09 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cannot remove empty directory pretending it is not empty
Message-ID: <20150825163209.18032ac7@ws>
In-Reply-To: <9Aea1r00U2Q6ekd01Aebva>
References: <2017000.AEG9PyVY17@zafu>
	<pan$d4557$9c42de4e$12e74017$2f692aea@cox.net>
	<1474026.LQOmDW8fG5@tethys>
	<2139681.geeI7cQtEN@tethys>
	<pan$d11ec$99fb59da$ae69a869$20c43d39@cox.net>
	<9Aea1r00U2Q6ekd01Aebva>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 25 Aug 2015 22:38:32 +0000
Hugo Mills <hugo@carfax.org.uk> wrote:

> > Btrfs quotas just don't work well at this point, being both not
> > always reliable, and dramatically increasing the scaling issues.  
> 
> Even after the recent rewrite? I'd expect that to drop back to
> "unproven".

There was a regression reported there, which, if I read the following
discussion correctly, is getting bandaided for 4.2, with a proper fix
still in development and likely not ready for the 4.3 merge window,
making it 4.4 material.

So from my quota-sidelines read anyway, we're looking at 4.4 for
"unproven", continuing to limp along until then, and given the historic
toughness of the quota problem in btrfs in general, experience is on
the side of not setting any plans to actually rely on it even then.
Hopefully this time it's good, solid, correct code that might be
initially buggy but at least won't need another rewrite, but... like
many btrfs features, while they do appear in good solid form eventually,
original estimates turn out to be /wildly/ optimistic.

-- 
Duncan - No HTML messages please; they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
