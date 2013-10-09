Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39021 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab3JICpY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 22:45:24 -0400
Date: Wed, 9 Oct 2013 10:45:03 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not defrag extent root in ioctl
Message-ID: <20131009024502.GA11033@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1381227570-6829-1-git-send-email-bo.li.liu@oracle.com>
 <20131008141623.GB4322@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131008141623.GB4322@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 08, 2013 at 04:16:23PM +0200, David Sterba wrote:
> On Tue, Oct 08, 2013 at 06:19:30PM +0800, Liu Bo wrote:
> > We can't defrag the extent root without deadlock.
> 
> Deadlock under what circumstance? Eg. with snapshot aware defag turned
> on or extent tree cannot be safely defragmented at all?

Hmm, my assumption is based on the comments in btrfs_defrag_leaves(),

Quoting,
"there's recursion here right now in the tree locking, we can't defrag the
extent root without deadlock."

But I just made a quick test, defragment on extent root seems to be good.

I need to dig this more, thanks for pointing out that, Dave.

-liubo
