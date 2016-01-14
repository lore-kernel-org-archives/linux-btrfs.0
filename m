Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbcANORO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 09:17:14 -0500
Date: Thu, 14 Jan 2016 15:17:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "'Chris Mason'" <clm@fb.com>, "'btrfs'" <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Fujitsu for 4.5
Message-ID: <20160114141710.GW4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <01ad01d14de4$b9489900$2bd9cb00$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <01ad01d14de4$b9489900$2bd9cb00$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2016 at 05:28:12PM +0800, Zhao Lei wrote:
> This is collection of some bug fix, enhance and cleanup from fujitsu
> against btrfs for v4.5, mainly for reada, plus some small fix and cleanup
> for scrub and raid56.
> 
> All patchs are in btrfs-maillist, rebased on top of integration-4.5.
> 
> Would you please consider merging the following fixes to integration-4.5 branch?

> Zhao Lei (26):
...
>   btrfs: reada: Avoid many times of empty loop
>   btrfs: reada: Move is_need_to_readahead contition earlier
>   btrfs: reada: add all reachable mirrors into reada device list
>   btrfs: reada: bypass adding extent when all zone failed
>   btrfs: reada: Remove level argument in severial functions
>   btrfs: reada: move reada_extent_put to place after __readahead_hook()
>   btrfs: reada: Pass reada_extent into __readahead_hook directly
>   btrfs: reada: Use fs_info instead of root in __readahead_hook's
>     argument
>   btrfs: reada: Jump into cleanup in direct way for __readahead_hook()
>   btrfs: reada: Fix a debug code typo
...
>   btrfs: reada: limit max works count
>   btrfs: reada: simplify dev->reada_in_flight processing

I have reviewed the readahead patches and ack them for 4.5.
