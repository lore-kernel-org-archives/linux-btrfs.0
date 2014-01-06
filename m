Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbaAFQaQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 11:30:16 -0500
Date: Mon, 6 Jan 2014 17:30:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/4] Btrfs: fix wrong send_in_progress accounting
Message-ID: <20140106163015.GX6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389000306-15320-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389000306-15320-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 06, 2014 at 05:25:06PM +0800, Wang Shilong wrote:
> Steps to reproduce:
> 
>  # mkfs.btrfs -f /dev/sda8
>  # mount /dev/sda8 /mnt
>  # btrfs sub snapshot -r /mnt /mnt/snap1
>  # btrfs sub snapshot -r /mnt /mnt/snap2
>  # btrfs send /mnt/snap2 -p /mnt/snap1
> 
> As @send_root will also add into clone_sources, and we should
> take care not to decrease its count twice.

Yes, send_root is appended to the clone_roots but the
clone_sources_to_rollback does not track this, it's not updated after
it's added in

  sctx->clone_roots[sctx->clone_roots_cnt++].root = sctx->send_root;

so send->root->send_in_progress is not modified in the loop that
decrements all clone_root's counters again.

I don't see the warning that should catch negative values of the counter
in btrfs_root_dec_send_in_progress. Am I missing something?


david
