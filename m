Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab3H3Vqm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 17:46:42 -0400
Date: Fri, 30 Aug 2013 23:46:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts V2
Message-ID: <20130830214640.GS23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377799797-9738-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377799797-9738-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 29, 2013 at 02:09:57PM -0400, Josef Bacik wrote:
> +#define ASSERT(expr)	\
> +	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
> +#else
> +#define ASSERT(expr)	((void)0)
> +#endif
> +
> +#define btrfs_assert()

This is unused and without any ifdef-ed alternatives, should go away I
think.

>  __printf(5, 6)
>  void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
>  		     unsigned int line, int errno, const char *fmt, ...);
