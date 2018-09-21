Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41188 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391323AbeIVCaV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 22:30:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id z3-v6so1582094pgv.8
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 13:39:47 -0700 (PDT)
Date: Fri, 21 Sep 2018 13:39:45 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] btrfs-progs: Add freespace tree as compat_ro
 supported feature
Message-ID: <20180921203945.GA4233@vader>
References: <1529060762-4372-1-git-send-email-nborisov@suse.com>
 <1529060762-4372-5-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529060762-4372-5-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 15, 2018 at 02:06:00PM +0300, Nikolay Borisov wrote:
> The RO_FREE_SPACE_TREE(_VALID) flags are required in order to be able
> to open an FST filesystem in repair mode. Add them to
> BTRFS_FEATURE_COMPAT_RO_SUPP.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  ctree.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/ctree.h b/ctree.h
> index ade883fecbd6..ef05e8122982 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -497,7 +497,9 @@ struct btrfs_super_block {
>   * added here until read-write support for the free space tree is implemented in
>   * btrfs-progs.
>   */
> -#define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
> +#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
> +	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
> +	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID)


Have you tested whether btrfs-progs commands that modify the filesystem
(e.g., btrfstune or btrfs fi label) work with this series? Because that
is a requirement for claiming that we support this bit (at which point
we can delete the comment above). Also, this needs to happen _after_ we
hook up the free space tree with the extent tree.

See here for some historical context:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg57738.html
