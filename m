Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbbJUL3D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 07:29:03 -0400
Date: Wed, 21 Oct 2015 13:27:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add a check of whether fs_info->fs_root is NULL
 in btrfs_async_reclaim_metadata_space()
Message-ID: <20151021112742.GD13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201510210720.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201510210720.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 21, 2015 at 04:20:00PM +0900, Tsutomu Itoh wrote:
> Kernel panic occurred due to NULL pointer reference in can_overcommit().
> Because btrfs_async_reclaim_metadata_space() passed NULL pointer to
> btrfs_calc_reclaim_metadata_size().

> fs_info->fs_root is referred in btrfs_async_reclaim_metadata_space()
> when mount kicked kworker(btrfs_async_reclaim_metadata_space).
> 
> But at this time, fs_info->fs_root had not been initialized yet,
> so NULL pointer passed to btrfs_calc_reclaim_metadata_size().

I don't think it's the right fix, the initialization sequence should
take care of such situations. The fs_tree must exist at the time we
reach the point where it crashed, the code expects it.
