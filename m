Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30304 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab3EOC42 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 22:56:28 -0400
Date: Wed, 15 May 2013 10:56:04 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Tim Eggleston <lists@timeggleston.co.uk>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: Defragmentation of large files
Message-ID: <20130515025603.GC20202@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <7f41ae131c619b653da281429fcead79@mail.39.gs>
 <2041896.zZaOgtZsWg@merkaba>
 <fa5698cdba14a3164f014a8c386bc837@mail.39.gs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fa5698cdba14a3164f014a8c386bc837@mail.39.gs>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 11, 2013 at 05:57:11PM +0100, Tim Eggleston wrote:
> 
> >Yes. The command just triggers the defragmentation which takes
> >place in the
> >background. Try a "sync" afterwards :)
> 
> Sorry Martin, I should have specified that I wondered if it was like
> the scrub operation in that respect, so I left it several hours
> before running filefrag again (and seeing that the number of extents
> was unchanged). Top and iostat also don't report any particular
> activity immediately after running the defrag command, so it doesn't
> look like much if anything is happening.
> 
> By the way, this is on a filesystem mounted with -o autodefrag,
> although per the docs I wasn't expecting the auto defragmentation to
> work with the big VM images.

Hi Tim,

Btrfs defrag tries to merge small extents in overall, so maybe the
extents in your big VM images are large enough although there are 4000+
extents.

And autodefrag is also only for small extents(like a write less then
16k).

So, you may check if those extents are already big enough :)

thanks,
liubo

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
