Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbcADKFd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jan 2016 05:05:33 -0500
Date: Mon, 4 Jan 2016 11:03:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: Enhance chunk validation check
Message-ID: <20160104100314.GN4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1450145041-13267-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450145041-13267-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 15, 2015 at 10:04:01AM +0800, Qu Wenruo wrote:
> Enhance chunk validation:
> 1) Num_stripes
>    We already have such check but it's only in super block sys chunk
>    array.
>    Now check all on-disk chunks.
> 
> 2) Chunk logical
>    It should be aligned to sector size.
>    This behavior should be *DOUBLE CHECKED* for 64K sector size like
>    PPC64 or AArch64.
>    Maybe we can found some hidden bugs.
> 
> 3) Chunk length
>    Same as chunk logical, should be aligned to sector size.
> 
> 4) Stripe length
>    It should be power of 2.
> 
> 5) Chunk type
>    Any bit out of TYPE_MAS | PROFILE_MASK is invalid.
> 
> With all these much restrict rules, several fuzzed image reported in
> mail list should no longer cause btrfsck error.
> 
> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
