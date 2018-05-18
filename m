Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35057 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751009AbeERRFE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 13:05:04 -0400
Date: Fri, 18 May 2018 19:02:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix describe_relocation string pointer
Message-ID: <20180518170219.GT6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180517132512.16377-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180517132512.16377-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2018 at 09:25:12PM +0800, Anand Jain wrote:
> Looks like the original idea was to print the hex of the flags which
> is not coded with their flag name. So use the current buf pointer bp
> instead of buf.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/relocation.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 74656d79e511..879b76fa881a 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4344,7 +4344,7 @@ static void describe_relocation(struct btrfs_fs_info *fs_info,
>  		DESCRIBE_FLAG(RAID5,    "raid5");
>  		DESCRIBE_FLAG(RAID6,    "raid6");
>  		if (flags)
> -			snprintf(buf, buf - bp + sizeof(buf), "|0x%llx", flags);
> +			snprintf(bp, buf - bp + sizeof(buf), "|0x%llx", flags);

Good catch.

Reviewed-by: David Sterba <dsterba@suse.com>
