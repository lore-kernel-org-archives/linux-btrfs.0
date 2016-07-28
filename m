Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:52443 "EHLO
	zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241AbcG1L2d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 07:28:33 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
	by zaphod.cobb.me.uk (Postfix) with ESMTP id 2E5EA9BA07
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 12:28:28 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
	by black.home.cobb.me.uk (Postfix) with ESMTPS id 1A18B5FBA1
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 12:28:28 +0100 (BST)
Subject: Re: [PATCH] btrfs-progs: fi defrag: change default extent target size
 to 32 MiB
To: linux-btrfs@vger.kernel.org
References: <1469704629-25512-1-git-send-email-dsterba@suse.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <5799EC5B.2050108@cobb.uk.net>
Date: Thu, 28 Jul 2016 12:28:27 +0100
MIME-Version: 1.0
In-Reply-To: <1469704629-25512-1-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28/07/16 12:17, David Sterba wrote:
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index ef1f550b51c0..6b381c582ea7 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -968,7 +968,7 @@ static const char * const cmd_filesystem_defrag_usage[] = {
>  	"-f             flush data to disk immediately after defragmenting",
>  	"-s start       defragment only from byte onward",
>  	"-l len         defragment only up to len bytes",
> -	"-t size        target extent size hint",
> +	"-t size        target extent size hint (default: 32 MiB)",

As a user... might it be better to say the default is 32M as that is the
format the option requires?

