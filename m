Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35273 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab3HWHmz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 03:42:55 -0400
Date: Fri, 23 Aug 2013 15:42:38 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Florian Lindner <mailinglists@xgm.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Deduplication
Message-ID: <20130823074236.GA2229@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAJtBfr-ZncC9iOB=GegDXhOsayEXVk6gfu2P2X8PeeOQk3hZ3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJtBfr-ZncC9iOB=GegDXhOsayEXVk6gfu2P2X8PeeOQk3hZ3Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Thu, Aug 22, 2013 at 09:28:09PM +0200, Florian Lindner wrote:
> Hello,
> 
> some questions regarding btrfs deduplication.
> 
> - What is the state of it? Is it "safe" to use?
> https://btrfs.wiki.kernel.org/index.php/Deduplication does not yield
> much information.

For inband dedup, it's experimental because it introduces some format changes.

> 
> - https://pypi.python.org/pypi/bedup says: "bedup looks for new and
> changed files, making sure that multiple copies of identical files
> share space on disk. It integrates deeply with btrfs so that scans are
> incremental and low-impact."
> 
> Is is file-based deduplcation only or is there also a block-based
> mode? Does not seem so according to the docs.

Both inband dedup and offband dedup patchset are floating on the list, and
inband is block-based, but I'm not sure about offband dedup.

-liubo

> 
> If so, what is the advantage to numerous other tools that replace
> duplicates by hard links? Performance?
> 
> Thanks,
> 
> Florian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
