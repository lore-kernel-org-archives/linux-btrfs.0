Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:34759 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab3EXMkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 May 2013 08:40:09 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id B4A567C068B
	for <linux-btrfs@vger.kernel.org>; Fri, 24 May 2013 06:40:08 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <519F2659.3050006@itwm.fraunhofer.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <knl3ke$n7t$1@ger.gmane.org>
 <20130523131118.4907.45217@localhost.localdomain>
 <519E1821.5070507@itwm.fraunhofer.de>
 <20130523133418.4907.21116@localhost.localdomain>
 <519E6F04.5000900@itwm.fraunhofer.de>
 <20130523193741.4907.41422@localhost.localdomain>
 <519E71E0.2060301@itwm.fraunhofer.de>
 <20130523203337.4907.25234@localhost.localdomain>
 <519F2659.3050006@itwm.fraunhofer.de>
Message-ID: <20130524124006.4907.79517@localhost.localdomain>
Subject: Re: raid6: rmw writes all the time?
Date: Fri, 24 May 2013 08:40:06 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Bernd Schubert (2013-05-24 04:35:37)
> Hello Chris,
> 
> On 05/23/2013 10:33 PM, Chris Mason wrote:
> > But I was using 8 drives.  I'll try with 12.
> >>
> > My benchmarks were on flash, so the rmw I was seeing may not have had as
> > big an impact.
> 
> 
> I just further played with it and simply introduced a requeue in 
> raid56_rmw_stripe() if the rbio is 'younger' than 50 jiffies. I can 
> still see reads, but by a factor 10 lower than before. And this is 
> sufficient to bring performance almost to that of direc-io.
> This is certainly no upstream code, I hope I find some time over the 
> weekend to come up with something better.

Interesting.  This probably shows that we need to do a better job of
maintaining a plug across the writepages calls, or that we need to be
much more aggressive in writepages to add more pages once we've started.

> 
> Btw, I also noticed the cache logic copies pages from those rmw-threads. 
> Well, this a numa system and memory bandwith is terribly bad from the 
> remote cpu. These worker threads probably should numa aware and only 
> handle rbios from their own cpu.

Yes, all of the helpers (especially crc and parity) should be made numa aware.

-chris

