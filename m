Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:51996 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681AbaEGMkb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 08:40:31 -0400
Received: from eastrmimpo210 ([68.230.241.225]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20140507124031.XHXA30009.eastrmfepo101.cox.net@eastrmimpo210>
          for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 08:40:31 -0400
Date: Wed, 7 May 2014 05:40:29 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: Marc MERLIN <marc@merlins.org>
Cc: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Subject: Re: How does "btrfs fi show" show full?
Message-ID: <20140507054029.70ecda6f@ws>
In-Reply-To: <yzWd1n0292w7UQp01zWf8e>
References: <20140505005412.GS9061@merlins.org>
	<53670F70.1010509@swiftspirit.co.za>
	<20140505055029.GM10159@merlins.org>
	<pan$1f225$3bfd5829$2b5ac65b$4bb85dc6@cox.net>
	<20140507075902.GL10159@merlins.org>
	<536A1097.2020508@swiftspirit.co.za>
	<yzWd1n0292w7UQp01zWf8e>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 7 May 2014 04:30:30 -0700
Marc MERLIN <marc@merlins.org> wrote:

> > -dusage=85 balances all chunks that up to 85% full. The higher the
> > number, the more work that needs to be done.  
> 
> Aah, right. I see why it's more work. =20 only makes is process the
> few chunks that are up to 20% full which won't be many if your FS
> is almost full.

It's actually even less work than you imply.

Balance only has to rewrite the actual content, not the empty space in
the chunk.  So 20% full means it's only writing 20% of the
(possible/full) content, thus only taking 20% of the time to rewrite
that chunk that it'd take to rewrite a full chunk.

Which is why a usage=5 or 20 goes so fast, even if the system's
actually mostly empty but is all allocated.  With a 20% full chunk it's
rewriting five chunks into one; at 5%, it's rewriting 20 chunks into
one.  That goes pretty fast, even if there's a bunch of them to write!

-- 
Duncan - No HTML messages please, as they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
