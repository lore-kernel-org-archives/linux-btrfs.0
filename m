Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:36868 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750724Ab2GUKxM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Jul 2012 06:53:12 -0400
Message-ID: <500A8A29.6020006@gmx.net>
Date: Sat, 21 Jul 2012 12:53:29 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 6/7] Btrfs: introduce BTRFS_IOC_SEND for btrfs send/receive
 (part 1)
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com> <1341409108-13567-7-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1341409108-13567-7-git-send-email-ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/04/2012 03:38 PM, Alexander Block wrote:
> This patch introduces the BTRFS_IOC_SEND ioctl that is
> required for send. It allows btrfs-progs to implement
> full and incremental sends. Patches for btrfs-progs will
> follow.
> 
> I had to split the patch as it got larger then 100k which is
> the limit for the mailing list. The first part only contains
> the send.h header and the helper functions for TLV handling
> and long path name handling and some other helpers. The second
> part contains the actual send logic from send.c
> 
> Signed-off-by: Alexander Block <ablock84@googlemail.com>
> ---
[snip]
> +
> +struct name_cache_entry {
> +	struct list_head list;
> +	struct list_head use_list;

unused.

> +	u64 ino;
> +	u64 gen;
> +	u64 parent_ino;
> +	u64 parent_gen;
> +	int ret;
> +	int need_later_update;
> +	int name_len;
> +	char name[];
> +};
> +
