Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220AbaGXMR0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 08:17:26 -0400
Date: Thu, 24 Jul 2014 14:17:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Return right extent when fiemap gives unaligned
 offset and len.
Message-ID: <20140724121721.GW1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1405648543-8966-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405648543-8966-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 18, 2014 at 09:55:43AM +0800, Qu Wenruo wrote:
> When page aligned start and len passed to extent_fiemap(), the result is
> good, but when start and len is not aligned, e.g. start = 1 and len =
> 4095 is passed to extent_fiemap(), it returns no extent.
> 
> The problem is that start and len is all rounded down which causes the
> problem.

ALIGN rounds up, not down. So the wrong rounding will use incorrect start
(4096) and finds no extents if there's eg. only one [0,4095].

> This patch will round down start and round up (start + len) to
> return right extent.
> 
> Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
