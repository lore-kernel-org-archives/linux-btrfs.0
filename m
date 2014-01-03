Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaACR63 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 12:58:29 -0500
Date: Fri, 3 Jan 2014 18:58:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] btrfs: Add missing pairing mount options.
Message-ID: <20140103175828.GS6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 03, 2014 at 02:10:23PM +0800, Qu Wenruo wrote:
> Some options should be paired to support triggering different functions
> when remounting.
> This patchset add these missing pairing mount options.

Thanks!

>   btrfs: Add nocheck_int mount option.
>   btrfs: Add noinode_cache mount option.

Commented separately, imho not to be merged in current state.

>   btrfs: Add "barrier" option to support "-o remount,barrier"
>   btrfs: Add noautodefrag mount option.
>   btrfs: Add nodiscard mount option.
>   btrfs: Add noenospc_debug mount option.
>   btrfs: Add noflushoncommit mount option.
>   btrfs: Add acl mount option.
>   btrfs: Add datacow mount option.
>   btrfs: Add datasum mount option.
>   btrfs: Add treelog mount option.

All ok.

Reviewed-by: David Sterba <dsterba@suse.cz>
