Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab3CFS5X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Mar 2013 13:57:23 -0500
Date: Wed, 6 Mar 2013 10:56:37 -0800
From: Zach Brown <zab@redhat.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH] btrfs: enhance superblock checks
Message-ID: <20130306185637.GE27710@lenny.home.zabbo.net>
References: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 06, 2013 at 04:56:40PM +0100, David Sterba wrote:
> The superblock checksum is not verified upon mount. <awkward silence>

Hah!

>  /*
> + * Return 0 if the superblock checksum type matches the checksum value of that
> + * alghorithm. Pass the raw disk superblock data.
> + */
> +static int btrfs_check_super_csum(char *raw_disk_sb)

I'd have it return 0 or -errno and print warnings with additional info
so that each caller doesn't have to.

> +{
> +	struct btrfs_super_block *disk_sb =
> +		(struct btrfs_super_block *)raw_disk_sb;
> +	u16 csum_type = btrfs_super_csum_type(disk_sb);

> +	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
> +		printk(KERN_ERR "btrfs: unsupported checksum algorithm %u\n",
> +				csum_type);
> +		return 1;
> +	}

Does this mean we can get rid of that BUG_ON in btrfs_super_csum_size()?

And you can move this check down in an else after the CRC32 test to get
rid of the extra exit path.  Have each case ret = , the end of the
function returns ret.

> +	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
> [...]
> +	}
> +
> +	return 1;

	int ret = 0

	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
		[..]
		if (memcmp())
			ret = -EIO; /* or whatever */
	} else if (type > array_size() {
		printk("I'm sad.");
		ret = -EBOOHOO;
	}

	return ret;

- z
