Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:53518 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761441Ab2ERL5W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 07:57:22 -0400
Date: Fri, 18 May 2012 13:57:19 +0200
From: David Sterba <dave@jikos.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 3/3] Btrfs: read device stats on mount, write modified
 ones during commit
Message-ID: <20120518115719.GH24394@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <cover.1337185201.git.sbehrens@giantdisaster.de>
 <f7e60650b3463d028f86b38ef3e6aaf77efa665b.1337185201.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f7e60650b3463d028f86b38ef3e6aaf77efa665b.1337185201.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 16, 2012 at 06:50:47PM +0200, Stefan Behrens wrote:
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -823,6 +823,26 @@ struct btrfs_csum_item {
>  	u8 csum;
>  } __attribute__ ((__packed__));
>  
> +struct btrfs_device_stats_item {
> +	/*
> +	 * grow this item struct at the end for future enhancements and keep
> +	 * the existing values unchanged
> +	 */
> +	__le64 cnt_write_io_errs; /* EIO or EREMOTEIO from lower layers */
> +	__le64 cnt_read_io_errs; /* EIO or EREMOTEIO from lower layers */
> +	__le64 cnt_flush_io_errs; /* EIO or EREMOTEIO from lower layers */
> +
> +	/* stats for indirect indications for I/O failures */
> +	__le64 cnt_corruption_errs; /* checksum error, bytenr error or
> +				     * contents is illegal: this is an
> +				     * indication that the block was damaged
> +				     * during read or write, or written to
> +				     * wrong location or read from wrong
> +				     * location */
> +	__le64 cnt_generation_errs; /* an indication that blocks have not
> +				     * been written */

A few spare u64 would come handy in the future. Currently there are 5,
so add like 7 or 11. We might be interested in collecting more types of
stats, ore more fine-grained.

I see the comment above about enhancing the structure, but then you need
to version this stucture. Let's say this kernel at version 3.5 add this
structre as you propose it now, and kernel 3.6 adds another item
'cnt_exploded'.

Accessing the 3.6-created image with a 3.5 will be ok (older kernel will
not touch the new items).

Accessing the 3.5-created image with a 3.6 will be problematic, as the
kernel would try to access ->cnt_exploded .

So, either the 3.6 kernel needs to know not to touch the missing item
(ie. via reading the struct version from somewhere, stored on disk).

Or, there are spare items, which are zeroed in versions that do not use
them and naturally used otherwise, but when new kernel uses old image,
it finds zeros (and will be safe).

> +} __attribute__ ((__packed__));
> +
