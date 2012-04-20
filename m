From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/4] mkfs: use strdup in place of strlen,malloc,strcpy
 sequence
Date: Fri, 20 Apr 2012 14:36:56 -0400
Message-ID: <20120420183655.GA1957@localhost.localdomain>
References: <1334943408-6720-1-git-send-email-jim@meyering.net>
 <1334943408-6720-2-git-send-email-jim@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334943408-6720-2-git-send-email-jim@meyering.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2012 at 07:36:45PM +0200, Jim Meyering wrote:
> From: Jim Meyering <meyering@redhat.com>
> 
> * mkfs.c (traverse_directory): No semantic change.
> ---
>  mkfs.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mkfs.c b/mkfs.c
> index c531ef2..03239fb 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -911,8 +911,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
>  	/* Add list for source directory */
>  	dir_entry = malloc(sizeof(struct directory_name_entry));
>  	dir_entry->dir_name = dir_name;
> -	dir_entry->path = malloc(strlen(dir_name) + 1);
> -	strcpy(dir_entry->path, dir_name);
> +	dir_entry->path = strdup(dir_name);
> 
>  	parent_inum = highest_inum + BTRFS_FIRST_FREE_OBJECTID;
>  	dir_entry->inum = parent_inum;
> -- 
> 1.7.10.208.gb4267
> 

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
