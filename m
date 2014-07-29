Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaG2Maq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 08:30:46 -0400
Date: Tue, 29 Jul 2014 14:30:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Return right extent when fiemap gives unaligned
 offset and len.
Message-ID: <20140729123045.GQ1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1405648543-8966-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140724121721.GW1553@twin.jikos.cz>
 <53D1B2E1.60008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <53D1B2E1.60008@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 25, 2014 at 09:29:05AM +0800, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: Re: [PATCH] btrfs: Return right extent when fiemap gives unaligned
> offset and len.
> From: David Sterba <dsterba@suse.cz>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2014年07月24日 20:17
> >On Fri, Jul 18, 2014 at 09:55:43AM +0800, Qu Wenruo wrote:
> >>When page aligned start and len passed to extent_fiemap(), the result is
> >>good, but when start and len is not aligned, e.g. start = 1 and len =
> >>4095 is passed to extent_fiemap(), it returns no extent.
> >>
> >>The problem is that start and len is all rounded down which causes the
> >>problem.
> >ALIGN rounds up, not down. So the wrong rounding will use incorrect start
> >(4096) and finds no extents if there's eg. only one [0,4095].
> Sorry for the wrong description in patch.
> Should I reword the patch and send a v2 patch?

You already did, but yes please.
