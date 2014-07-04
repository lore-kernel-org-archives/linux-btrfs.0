Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37890 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaGDGEK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 02:04:10 -0400
Date: Thu, 3 Jul 2014 23:04:09 -0700
From: Marc MERLIN <marc@merlins.org>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is btrfs related to OOM death problems on my 8GB server with both 3.15.1 and 3.14?
Message-ID: <20140704060409.GW11539@merlins.org>
References: <20140704011938.GO11539@merlins.org> <1937402.nCIA16QR35@xev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1937402.nCIA16QR35@xev>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 04, 2014 at 02:33:06PM +1000, Russell Coker wrote:
> On Thu, 3 Jul 2014 18:19:38 Marc MERLIN wrote:
> > I upgraded my server from 3.14 to 3.15.1 last week, and since then it's been
> > running out of memory and deadlocking (panic= doesn't even work).
> > I downgraded back to 3.14, but I already had the problem once since then.
> 
> Is there any correlation between such problems and BTRFS operations such as 
> creating snapshots or running a scrub/balance?

So far I don't have time data of when it happened, but I'm running new code
to do better logging and hopefully give me a hint of when this is happening.
However since it takes 6 to 48H to trigger, it'll take a little bit before I
can report back.

Thanks
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
