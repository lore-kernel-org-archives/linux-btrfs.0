Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:39627 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab2I0IyY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 04:54:24 -0400
Date: Thu, 27 Sep 2012 10:54:16 +0200
From: David Sterba <dave@jikos.cz>
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Robin Dong <sanbai@taobao.com>
Subject: Re: [PATCH 1/2] btrfs-progs: limit the max value of leafsize and
 nodesize
Message-ID: <20120927085416.GF14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348645928-3432-1-git-send-email-robin.k.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348645928-3432-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 26, 2012 at 03:52:07PM +0800, Robin Dong wrote:
> Using mkfs.btrfs like:
> 	mkfs.btrfs -l 131072 /dev/sda
> 
> will return no error, but after mount it, the dmesg will report:
> 	BTRFS: couldn't mount because metadata blocksize (131072) was too large
> 
> The user tools should use BTRFS_MAX_METADATA_BLOCKSIZE to limit leaf and node size.

Good catch.

> @@ -1291,11 +1291,13 @@ int main(int ac, char **av)
>  		}
>  	}
>  	sectorsize = max(sectorsize, (u32)getpagesize());
> -	if (leafsize < sectorsize || (leafsize & (sectorsize - 1))) {
> +	if (leafsize < sectorsize || leafsize > BTRFS_MAX_METADATA_BLOCKSIZE ||
> +			(leafsize & (sectorsize - 1))) {

Could you please separate the BTRFS_MAX_METADATA_BLOCKSIZE check and add
appropriate error message that actually informs the user what kind of
error happened?

>  		fprintf(stderr, "Illegal leafsize %u\n", leafsize);
>  		exit(1);
>  	}
> -	if (nodesize < sectorsize || (nodesize & (sectorsize - 1))) {
> +	if (nodesize < sectorsize || nodesize > BTRFS_MAX_METADATA_BLOCKSIZE ||
> +			(nodesize & (sectorsize - 1))) {

(same here)

>  		fprintf(stderr, "Illegal nodesize %u\n", nodesize);
>  		exit(1);
>  	}

Thanks!
david

