Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbbLGOSu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 09:18:50 -0500
Date: Mon, 7 Dec 2015 15:16:51 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PULL][PATCH 00/12] Minor cleanups and code simplifications
Message-ID: <20151207141651.GB4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1449161602.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1449161602.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 03, 2015 at 05:56:19PM +0100, David Sterba wrote:
> ----------------------------------------------------------------
> The following changes since commit 1ec218373b8ebda821aec00bb156a9c94fad9cd4:
> 
> David Sterba (12):
>       btrfs: make btrfs_close_one_device static
>       btrfs: sink parameter wait to btrfs_alloc_delalloc_work
>       btrfs: remove wait from struct btrfs_delalloc_work
>       btrfs: change how delay_iput is tracked in btrfs_delalloc_work

FYI, this patch was dropped, branch force-pushed and the top commit is
35de6db28f260e88e9acc47305f7b3f272d76cbf
