Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbbKXRrp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 12:47:45 -0500
Date: Tue, 24 Nov 2015 18:46:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, calestyo@scientia.net
Subject: Re: [PATCH] btrfs-progs: fsck: Fix a false alert where extent record
 has wrong metadata flag
Message-ID: <20151124174600.GM31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1448342211-21558-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448342211-21558-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 24, 2015 at 01:16:51PM +0800, Qu Wenruo wrote:
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

Applied, thanks you both for tracking it down. I'll add a test image.
