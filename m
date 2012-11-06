Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26521 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2KFMy0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2012 07:54:26 -0500
Date: Tue, 6 Nov 2012 20:54:14 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Michael =?iso-8859-1?Q?Kj=F6rling?= <michael@kjorling.se>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs handle sudden shutdowns?
Message-ID: <20121106125412.GA32336@gmail.com>
References: <20121106123308.GA2676@yeono.kjorling.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20121106123308.GA2676@yeono.kjorling.se>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 06, 2012 at 12:33:08PM +0000, Michael Kjörling wrote:
> Can btrfs deal reasonably gracefully with sudden shutdowns? (I'm
> mainly thinking of power outages which lead to logical structure
> damage but not physical media damage.)
> 

AFAIK, yes, because btrfs is naturally COW supported, which means
you can roll back to the latest stable situation at least.

> What would be the risk points, file-system-wise?
> 

Data loss is possible if you're not writing with O_SYNC or doing fsync
after a write.

> Can for example a rotating snapshot schedule mitigate some or all
> issues relating to sudden shutdowns, if any? (_For example_, take a
> snapshot every minute, keeping the last five; if the main file system
> fails to mount, then could the most recent usable snapshot be used as
> a fallback, or is it likely to be equally damaged or inconsistent?)
> 

In your case, when we finish creating a snapshot, the whole FS is at a
stable status(both metadata and data is safely written into the disk).

So yes, you can use the latest snapshot as a fallback or backup or something.

I'd note here, btrfs somewhat suffers from ENOSPC cases, where it may
recover itself or get you into readonly state, but you data is safe at least.

thanks,
liubo

> Obviously a UPS or other form of fallback power is preferable to no
> UPS if power outages are a concern, so as to allow a controlled system
> shutdown (or fail-over to a more long-term backup power supply) in the
> event of a prolonged power outage, but I'm wondering about situations
> where such don't exist or even fail.
> 
> -- 
> Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
>                 “People who think they know everything really annoy
>                 those of us who know we don’t.” (Bjarne Stroustrup)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
