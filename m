Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46588 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754052AbeFPK2Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Jun 2018 06:28:16 -0400
Subject: Re: [PATCH] btrfs: Fix a C compliance issue
To: Bart Van Assche <bart.vanassche@wdc.com>, Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>
References: <20180615223659.32420-1-bart.vanassche@wdc.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <838e73e8-e9b8-6075-1d69-79bc65c15b0c@suse.com>
Date: Sat, 16 Jun 2018 13:28:13 +0300
MIME-Version: 1.0
In-Reply-To: <20180615223659.32420-1-bart.vanassche@wdc.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.06.2018 01:36, Bart Van Assche wrote:
> The C programming language does not allow to use preprocessor statements
> inside macro arguments (pr_info() is defined as a macro). Hence rework
> the pr_info() statement in btrfs_print_mod_info() such that it becomes
> compliant. This patch allows tools like sparse to analyze the BTRFS
> source code.
> 
> Fixes: 62e855771dac ("btrfs: convert printk(KERN_* to use pr_* calls")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 81107ad49f3a..dd4980df5b8e 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2369,7 +2369,7 @@ static __cold void btrfs_interface_exit(void)
>  
>  static void __init btrfs_print_mod_info(void)
>  {
> -	pr_info("Btrfs loaded, crc32c=%s"
> +	static const char fmt[] = KERN_INFO "Btrfs loaded, crc32c=%s"
>  #ifdef CONFIG_BTRFS_DEBUG
>  			", debug=on"
>  #endif
> @@ -2382,8 +2382,8 @@ static void __init btrfs_print_mod_info(void)
>  #ifdef CONFIG_BTRFS_FS_REF_VERIFY
>  			", ref-verify=on"
>  #endif
> -			"\n",
> -			crc32c_impl());
> +			"\n";
> +	printk(fmt, crc32c_impl());

I'd rather not see more printk being added. Nothing prevents from having
the fmt string being passed to pr_info.
>  }
>  
>  static int __init init_btrfs_fs(void)
> 
