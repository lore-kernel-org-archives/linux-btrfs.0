Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbcFNIu5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 04:50:57 -0400
Date: Tue, 14 Jun 2016 10:51:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: doc: correct the destination of
 btrfs-receive
Message-ID: <20160614085133.GE6205@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <491d91eb-0d51-b8ba-a046-61e2e392f06e@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <491d91eb-0d51-b8ba-a046-61e2e392f06e@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 14, 2016 at 02:50:19PM +0900, Satoru Takeuchi wrote:
> We can set not only btrfs mount point but also any path belong to
> btrfs mount point as btrfs-receive's destination.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

The patches from you have a consistent whitespace damage, I've fixed
the btrfs-crc but now that I see it again I suspect some error on your
side.

> @@ -7,14 +7,14 @@ btrfs-receive - receive subvolumes from send stream
> 
>   SYNOPSIS
>   --------
> -*btrfs receive* [options] <mount>
> +*btrfs receive* [options] <path>
> 
>   DESCRIPTION
>   -----------
> 
>   Receive a stream of changes and replicate one or more subvolumes that were
>   previously used with *btrfs send* The received subvolumes are stored to
> -'mount'.
> +'path'.
> 
>   *btrfs receive* will fail int the following cases:
> 
> @@ -37,7 +37,7 @@ by default, btrfs receive uses standard input to receive the stream,
>   use this option to read from a file instead
> 
>   -C|--chroot::
> -confine the process to 'mount' using `chroot`(1)
> +confine the process to 'path' using `chroot`(1)
> 
>   -e::
>   terminate after receiving an 'end cmd' marker in the stream.

ie. all the context lines start with two spaces instead of one. I'll
apply this patch manually but please have a look.
