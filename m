Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbaG2LgS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 07:36:18 -0400
Date: Tue, 29 Jul 2014 13:36:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Return right extent when fiemap gives
 unaligned offset and len.
Message-ID: <20140729113616.GM1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1406252943-5834-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1406252943-5834-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 25, 2014 at 09:49:03AM +0800, Qu Wenruo wrote:
> When page aligned start and len passed to extent_fiemap(), the result is
> good, but when start and len is not aligned, e.g. start = 1 and len =
> 4095 is passed to extent_fiemap(), it returns no extent.
> 
> The problem is that start and len is all rounded up which causes the
> problem. This patch will round down start and round up (start + len) to
> return right extent.
> 
> Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

> ---
> changelog:
> v2: reword the description(ALIGN rounds up, not rounds down).

JFYI, if you're just rewording the changelog, you can keep the
reviewed-by tags.
