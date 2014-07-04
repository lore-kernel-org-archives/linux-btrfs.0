Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:43164 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaGDEdL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 00:33:11 -0400
From: Russell Coker <russell@coker.com.au>
To: Marc MERLIN <marc@merlins.org>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is btrfs related to OOM death problems on my 8GB server with both 3.15.1 and 3.14?
Date: Fri, 04 Jul 2014 14:33:06 +1000
Message-ID: <1937402.nCIA16QR35@xev>
In-Reply-To: <20140704011938.GO11539@merlins.org>
References: <20140704011938.GO11539@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 3 Jul 2014 18:19:38 Marc MERLIN wrote:
> I upgraded my server from 3.14 to 3.15.1 last week, and since then it's been
> running out of memory and deadlocking (panic= doesn't even work).
> I downgraded back to 3.14, but I already had the problem once since then.

Is there any correlation between such problems and BTRFS operations such as 
creating snapshots or running a scrub/balance?

Back in ~3.10 days I had serious problems with BTRFS memory use when removing 
multiple snapshots or balancing.  But at about 3.13 they all seemed to get 
fixed.

I usually didn't have a kernel panic when I had such problems (although I 
sometimes had a system lock up solid such that I couldn't even determine what 
it's problem was).  Usually the Oom handler started killing big processes such 
as chromium when it shouldn't have needed to.

Note that I haven't verified that the BTRFS memory use is reasonable in all 
such situations.  Merely that it doesn't use enough to kill my systems.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

