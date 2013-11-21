Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:50112 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab3KUUFy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 15:05:54 -0500
Date: Thu, 21 Nov 2013 21:05:45 +0100
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: David Brown <david.brown@hesbynett.no>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
        Andrea Mazzoleni <amadvance@gmail.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, hpa@zytor.com, creamyfish@gmail.com
Subject: Re: Triple parity and beyond
Message-ID: <20131121200545.GB1916@lazy.lzy>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
 <20131119181237.GA3666@lazy.lzy>
 <528C9297.9030801@hesbynett.no>
 <20131120215939.GA2622@lazy.lzy>
 <528DDCC9.7050701@hesbynett.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <528DDCC9.7050701@hesbynett.no>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 21, 2013 at 11:13:29AM +0100, David Brown wrote:
[...]
> Ah, you are trying to find which disk has incorrect data so that you can
> change just that one disk?  There are dangers with that...

Hi David,

> <http://neil.brown.name/blog/20100211050355>

I think we already did the exercise, here :-)

> If you disagree with this blog post (and I urge you to read it in full

We discussed the topic (with Neil) and, if I
recall correctly, he is agaist having an
_automatic_ error detectio and correction _in_
kernel.
I fully agree with that: user space is better
and it should not be automatic, but it should
do things under user control.

The current "check" operetion is pretty poor.
It just reports how many mismatches, it does
not even report where in the array.
The first step, independent from how many
parities one has, would be to tell the user
where the mismatches occurred, so it would
be possible to check the FS at that position.
Having a multi parity RAID allows to check
even which disk.
This would provide the user with a more
comprehensive (I forgot the spelling)
information.

Of course, since we are there, we can
also give the option to fix it.
This would be much likely a "fsck".

> first), then this is how I would do a "smart" stripe recovery:
> 
> First calculate the parities from the data blocks, and compare these
> with the existing parity blocks.
> 
> If they all match, the stripe is consistent.
> 
> Normal (detectable) disk errors and unrecoverable read errors get
> flagged by the disk and the IO system, and you /know/ there is a problem
> with that block.  Whether it is a data block or a parity block, you
> re-generate the correct data and store it - that's what your raid is for.

That's not always the case, otherwise
having the mismatch count would be useless.
The issue is that errors appear, whatever
the reason, without being reported by the
underlying hardware.
 
> If you have no detected read errors, and there is one parity
> inconsistency, then /probably/ that block has had an undetected read
> error, or it simply has not been written completely before a crash.
> Either way, just re-write the correct parity.

Why re-write the parity if I can get
the correct data there?
If can be sure that one data block is
incorrect and I can re-create properly,
that's the thing to do.
 
> Remember, this is not a general error detection and correction scheme -

It is not, but it could be. For free.

bye,

-- 

piergiorgio
