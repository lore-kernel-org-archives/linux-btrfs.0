Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47100 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbcGDMUR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 08:20:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 70DC9AC5D
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Jul 2016 12:20:16 +0000 (UTC)
Date: Mon, 4 Jul 2016 14:20:42 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs-progs: check improve 'checking extents'
 scalability
Message-ID: <20160704122042.GG13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466709966-31506-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466709966-31506-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 03:26:03PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> While running xfstests generic/291, which creates a single file populated
> with reflinks to the same extent, I found that fsck had been running for
> hours.  perf top lead me to find_data_backref as the culprit, and a litte
> more digging made it clear: For every extent record we add, we iterate
> the entire list first.  My test case had ~2M records.  That math doesn't
> go well.
> 
> This patchset converts the extent_backref list to an rbtree.  The test
> that used to run for more than 8 hours without completing now takes
> less than 20 seconds.
> 
> -Jeff
> 
> ---
> 
> Jeff Mahoney (3):
>   btrfs-progs: check: add helpers for converting between structures
>   btrfs-progs: check: supplement extent backref list with rbtree
>   btrfs-progs: check: switch to iterating over the backref_tree

Applied (with some trivial fixups), thanks.
