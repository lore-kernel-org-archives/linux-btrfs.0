Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbcESM13 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 08:27:29 -0400
Date: Thu, 19 May 2016 14:26:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Return earlier for previous item
Message-ID: <20160519122659.GE29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463626479-7628-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463626479-7628-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 19, 2016 at 10:54:39AM +0800, Qu Wenruo wrote:
> Follow kernel code to return earlier for btrfs_previous_item() function.
> 
> Before this patch, btrfs_previous_item() doesn't use its min_objectid to
> exit, this makes caller to check key to exit, and if caller doesn't
> check, it will iterate all previous item.
> 
> This patch will check min_objectid and type, to early return and save
> some time.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
