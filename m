Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41568 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbaEEBps (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 21:45:48 -0400
Date: Sun, 4 May 2014 18:04:29 -0700
From: Marc MERLIN <marc@merlins.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Copying related snapshots to another server with btrfs
 send/receive?
Message-ID: <20140505010429.GC10159@merlins.org>
References: <20140504031231.GG9061@merlins.org>
 <5365E932.20602@swiftspirit.co.za>
 <20140504072829.GK9061@merlins.org>
 <5365F23E.8070009@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5365F23E.8070009@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 04, 2014 at 09:54:38AM +0200, Brendan Hide wrote:
> Yes, -p (parent) and -c (clone source) are the only ways I'm aware
> of to push subvolumes across while ensuring data-sharing
> relationship remains intact. This will end up being much the same as
> doing incremental backups:
> From the man page section on -c:
>     "You must not specify clone sources unless you guarantee that
> these snapshots are exactly in the same state on both sides, the
> sender and the receiver. It is allowed to omit the '-p <parent>'
> option when '-c <clone-src>' options are given, in which case 'btrfs
> send' will determine a suitable parent among the clone sources
> itself."

Right. I had read that, but it was not super clear to me how it can be
useful, especially if it's supposed to find the source clone by itself.
>From what you said and what I read, I think the source might be allowed
to be read write, otherwise it would be simpler for btrfs send to know
that the source has not changed.

I think I'll have to do more testing with this when I get some time.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
