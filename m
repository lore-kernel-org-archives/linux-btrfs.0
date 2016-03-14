Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbcCNJVt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 05:21:49 -0400
Date: Mon, 14 Mar 2016 10:21:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/8] btrfs-progs: Basic framework for dedup command group
Message-ID: <20160314092124.GY18908@suse.cz>
Reply-To: dsterba@suse.cz
References: <1455776300-11234-1-git-send-email-quwenruo@cn.fujitsu.com>
 <56E67DD8.6000409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56E67DD8.6000409@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 05:01:12PM +0800, Qu Wenruo wrote:
> Hi David,
> 
> Just like the kernel naming change, does btrfs-progs also need to change 
> 'dedup' to 'dedupe'?

Yes please.

> For kernel part, I have changed all 'dedup' to 'dedupe', including 
> filename (dedup.c -> dedupe.c), function name and even comment.
> 
> I'm a little curious about should btrfs-progs also keep the naming to 
> dedupe.
> 
> Like "btrfs dedupe enable" or "btrfs deduplication enable"?

I think nobody will want to type 'deduplication' :) The command names
can be shortened (as far as they're unique), so both ways will work
'dedup' and 'dedupe' and I don't think we'll ever add anything with the
same prefix 'dedup', so it should be safe.
