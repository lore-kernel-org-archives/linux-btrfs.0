Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47127 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754733AbeEaMYo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 08:24:44 -0400
Date: Thu, 31 May 2018 14:21:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: print-tree: remove dead code from
 btrfs_print_tree
Message-ID: <20180531122158.GX3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180409064044.1699-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180409064044.1699-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2018 at 02:40:44PM +0800, Lu Fengqi wrote:
> Since the out label has been deleted, this free_extent_buffer will never
> be executed.
> 
> Fixes: f37ae8d275c2 ("btrfs-progs: print-tree: Enhance warning on tree block level mismatch and error handling")
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Applied, thanks.
