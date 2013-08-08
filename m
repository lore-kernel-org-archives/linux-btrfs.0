Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:22962 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965026Ab3HHKw2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 06:52:28 -0400
Message-ID: <5203786A.3000306@giantdisaster.de>
Date: Thu, 08 Aug 2013 12:52:26 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/5] Btrfs-progs: return error on write failure in make_btrfs()
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com> <1372931320-8340-1-git-send-email-fdmanana@gmail.com> <1372931320-8340-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372931320-8340-2-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu,  4 Jul 2013 10:48:39 +0100, Filipe David Borba Manana wrote:
> Instead of aborting with a BUG_ON() statement, return a
> negated errno code. Also updated mkfs and convert tools
> to print a nicer error message when make_btrfs() returns
> an error.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
[...]
>  	ret = pwrite(fd, buf->data, sectorsize, blocks[0]);
> -	BUG_ON(ret != sectorsize);
> -
> +	if (ret < 0)
> +		return -errno;
> +	else if (ret != leafsize)
> +		return -EIO;

mkfs.btrfs with leafsize != sectorsize fails. I've sent a patch for it.

