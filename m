Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbbJZO65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 10:58:57 -0400
Date: Mon, 26 Oct 2015 15:57:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] btrfs-progs: Add all missing close_ctree and
 btrfs_close_all_devices
Message-ID: <20151026145732.GP13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 26, 2015 at 06:28:17PM +0800, Zhao Lei wrote:
> This patch add all missing close_ctree and btrfs_close_all_devices
> to several tools in btrfs progs, to avoid memory leak.
> 
> Changelog v1->v2:
>  Move btrfs_close_all_devices() from cmd-XXX into btrfs.c to make
>  code simple, and avoid similar problem in cmd-XXX in future.
> 
> Zhao Lei (5):
>   btrfs-progs: btrfs: Add missing btrfs_close_all_devices for btrfs
>     command
>   btrfs-progs: Remove all btrfs_close_all_devices in sub-command
>   btrfs-progs: Add all missing btrfs_close_all_devices to standalone
>     tools
>   btrfs-progs: Add missing close_ctree to btrfs-select-super.c
>   btrfs-progs: use system's default path for math.h

Applied, thanks.
