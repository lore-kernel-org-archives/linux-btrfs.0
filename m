Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53143 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756234AbcJMP7W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 11:59:22 -0400
Date: Thu, 13 Oct 2016 17:58:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Fix stack overflow for checking qgroup on
 tree reloc tree
Message-ID: <20161013155809.GZ11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161006091332.12836-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161006091332.12836-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 06, 2016 at 05:13:32PM +0800, Qu Wenruo wrote:
> For tree reloc tree whose level is >= 2, the root node's parent will
> point to itself.
> In this case it will make btrfsck overflow its stack and cause segfault.
> 
> While for tree reloc tree, it doesn't affect qgroup and kernel can
> handle it well.
> 
> So add tree reloc tree check for qgroup-verify.c and fix the bug.
> 
> Test case will follow soon after I make a minimal image for it.
> Current xz ziped image is still over 10M for a 512M fs.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
