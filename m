Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbbKZO3U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 09:29:20 -0500
Date: Thu, 26 Nov 2015 15:27:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, calestyo@scientia.net
Subject: Re: [PATCH v2] btrfs-progs: fsck: Fix a false alert where extent
 record has wrong metadata flag
Message-ID: <20151126142733.GR31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1448432346-2842-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448432346-2842-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 25, 2015 at 02:19:06PM +0800, Qu Wenruo wrote:
> In process_extent_item(), it gives 'metadata' initial value 0, but for
> non-skinny-metadata case, metadata extent can't be judged just from key
> type and it forgot that case.
> 
> This causes a lot of false alert in non-skinny-metadata filesystem.
> 
> Fix it by set correct metadata value before calling add_extent_rec().
> 
> Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Patch replaced, thanks. The test image is pushed as well.
