Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031773AbbKEMrG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Nov 2015 07:47:06 -0500
Date: Thu, 5 Nov 2015 13:45:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: debug-tree: Add option to show ondisk
 block without open_ctree
Message-ID: <20151105124535.GP13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1446712380-7654-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1446712380-7654-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446712380-7654-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 05, 2015 at 04:33:00PM +0800, Qu Wenruo wrote:
> Add new option '-B' to show tree block without calling open_ctree.
> It's very useful to debug non-standard super or heavily damaged case.
> 
> As it needs nodesize, also adds a new option '-n' to specify nodesize.
> 
> Normal user should avoid calling it on random bytes, as it won't check
> the validation of the tree block.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

I'm going to postpone this patch for next development cycle. It's
likely that we'll add more options so I'd like to not make it a mess
(similar to what btrfs-corrupt-block options are).
