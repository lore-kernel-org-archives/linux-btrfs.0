From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: trivial fix, a potential memory leak in btrfs_parse_early_options()
Date: Wed, 14 Sep 2011 13:40:29 +0800
Message-ID: <4E703E4D.3040101@cn.fujitsu.com>
References: <4E6EF2CD.3070302@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: jeff.liu@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E6EF2CD.3070302@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

14:06, Jeff Liu wrote:
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> ---
>  fs/btrfs/super.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 15634d4..16f31e1 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -406,7 +406,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>          u64 *subvol_rootid, struct btrfs_fs_devices **fs_devices)
>  {
>      substring_t args[MAX_OPT_ARGS];
> -    char *opts, *orig, *p;
> +    char *device_name, *opts, *orig, *p;

Seems your email client replaced tabs with spaces.

Please read Documentation/email-clients.txt

>      int error = 0;
>      int intarg;
> 
> @@ -457,8 +457,14 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>              }
>              break;
>          case Opt_device:
> -            error = btrfs_scan_one_device(match_strdup(&args[0]),
> +            device_name = match_strdup(&args[0]);
> +            if (!device_name) {
> +                error = -ENOMEM;
> +                goto out_free_opts;
> +            }
> +            error = btrfs_scan_one_device(device_name,
>                      flags, holder, fs_devices);
> +            kfree(device_name);
>              if (error)
>                  goto out_free_opts;
>              break;
