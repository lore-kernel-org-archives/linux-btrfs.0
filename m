Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57066 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaCOEVR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 00:21:17 -0400
Date: Fri, 14 Mar 2014 21:21:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: discard synchronous on most SSDs?
Message-ID: <20140315042116.GK6143@merlins.org>
References: <C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com> <20140314051750.GY6143@merlins.org> <pan$667da$c4955705$c59674a0$a844850c@cox.net> <531C1CC4.701@gmail.com> <C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com> <20140314051750.GY6143@merlins.org> <5289248.oqpgSKG6td@quad> <20140314192605.GD6143@merlins.org> <yq1bnx8y2mi.fsf@sermon.lab.mkp.net> <pan.2014.03.14.20.46.24@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2014.03.14.20.46.24@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 14, 2014 at 08:46:09PM +0000, Holger Hoffstätte wrote:
> On Fri, 14 Mar 2014 15:57:41 -0400, Martin K. Petersen wrote:
> 
> > So right now I'm afraid we don't have a good way for a user to determine
> > whether a device supports queued trims or not.
> 
> Mount with discard, unpack kernel tree, sync, rm -rf tree.
> If it takes several seconds, you have sync discard, no?

Mmmh, interesting point.

legolas:/usr/src# time rm -rf linux-3.14-rc5
real	0m1.584s
user	0m0.008s
sys	0m1.524s

I remounted my FS with remount,nodiscard, and the time was the same.

> This changed somewhere around kernel 3.8.x; before that it used to be 
> acceptably fast. Since then I only do batch trims, daily (server) or 
> weekly (laptop).

I'm never really timed this before. Is it supposed to be faster than 1.5s on
a fast SSD?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
