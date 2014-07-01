Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbaGAQFA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 12:05:00 -0400
Date: Tue, 1 Jul 2014 18:04:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: clear compress-force when remounting with
 compress option
Message-ID: <20140701160457.GM1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404096685-10591-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404096685-10591-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 30, 2014 at 10:51:25AM +0800, Wang Shilong wrote:
> Steps to reproduce:
>  # mkfs.btrfs -f /dev/sdb
>  # mount /dev/sdb /mnt -o compress-force=lzo
>  # mount /dev/sdb /mnt -o remount,compress=zlib
>  # cat /proc/mounts
> 
> Remounting from compress-force to compress could not clear compress-force
> option. The problem is there is no way for users to clear compress-force
> option separately.
> 
> Fix this problem by clearing @FORCE_COMPRESS flag when remounting to
> compress=xxx.
> 
> Suggested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

I'm sorry for lack of answer in the V1 thread, V2 is the minimal bugfix
and I'm fine with it right away.

Reviewed-by: David Sterba <dsterba@suse.cz>
