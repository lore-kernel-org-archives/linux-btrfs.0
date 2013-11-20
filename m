Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:33865 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379Ab3KTV7r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 16:59:47 -0500
Date: Wed, 20 Nov 2013 22:59:39 +0100
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: David Brown <david.brown@hesbynett.no>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
        Andrea Mazzoleni <amadvance@gmail.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, hpa@zytor.com, creamyfish@gmail.com
Subject: Re: Triple parity and beyond
Message-ID: <20131120215939.GA2622@lazy.lzy>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
 <20131119181237.GA3666@lazy.lzy>
 <528C9297.9030801@hesbynett.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <528C9297.9030801@hesbynett.no>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 20, 2013 at 11:44:39AM +0100, David Brown wrote:
[...]
> > In RAID-6 (as per raid6check) there is an easy way
> > to verify where an HDD has incorrect data.
> > 
> 
> I think the way to do that is just to generate the parity blocks from
> the data blocks, and compare them to the existing parity blocks.

Uhm, the generic RS decoder should try all
the possible combination of erasure and so
detect the error.
This is unfeasible already with 3 parities,
so there are faster algorithms, I believe:

Peterson–Gorenstein–Zierler algorithm
Berlekamp–Massey algorithm

Nevertheless, I do not know too much about
those, so I cannot state if they apply to
the Cauchy matrix as explained here.

bye,

-- 

piergiorgio
