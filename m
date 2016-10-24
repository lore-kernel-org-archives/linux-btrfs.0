Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49076 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750747AbcJXRXu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 13:23:50 -0400
Date: Mon, 24 Oct 2016 19:23:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Fix wrong tree block alignment for
 unalianged block group
Message-ID: <20161024172348.GG22935@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161024072233.31643-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161024072233.31643-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2016 at 03:22:33PM +0800, Qu Wenruo wrote:
> Commit 854437ca(btrfs-progs: extent-tree: avoid allocating tree block
> that crosses stripe boundary) introduces check for logical bytenr not
> crossing stripe boundary.
> 
> However that check is not completely correct.
> It only checks if the logical bytenr and length agaist absolute logical
> offset.
> That's to say, it only check if a tree block lies in 64K logical stripe.
> 
> But in fact, it's possible a block group starts at bytenr unaligned with
> 64K, just like the following case.
> 
> Then btrfsck will give false alert.
> 
> 0       32K       64K       96K        128K         160K ...
>         |--------------- Block group A ---------------------
> 	|<-----TB 32K------>|
>         |/Scrub stripe unit/|
> |    WRONG UNIT   |
> 
> In that case, TB(tree block) at bytenr 32K in fact fits into the kernel
> scrub stripe unit.
> But doesn't fit into the pure logical 64K stripe.
> 
> Fix check_crossing_stripes() to compare bytenr to block group start, not
> to absolute logical bytenr.
> 
> Reported-by: Jussi Kansanen <jussi.kansanen@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
