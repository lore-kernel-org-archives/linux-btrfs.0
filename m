Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444AbbKMQ7H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 11:59:07 -0500
Date: Fri, 13 Nov 2015 17:57:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: find-root: Add support to search chunk root
Message-ID: <20151113165729.GR6445@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1447383221-20729-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447383221-20729-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 13, 2015 at 10:53:41AM +0800, Qu Wenruo wrote:
> Add support to search chunk root, as we only need to search tree roots
> in system chunk, which should be very easy to add, just iterate in
> system chunks.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks. I've changed the prefixes to 'btrfs_next_bg_',
btrfs_next_system was a bit confusing to me. Similarly, btrfs_next_chunk
is now btrfs_next_bg.
