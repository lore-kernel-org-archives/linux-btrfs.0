Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38058 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751453AbdF0NPv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 09:15:51 -0400
Date: Tue, 27 Jun 2017 15:14:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, kilobyte@angband.pl
Subject: Re: [PATCH] btrfs: Remove false alert when fiemap range is smaller
 than on-disk extent
Message-ID: <20170627131440.GW2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170622020121.8381-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170622020121.8381-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 22, 2017 at 10:01:21AM +0800, Qu Wenruo wrote:
> Commit 4751832da990 ("btrfs: fiemap: Cache and merge fiemap extent before
> submit it to user") introduced a warning to catch unemitted cached
> fiemap extent.
> 
> However such warning doesn't take the following case into consideration:
> 
> 0			4K			8K
> |<---- fiemap range --->|
> |<----------- On-disk extent ------------------>|
> 
> In this case, the whole 0~8K is cached, and since it's larger than
> fiemap range, it break the fiemap extent emit loop.
> This leaves the fiemap extent cached but not emitted, and caught by the
> final fiemap extent sanity check, causing kernel warning.
> 
> This patch removes the kernel warning and renames the sanity check to
> emit_last_fiemap_cache() since it's possible and valid to have cached
> fiemap extent.
> 
> Reported-by: David Sterba <dsterba@suse.cz>
> Reported-by: Adam Borowski <kilobyte@angband.pl>
> Fixes: 4751832da990 ("btrfs: fiemap: Cache and merge fiemap extent ...")
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks, added to 4.13 queue.
