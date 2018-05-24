Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40236 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966016AbeEXOnn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 10:43:43 -0400
Date: Thu, 24 May 2018 15:03:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 2/3] btrfs: balance: add args info during start and
 resume
Message-ID: <20180524130318.GG6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180523063508.18695-1-anand.jain@oracle.com>
 <20180523063508.18695-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180523063508.18695-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2018 at 02:35:07PM +0800, Anand Jain wrote:
> Balance arg info is an important information to be reviewed for the
> system audit. So this patch adds them to the kernel log.
> 
> Example:
> 
> ->btrfs bal start --full-balance -f -mprofiles=raid1,convert=single,soft -dlimit=10..20,usage=50 /btrfs

--full-balance should not be here as it's for the case when no filter is
used.

>  kernel: BTRFS info (device sdc): balance: start -f -d usage=50,limit=10..20 -m soft,profiles=raid1,convert=single -s soft,profiles=raid1,convert=single

While this looks good, it would not work as is because of the dual
syntax of -d and -m, the argument is optional and with the space between
it'll fail with "btrfs filesystem balance start: too many arguments" .

At least the main parts of the string are copy&paste ready, so the
format can be like

balance: start force D:usage=50,limit=10..20 M:soft,profiles=raid1,convert=single S:soft,profiles=raid1,convert=single

or with "DATA:" "METADATA:"

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v3->v4: Change log updated with new example.
> 	Log format is changed to almost match with the cli.
> 	snprintf drop %s for inline string.
> 	Print range as =%u..%u instead of min=%umax=%u.
> 	soft is under the args now.
> 	force is printed as -f.
> 
> v2->v3: Change log updated.
>         Make use of describe_block_group() added in 1/4
>         Drop using strcat instead use snprintf.
>         Logs string format updated as shown in the example above.
> 
> v1->v2: Change log update.
>         Move adding the logs for balance complete and end to a new patch
> 
>  fs/btrfs/volumes.c | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 104 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 44f4799bf06f..85f954f7f93e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3806,6 +3806,108 @@ static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
>  		 (bctl_arg->target & ~allowed)));
>  }
>  
> +static u32 describe_balance_args(struct btrfs_balance_args *bargs, char *buf,
> +				 u32 size_buf)
> +{
> +	char *bp = buf;
> +	u64 flags = bargs->flags;
> +	char tmp_buf[128];
> +
> +	if (!flags)
> +		return 0;
> +
> +	if (flags & BTRFS_BALANCE_ARGS_SOFT)
> +		bp += snprintf(bp, buf - bp + size_buf, "soft,");
> +
> +	if (flags & BTRFS_BALANCE_ARGS_PROFILES) {
> +		btrfs_describe_block_groups(bargs->profiles, tmp_buf,
> +					    sizeof(tmp_buf));
> +		bp += snprintf(bp, buf - bp + size_buf, "profiles=%s,",
> +			       tmp_buf);
> +	}
> +
> +	if (flags & BTRFS_BALANCE_ARGS_USAGE)
> +		bp += snprintf(bp, buf - bp + size_buf, "usage=%llu,",
> +			       bargs->usage);
> +
> +	if (flags & BTRFS_BALANCE_ARGS_USAGE_RANGE)
> +		bp += snprintf(bp, buf - bp + size_buf, "usage=%u..%u,",
> +			       bargs->usage_min, bargs->usage_max);
> +
> +	if (flags & BTRFS_BALANCE_ARGS_DEVID)
> +		bp += snprintf(bp, buf - bp + size_buf, "devid=%llu,",
> +			       bargs->devid);
> +
> +	if (flags & BTRFS_BALANCE_ARGS_DRANGE)
> +		bp += snprintf(bp, buf - bp + size_buf, "drange=%llu..%llu,",
> +			       bargs->pstart, bargs->pend);
> +
> +	if (flags & BTRFS_BALANCE_ARGS_VRANGE)
> +		bp += snprintf(bp, buf - bp + size_buf, "vrange%llu..%llu,",
> +			       bargs->vstart, bargs->vend);
> +
> +	if (flags & BTRFS_BALANCE_ARGS_LIMIT)
> +		bp += snprintf(bp, buf - bp + size_buf, "limit=%llu,",
> +			       bargs->limit);
> +
> +	if (flags & BTRFS_BALANCE_ARGS_LIMIT_RANGE)
> +		bp += snprintf(bp, buf - bp + size_buf, "limit=%u..%u,",
> +			       bargs->limit_min, bargs->limit_max);
> +
> +	if (flags & BTRFS_BALANCE_ARGS_STRIPES_RANGE)
> +		bp += snprintf(bp, buf - bp + size_buf, "stripes=%u..%u,",
> +			       bargs->stripes_min, bargs->stripes_max);
> +
> +	if (flags & BTRFS_BALANCE_ARGS_CONVERT) {
> +		int index = btrfs_bg_flags_to_raid_index(bargs->target);
> +
> +		bp += snprintf(bp, buf - bp + size_buf, "convert=%s,",
> +			       get_raid_name(index));
> +	}
> +
> +	buf[bp - buf - 1] = '\0'; /* remove last , */
> +	return bp - buf - 1;
> +}
> +
> +static void describe_balance_start_or_resume(struct btrfs_fs_info *fs_info)
> +{
> +	u32 sz = 1024;
> +	char tmp_buf[64];

This is too short, the profiles= can contain all profile names that
itself has 50 bytes, plus any filter, this will not fit the buffer.

Other than that, it looks good and I'll add it to for-next. We may still
want tweak the exact output format and buffer sizes, there's a bit of time.
