Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429AbbA3QvM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 11:51:12 -0500
Date: Fri, 30 Jan 2015 17:51:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Forrest Liu <forrestl@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add missing blk_finish_plug in btrfs_sync_log()
Message-ID: <20150130165110.GN3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422618132-30272-1-git-send-email-forrestl@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422618132-30272-1-git-send-email-forrestl@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 07:42:12PM +0800, Forrest Liu wrote:
> Add missing blk_finish_plug in btrfs_sync_log()
> 
> Signed-off-by: Forrest Liu <forrestl@synology.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

Did you find that by code inspection or was there a runtime problem.
Thanks.
