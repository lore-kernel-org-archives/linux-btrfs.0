Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbcEWMBp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 May 2016 08:01:45 -0400
Date: Mon, 23 May 2016 14:01:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: utils: use better wrappered random generator
Message-ID: <20160523120112.GK29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463973049-3480-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463973049-3480-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The API does not seem right. It's fine to provide functions for full
int/u32/u64 ranges, but in the cases when we know the range from which
we request the random number, it has to be passed as parameter. Not
doing the % by hand.

> +u32 rand_u32(void)
> +{
> +	struct timeval tv;
> +	unsigned short rand_seed[3];

This could be made static (with thread local storage) so the state does
not get regenerated all the time. Possibly it could be initialize from
some true random source, not time or pid.

> +	long int ret;
> +	int i;
> +
> +	gettimeofday(&tv, 0);
> +	rand_seed[0] = getpid() ^ (tv.tv_sec & 0xFFFF);
> +	rand_seed[1] = getppid() ^ (tv.tv_usec & 0xFFFF);
> +	rand_seed[2] = (tv.tv_sec ^ tv.tv_usec) >> 16;
> +
> +	/* Crank the random number generator a few times */
> +	gettimeofday(&tv, 0);
> +	for (i = (tv.tv_sec ^ tv.tv_sec) ^ 0x1F; i > 0; i--)
> +		nrand48(rand_seed);

This would be then unnecesssray, just draw the number from nrand.

About patch separation: please introduce the new api in one patch, use
in another (ie. drop srand and switch to it).
