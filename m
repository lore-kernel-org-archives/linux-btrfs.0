Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49508 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396AbaCSWhZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 18:37:25 -0400
Date: Wed, 19 Mar 2014 15:37:23 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
Message-ID: <20140319223723.GU18959@merlins.org>
References: <20140319154513.GQ6143@merlins.org> <5329C3B8.8050204@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5329C3B8.8050204@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 19, 2014 at 12:20:08PM -0400, Chris Mason wrote:
> On 03/19/2014 11:45 AM, Marc MERLIN wrote:
> >My server died last night during a btrfs send/receive to a btrfs radi5 
> >array
> >
> >Here are the logs. Is this anything known or with a possible workaround?
> >
> >Thanks,
> >Marc
> >
> >btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
> 
> This is an order 1 atomic allocation from the mvs driver, we really 
> should not be depending on that to get IO done.  A quick search and it 
> looks like we're allocating MVS_SLOT_BUF_SZ (8192) bytes.
> 
> You could try bumping the lowmem reserves.

Thanks for the info.

So for now, I have
CONFIG_X86_RESERVE_LOW=64

This is the option we're talking about, right?

Should I double it?

For now, I have the copy running again, and it's been going for 8 hours
without failure on the old kernel but of course that doesn't mean my 2TB
copy will complete without hitting the bug again.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
