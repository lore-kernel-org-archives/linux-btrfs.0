Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37972 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934056AbeBMQM7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 11:12:59 -0500
Date: Tue, 13 Feb 2018 17:10:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: manage subvolid mount option as %u
Message-ID: <20180213161042.GV3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180213095048.9550-1-anand.jain@oracle.com>
 <20180213095048.9550-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180213095048.9550-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 13, 2018 at 05:50:43PM +0800, Anand Jain wrote:
> As -o subvolid mount option is an u64 manage it as %u for
> token verifications, instead of %s.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/super.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 8112619cac95..bf629c8a6a47 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -336,7 +336,7 @@ enum {
>  static const match_table_t tokens = {
>  	{Opt_degraded, "degraded"},
>  	{Opt_subvol, "subvol=%s"},
> -	{Opt_subvolid, "subvolid=%s"},
> +	{Opt_subvolid, "subvolid=%u"},

This gets implemented as simple_strtoul, deep in the perser it uses an
unsigned long long and then casts to usigned long. Long and long-long
are same only on subset of architectures, so we'd need to either extend
teh parser capabilities to really do u64 or we'd have to use the %s and
match_u64.

Though a subvolid larger than full 32bit number is unlikely, for sake of
correctness I think we should stick to the constraints of the subvolid
that allows u64.

>  	{Opt_device, "device=%s"},
>  	{Opt_nodatasum, "nodatasum"},
>  	{Opt_datasum, "datasum"},
> @@ -964,8 +964,8 @@ static int btrfs_parse_subvol_options(const char *options, fmode_t flags,
>  {
>  	substring_t args[MAX_OPT_ARGS];
>  	char *opts, *orig, *p;
> -	char *num = NULL;
>  	int error = 0;
> +	u64 subvolid;
>  
>  	if (!options)
>  		return 0;
> @@ -995,18 +995,15 @@ static int btrfs_parse_subvol_options(const char *options, fmode_t flags,
>  			}
>  			break;
>  		case Opt_subvolid:
> -			num = match_strdup(&args[0]);
> -			if (num) {
> -				*subvol_objectid = memparse(num, NULL);
> -				kfree(num);
> -				/* we want the original fs_tree */
> -				if (!*subvol_objectid)
> -					*subvol_objectid =
> -						BTRFS_FS_TREE_OBJECTID;
> -			} else {
> -				error = -EINVAL;
> +			error = match_u64(&args[0], &subvolid);

So this is the right way (with the %s), as memparse accepts the size
suffixes (K/M/G/...), that we don't want for a subvolume id.

> +			if (error)
>  				goto out;
> -			}
> +
> +			/* we want the original fs_tree */
> +			if (subvolid == 0)
> +				subvolid = BTRFS_FS_TREE_OBJECTID;
> +
> +			*subvol_objectid = subvolid;
>  			break;
>  		case Opt_subvolrootid:
>  			pr_warn("BTRFS: 'subvolrootid' mount option is deprecated and has no effect\n");
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
