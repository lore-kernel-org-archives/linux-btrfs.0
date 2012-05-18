Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:54152 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759720Ab2ERMwX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 08:52:23 -0400
Date: Fri, 18 May 2012 14:52:07 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, sbehrens@giantdisaster.de
Subject: Re: [PATCH 4/5] Btrfs: cancel the scrub when remounting a fs to ro
Message-ID: <20120518125207.GI24394@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <4FB4E7DD.8020802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB4E7DD.8020802@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2012 at 07:58:21PM +0800, Miao Xie wrote:
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1151,6 +1151,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>  		/* pause restriper - we want to resume on remount to r/w */
>  		btrfs_pause_balance(root->fs_info);
>  
> +		btrfs_scrub_cancel(root);

Can we possibly switch scrub to readonly instead ? I'm not sure what's
the 'least surprise here', whether to cancel everything on the
filesystem upon ro-remount or just the minimal set of operations (and
leave the rest running if possible).

Looking at the scrub code, if dev->readonly is set, no repairs are done,
so the only concern is to wait for any outstanding IOs and then switch
to RO.


david
