Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380Ab3AHQnZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 11:43:25 -0500
Date: Tue, 8 Jan 2013 17:43:14 +0100
From: Karel Zak <kzak@redhat.com>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: util-linux@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: Btrfs: wipe all the superblock [redhat bugzilla 889888]
Message-ID: <20130108164314.GA9177@x2.net.home>
References: <50E9C267.3050302@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50E9C267.3050302@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 06, 2013 at 07:28:55PM +0100, Goffredo Baroncelli wrote:
> +const struct blkid_idinfo btrfs_idinfo1 =
> +{
> +	.name		= "btrfs [bak #1]",
> +	.usage		= BLKID_USAGE_FILESYSTEM,
> +	.probefunc	= probe_btrfs,
> +	.minsz		= 64 * 1024 * 1024 + 4 * 1024,
> +	.magics		=
> +	{
> +		{ .magic = "_BHRfS_M", 
> +		  .len = 8, 
> +		  .kboff = 64 * 1024, 
> +		  .sboff = 0x40 },
> +		{ NULL }
> +	}
> +};
> +
> +const struct blkid_idinfo btrfs_idinfo2 =
> +{
> +	.name		= "btrfs [bak #2]",
> +	.usage		= BLKID_USAGE_FILESYSTEM,
> +	.probefunc	= probe_btrfs,
> +	.minsz		= 256 * 1024 * 1024 * 1024 + 4 *1024,
> +	.magics		=
> +	{
> +		{ .magic = "_BHRfS_M", 
> +		  .len = 8, 
> +		  .kboff = 256 * 1024 * 1024, 
> +		  .sboff = 0x40 },
> +		{ NULL }
> +	}
> +};

 You can specify more than one magic strings for the same filesystem,
 the .magics = { } is array.

 .magics     = {

    /* backup #1 */
	{ .magic = "_BHRfS_M", 
	  .len = 8, 
	  .kboff = 64 * 1024, 
	  .sboff = 0x40 },
    },

    /* backup #2 */
    {   .magic = "_BHRfS_M",
        .len = 8,
        .kboff = 256 * 1024 * 1024,
        .sboff = 0x40
    }, 
    ...
 }

 see for example libblkid/src/superblocks/reiserfs.c 

 Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
