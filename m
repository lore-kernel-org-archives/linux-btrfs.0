Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47382 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2LFGbw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2012 01:31:52 -0500
Date: Wed, 5 Dec 2012 22:31:51 -0800
From: Marc MERLIN <marc@merlins.org>
To: Sylvain Alain <d2racing911@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Question about btrfs snapshot delay and rm -rf delay
Message-ID: <20121206063151.GC20550@merlins.org>
References: <CACR_K2s2NXFJfNknzJLLnQGK6=Sz+6Abs8y7kJfxxynUUaF+cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACR_K2s2NXFJfNknzJLLnQGK6=Sz+6Abs8y7kJfxxynUUaF+cA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 05, 2012 at 11:56:27PM -0500, Sylvain Alain wrote:
> Hi everyone, I'm running btrfs since octobre 2012 and I would like to
> understand 2 behavior that I noticed.
> 
> 1. When I delete a big directory, sometimes it can hang my box for 1
> minutes or so, it seems that's the btrfs lock my SSD.

Doesn't directly answer your question, but if you don't have discard as a
mount option, you should try that.

Which SSD do you have? Do normal big file writes succeed or hang too?

My guess right now is that you don't have discard, and your drive is doing
very slow garbage collection. I had a Crucial C300 that did just that before
it ate itself and my data a month later.
Also check that your drive does not have a firmware update to remove those
hangs.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
