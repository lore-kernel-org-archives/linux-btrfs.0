Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbaAUQDe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 11:03:34 -0500
Date: Tue, 21 Jan 2014 17:03:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3 1/4] Btrfs: fix wrong send_in_progress accounting
Message-ID: <20140121160333.GB6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390021080-30788-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390021080-30788-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 18, 2014 at 12:58:00PM +0800, Wang Shilong wrote:
> Steps to reproduce:
>  # mkfs.btrfs -f /dev/sda8
>  # mount /dev/sda8 /mnt
>  # btrfs sub snapshot -r /mnt /mnt/snap1
>  # btrfs sub snapshot -r /mnt /mnt/snap2
>  # btrfs send /mnt/snap1 -p /mnt/snap2 -f /mnt/1
>  # dmesg
> 
> The problem is that we will sort clone roots(include @send_root), it
> might push @send_root before thus @send_root's @send_in_progress will
> be decreased twice.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
