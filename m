Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43283 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751464AbeCUMx7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 08:53:59 -0400
Subject: Re: [PATCH] btrfs-progs: wipe all copies of the stale superblock
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180321101920.9004-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e16124c3-7f57-6a2f-f760-5164f7c10ad1@suse.com>
Date: Wed, 21 Mar 2018 14:53:55 +0200
MIME-Version: 1.0
In-Reply-To: <20180321101920.9004-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.03.2018 12:19, Anand Jain wrote:
> Recovering from the other copies of the superblock is fundamental
> to BTRFS, which provides resilient against single LBA failure in
nit: s/resilient/resilience.
> the DUP group profile.

Furthermore, the number of superblock copies doesn't really depend on
the group profile of either the data or metadata so the second part of
that statement is incorrect. All in all I don't think this paragraph
really brings any value so I suggest removing it altogether.

> 
> Further, in the test case [1] it shows a good but stale superblock
> at copy#2. This will lead to confusion during auto/manual recovery.
> So strictly speaking if a device has three copies of the superblock
> and if we have permission to wipe it (-f option) then we have to wipe
> all the copies of the superblock.

The problem is not really described in human-readable format. The issue
is that if we re-create a smaller btrfs filesystem on a driver which
contained a previous filesystem then it's possible to have old fs and
new fs superblocks to co-exist. Also the title of the patch needs
rewording to put the changes in context i.e. :

"Wipe possible superblock stale copies on mkfs" or some such.

> 
> If there is any objection to writing beyond mkfs.btrfs -b <size>, then
> we could fail the mkfs/dev-add/dev-replace operation and ask the user
> the wipe using dd command manually, as anyway there is no use of keeping
> only the copy#2 when the new FS has been written.

This sentence also doesn't belong in the changelog, you are asking of
our opinion which is fine, but put it under the scissors line in that case.

> 
> Test case: Note that copy#2 fsid is different from primary and copy#1
> fsid.
> 
> mkfs.btrfs -qf /dev/mapper/vg-lv && \
> mkfs.btrfs -qf -b1G /dev/mapper/vg-lv && \
> btrfs in dump-super -a /dev/mapper/vg-lv | grep '.fsid|superblock:'
> 
> superblock: bytenr=65536, device=/dev/mapper/vg-lv
> dev_item.fsid		ebc67d01-7fc5-43f0-90b4-d1925002551e [match]
> superblock: bytenr=67108864, device=/dev/mapper/vg-lv
> dev_item.fsid		ebc67d01-7fc5-43f0-90b4-d1925002551e [match]
> superblock: bytenr=274877906944, device=/dev/mapper/vg-lv
> dev_item.fsid		b97a9206-593b-4933-a424-c6a6ee23fe7c [match]
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  Hope with this we can patch the kernel to auto recover from the
>  failed primary SB. In the earlier discussion on that, I think we
>  are scrutinizing the wrong side (kernel) of the problem.
>  Also, we need to fail the mount if all the copies of the SB do
>  not have the same fsid.
> 
>  utils.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/utils.c b/utils.c
> index 00020e1d6bdf..9c027f77d9c1 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -365,6 +365,41 @@ int btrfs_prepare_device(int fd, const char *file, u64 *block_count_ret,
>  		return 1;
>  	}
>  
> +	/*
> +	 * Check for the BTRFS SB copies up until btrfs_device_size() and zero
> +	 * it. So that kernel (or user for the manual recovery) don't have to
> +	 * confuse with the stale SB copy during recovery.
> +	 */
> +	if (block_count != btrfs_device_size(fd, &st)) {
> +		for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> +			struct btrfs_super_block *disk_super;
> +			char buf[BTRFS_SUPER_INFO_SIZE];
> +			disk_super = (struct btrfs_super_block *)buf;
> +
> +			/* Already zeroed above */
> +			if (btrfs_sb_offset(i) < block_count)
> +				continue;
> +
> +			/* Beyond actual disk size */
> +			if (btrfs_sb_offset(i) >= btrfs_device_size(fd, &st))
> +				continue;
> +
> +			/* Does not contain any stale SB */
> +			if (btrfs_read_dev_super(fd, disk_super,
> +						 btrfs_sb_offset(i), 0))
> +				continue;
> +
> +			ret = zero_dev_clamped(fd, btrfs_sb_offset(i),
> +						BTRFS_SUPER_INFO_SIZE,
> +						btrfs_device_size(fd, &st));
> +			if (ret < 0) {
> +				error("failed to zero device '%s' bytenr %llu: %s",
> +					file, btrfs_sb_offset(i), strerror(-ret));
> +				return 1;
> +			}
> +		}
> +	}

A better place for this code is really inside btrfs_wipe_existing_sb.
Furthermore looking at libblkid it supports a way to wipe multiple
superblocks by way of: blkid_do_wipe. I.e
https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.21/libblkid-docs/libblkid-Low-level-tags.html#blkid-do-wipe

Apparently this functionality has been in libblkid for quite some time
according to this blog post -
http://karelzak.blogspot.bg/2011/11/wipefs8-improvements.html (Karel Zak
is the person mainting various system libraries).

So can't we at the very least:

1) Remove some of our (open coded) implementation of
btrfs_wipe_existing_sb and use the generic blkid implementation.

2) Incorporate your code into btrfs_wipe_existing_sb OR extend the usage
of the generic blkid_do_wipe to wipe multiple copies of the sb ?

> +
>  	*block_count_ret = block_count;
>  	return 0;
>  }
> 
