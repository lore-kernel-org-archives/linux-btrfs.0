Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbbK3KBx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 05:01:53 -0500
Date: Mon, 30 Nov 2015 11:00:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs-tests: Check sectorsize and nodesize
 combination
Message-ID: <20151130100004.GX31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1448847570-9549-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448847570-9549-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2015 at 09:39:30AM +0800, Qu Wenruo wrote:
> Add mkfs selftest for invalid and valid sectorsize/nodesize
> combination.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied with some changes, thanks.

> +image_size=1g
> +image=image

If you need a single image, just use prepare_test_dev and $TEST_DEV
