Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbbGXMfh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 08:35:37 -0400
Date: Fri, 24 Jul 2015 14:35:28 +0200
From: David Sterba <dsterba@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH 0/4] Metadata crossing stripe boundary fixes
Message-ID: <20150724123528.GY6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 23, 2015 at 05:18:06PM +0800, Qu Wenruo wrote:
> Qu Wenruo (4):
>   btrfs: print-tree: print stripe len of a chunk
>   btrfs: fsck: Check if a metadata tree block crossing stripe boundary
>   btrfs: extent-tree: Avoid allocating tree block that cross stripe    
>     boundary

Applied the above, thanks.

>   btrfs: convert: Avoid allocating metadata extent crossing stripe    
>     boundary

The BUG_ON there does not look right, patch not applied.
