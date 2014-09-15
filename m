Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbaIOLgO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 07:36:14 -0400
Date: Mon, 15 Sep 2014 13:36:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] btrfs-progs: Check superblock's checsum when read
 dev super
Message-ID: <20140915113612.GC9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1404380198-25948-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404380198-25948-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

sorry for late reply.

On Thu, Jul 03, 2014 at 05:36:35PM +0800, Qu Wenruo wrote:
> Also fix a bug that btrfs_read_dev_super() only reads sizeof(struct
> btrfs_super_block), corrent size should be BTRFS_SUPER_INFO_SIZE.

Actually it's correct to read only sizeof(super_block), the kernel does
it the same way. The expected in-memory format is to store the
super_block bytes and pad by zeros up to INFO_SIZE.

The checksum is calculated from that. The on-disk 4k block may contain
garbage after the super_block bytes, but it never affects the cheksum
due to the zeroing and padding.

We've got a report of mismatched checksum and bisected to this patch.

> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1186,22 +1186,25 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
>  {
>  	u8 fsid[BTRFS_FSID_SIZE];
>  	int fsid_is_initialized = 0;
> -	struct btrfs_super_block buf;
> +	u8 data[BTRFS_SUPER_INFO_SIZE];
> +	struct btrfs_super_block *buf = (struct btrfs_super_block *) data;
>  	int i;
>  	int ret;
>  	u64 transid = 0;
>  	u64 bytenr;
> +	u32 crc;
> +	char crc_result[BTRFS_CSUM_SIZE];
>  
>  	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
> -		ret = pread64(fd, &buf, sizeof(buf), sb_bytenr);
> -		if (ret < sizeof(buf))
> +		ret = pread64(fd, data, sizeof(data), sb_bytenr);
> +		if (ret < sizeof(data))
>  			return -1;
>  
> -		if (btrfs_super_bytenr(&buf) != sb_bytenr ||
> -		    btrfs_super_magic(&buf) != BTRFS_MAGIC)
> +		if (btrfs_super_bytenr(buf) != sb_bytenr ||
> +		    btrfs_super_magic(buf) != BTRFS_MAGIC)
>  			return -1;
>  
> -		memcpy(sb, &buf, sizeof(*sb));
> +		memcpy(sb, data, sizeof(data));

Using a temporary buffer (data) of SIZE_INFO would be ok, untill you try
to memcpy it to the 'sb' which is sizeof(struct btrfs_super_block). So
the memcpy is overwring the memory after 'sb', the correct length of
memcpy is sizeof(*sb).

But then I don't see the point of the patch, the code would just use a
bigger temprary buffer for no apparent reason, the outcom is the same.
