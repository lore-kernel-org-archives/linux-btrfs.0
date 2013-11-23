Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:49725 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674Ab3KWWKd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Nov 2013 17:10:33 -0500
Date: Sat, 23 Nov 2013 23:10:24 +0100
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: Andrea Mazzoleni <amadvance@gmail.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Subject: Re: Triple parity and beyond
Message-ID: <20131123221024.GA10555@lazy.lzy>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
 <20131120222903.GA3654@lazy.lzy>
 <CAGKKSfUejP=pb6HHF-48ciu5GSSd_ZCZMXHyL6iHLcQHvDs8yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGKKSfUejP=pb6HHF-48ciu5GSSd_ZCZMXHyL6iHLcQHvDs8yQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Andrea,

On Sat, Nov 23, 2013 at 08:55:08AM +0100, Andrea Mazzoleni wrote:
> Hi Piergiorgio,
> 
> > How about par2? How does this work?
> I checked the matrix they use, and sometimes it contains some singular
> square submatrix.
> It seems that in GF(2^16) these cases are just less common. Maybe they
> were just unnoticed.
> 
> Anyway, this seems to be an already known problem for PAR2, with an
> hypothetical PAR3 fixing it:
> 
> http://sourceforge.net/p/parchive/discussion/96282/thread/d3c6597b/

you did a pretty damn good research work!

Maybe you should consider to contact them too.
I'm not sure if your approach can be extended
to GF(2^16), I guess yes, in that case they
might be interested too.

bye,

-- 

piergiorgio
