Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41D0C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 17:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5DD420659
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 17:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5DD420659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406100AbeKTD1N (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 22:27:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:41326 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405038AbeKTD1M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 22:27:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17AF0AE61;
        Mon, 19 Nov 2018 17:02:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 14CD2DAF89; Mon, 19 Nov 2018 18:02:34 +0100 (CET)
Date:   Mon, 19 Nov 2018 18:02:33 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 1/3] btrfs: add helper function describe_block_group()
Message-ID: <20181119170233.GG24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1542201432-8617-1-git-send-email-anand.jain@oracle.com>
 <1542201432-8617-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542201432-8617-2-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 09:17:10PM +0800, Anand Jain wrote:
> Improve on describe_relocation() add a common helper function to describe
> the block groups.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> ---
> v4.1->v5: Initialize buf[128] to null.
> v4->v4.1: Use strcpy(buf, "|NONE"); as in the original
> v3->v4: Just pass full flag name in the define DESCRIBE_FLAG(flag,..),
> 	 so that it can be used at couple of more places.
> 	Rename describe_block_groups() to btrfs_describe_block_groups().
> 	Drop useless return u32.
> v3:	Born.
> 
>  fs/btrfs/relocation.c | 30 +++---------------------------
>  fs/btrfs/volumes.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.h    |  1 +
>  3 files changed, 47 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 924116f654a1..0373b3cc1d36 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4184,37 +4184,13 @@ static struct reloc_control *alloc_reloc_control(void)
>  static void describe_relocation(struct btrfs_fs_info *fs_info,
>  				struct btrfs_block_group_cache *block_group)
>  {
> -	char buf[128];		/* prefixed by a '|' that'll be dropped */
> -	u64 flags = block_group->flags;
> +	char buf[128] = {'\0'};
>  
> -	/* Shouldn't happen */
> -	if (!flags) {
> -		strcpy(buf, "|NONE");
> -	} else {
> -		char *bp = buf;
> -
> -#define DESCRIBE_FLAG(f, d) \
> -		if (flags & BTRFS_BLOCK_GROUP_##f) { \
> -			bp += snprintf(bp, buf - bp + sizeof(buf), "|%s", d); \
> -			flags &= ~BTRFS_BLOCK_GROUP_##f; \
> -		}
> -		DESCRIBE_FLAG(DATA,     "data");
> -		DESCRIBE_FLAG(SYSTEM,   "system");
> -		DESCRIBE_FLAG(METADATA, "metadata");
> -		DESCRIBE_FLAG(RAID0,    "raid0");
> -		DESCRIBE_FLAG(RAID1,    "raid1");
> -		DESCRIBE_FLAG(DUP,      "dup");
> -		DESCRIBE_FLAG(RAID10,   "raid10");
> -		DESCRIBE_FLAG(RAID5,    "raid5");
> -		DESCRIBE_FLAG(RAID6,    "raid6");
> -		if (flags)
> -			snprintf(bp, buf - bp + sizeof(buf), "|0x%llx", flags);
> -#undef DESCRIBE_FLAG
> -	}
> +	btrfs_describe_block_groups(block_group->flags, buf, sizeof(buf));
>  
>  	btrfs_info(fs_info,
>  		   "relocating block group %llu flags %s",
> -		   block_group->key.objectid, buf + 1);
> +		   block_group->key.objectid, buf);
>  }
>  
>  /*
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f435d397019e..12b3d0625c6a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -123,6 +123,49 @@ const char *get_raid_name(enum btrfs_raid_types type)
>  	return btrfs_raid_array[type].raid_name;
>  }
>  
> +void btrfs_describe_block_groups(u64 bg_flags, char *buf, u32 size_buf)
> +{
> +	int i;
> +	int ret;
> +	char *bp = buf;
> +	u64 flags = bg_flags;
> +	u32 size_bp = size_buf;
> +
> +	if (!flags) {
> +		strcpy(bp, "NONE");
> +		return;
> +	}
> +
> +#define DESCRIBE_FLAG(f, d) \

Macro arguments should be in ( ) in the body

> +	do { \
> +		if (flags & f) { \
> +			ret = snprintf(bp, size_bp, "%s|", d); \
> +			if (ret < 0 || ret >= size_bp) \
> +				return; \

Ok, this seems to be safe. snprintf will not write more than size_bp and
this will be caught if it overflows.

The return is obscured by the macro, I'd rather make it more visible
that there is a potential change in the code flow. The proposed change:

				goto out_overflow;
				...

and define out_overflow at the end of function. Same for the other
helper macros.

Also please align the backslashes of the macro a few tabs to the right.

> +			size_bp -= ret; \
> +			bp += ret; \
> +			flags &= ~f; \
> +		} \
> +	} while (0)
