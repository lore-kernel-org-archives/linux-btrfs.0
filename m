From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 2/4] restore: don't corrupt stack for a zero-length
 command-line argument
Date: Fri, 20 Apr 2012 14:37:53 -0400
Message-ID: <20120420183752.GB1957@localhost.localdomain>
References: <1334943408-6720-1-git-send-email-jim@meyering.net>
 <1334943408-6720-3-git-send-email-jim@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334943408-6720-3-git-send-email-jim@meyering.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2012 at 07:36:46PM +0200, Jim Meyering wrote:
> From: Jim Meyering <meyering@redhat.com>
> 
> Given a zero-length directory name, the trailing-slash removal
> code would test dir_name[-1], and if it were found to be a slash,
> would set it to '\0'.
> ---
>  restore.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/restore.c b/restore.c
> index 250c9d3..f049105 100644
> --- a/restore.c
> +++ b/restore.c
> @@ -849,11 +849,9 @@ int main(int argc, char **argv)
>  	strncpy(dir_name, argv[optind + 1], 128);
> 
>  	/* Strip the trailing / on the dir name */
> -	while (1) {
> -		len = strlen(dir_name);
> -		if (dir_name[len - 1] != '/')
> -			break;
> -		dir_name[len - 1] = '\0';
> +	len = strlen(dir_name);
> +	while (len && dir_name[--len] == '/')) {
> +		dir_name[len] = '\0';
>  	}
> 
>  	if (find_dir) {

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
