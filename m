From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: [PATCH] Add -v option to btrfsctl to control verbosity: Be quiet
 unless requested.
Date: Sat, 22 Jan 2011 13:11:24 +0100
Message-ID: <20110122121124.GA2564@scooter>
References: <4D3AC69A.2080302@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D3AC69A.2080302@gmx.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfsctl is deprecated, why you're adding new options to it? :)


Regards,
Felix

On 22. January 2011 - 12:59, Maximilian Mehnert wrote:
> Date:	Sat, 22 Jan 2011 12:59:22 +0100
> From: Maximilian Mehnert <maximilian.mehnert@gmx.de>
> To: linux-btrfs <linux-btrfs@vger.kernel.org>
> Subject: [PATCH] Add -v option to btrfsctl to control verbosity: Be quiet
>  unless requested.
> 
> ---
>   btrfsctl.c |   10 ++++++++--
>   1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/btrfsctl.c b/btrfsctl.c
> index 92bdf39..156ed62 100644
> --- a/btrfsctl.c
> +++ b/btrfsctl.c
> @@ -106,6 +106,7 @@ int main(int ac, char **av)
>   	char *pos;
>   	char *fullpath;
>   	u64 objectid = 0;
> +	int verbose = 0;
>    	if (ac == 2 && strcmp(av[1], "-a") == 0) {
>   		fprintf(stderr, "Scanning for Btrfs filesystems\n");
> @@ -217,6 +218,9 @@ int main(int ac, char **av)
>   				}
>   			}
>   		}
> +		else if (strcmp(av[i], "-v") == 0) {
> +			verbose = 1;
> +		}
>   	}
>   	if (command == 0) {
>   		fprintf(stderr, "no valid commands given\n");
> @@ -254,11 +258,13 @@ int main(int ac, char **av)
>   		exit(1);
>   	}
>   	if (ret == 0) {
> -		printf("operation complete\n");
> +		if (verbose) printf("operation complete\n");
>   	} else {
>   		printf("ioctl failed with error %d\n", ret);
>   	}
> -	printf("%s\n", BTRFS_BUILD_VERSION);
> +	if (verbose) {
> +		printf("%s\n", BTRFS_BUILD_VERSION);
> +	}
>   	if (ret)
>   		exit(1);
>   -- 1.7.2.3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
