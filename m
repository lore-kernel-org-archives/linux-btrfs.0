Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858AbbKMQmW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 11:42:22 -0500
Date: Fri, 13 Nov 2015 17:40:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Check periodic.timer_fd's value before use
Message-ID: <20151113164045.GN6445@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <bbf60367447e680378412a801a881496aa25fe60.1447060006.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bbf60367447e680378412a801a881496aa25fe60.1447060006.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 09, 2015 at 05:06:53PM +0800, Zhao Lei wrote:
> periodic.timer_fd's value is 0 on inititlize-failed case,
> if no value-checking before read(), the code will run as
> read(STDIN).
> 
> This patch fixed above case.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
