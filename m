From: Lee Trager <lt73@cs.drexel.edu>
Subject: Re: [PATCH] Btrfs-progs: btrfs file system size should be bigger
 then 256m
Date: Wed, 31 Dec 2008 02:41:11 -0500
Message-ID: <495B2217.3030403@cs.drexel.edu>
References: <495B0D54.7060806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <495B0D54.7060806@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This has been bothering me for some time. Why does btrfs need to have a 
disk greater then 256M? I could see a much smaller limit, say 16M but 
why so much? The file system itself does not need that much space for 
its own use.

Thanks,

Lee

Shen Feng wrote:
> According to btrfs_prepare_device, btrfs file sysstem size
> should be bigger then 256m.
>
> If mkfs.btrfs specifies the file system size samaller then
> that, mkfs.btrfs should report error.
>
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
> ---
>  mkfs.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/mkfs.c b/mkfs.c
> index be93aaa..447e8d7 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -377,6 +377,10 @@ int main(int ac, char **av)
>  				break;
>  			case 'b':
>  				block_count = parse_size(optarg);
> +				if (block_count < 256*1024*1024) {
> +					fprintf(stderr, "File system size is too small\n");
> +					exit(1);
> +				}
>  				zero_end = 0;
>  				break;
>  			default:
>   

