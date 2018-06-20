Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:13312 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932170AbeFTR66 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:58:58 -0400
From: Bart Van Assche <Bart.VanAssche@wdc.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        "nborisov@suse.com" <nborisov@suse.com>,
        "jeffm@suse.com" <jeffm@suse.com>,
        "dsterba@suse.com" <dsterba@suse.com>, "clm@fb.com" <clm@fb.com>,
        "jbacik@fb.com" <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Fix a C compliance issue
Date: Wed, 20 Jun 2018 17:58:56 +0000
Message-ID: <ab2fe7aeb602c1fc72253d3861dae96e3cba874c.camel@wdc.com>
References: <20180615223659.32420-1-bart.vanassche@wdc.com>
         <838e73e8-e9b8-6075-1d69-79bc65c15b0c@suse.com>
         <20180618092633.GH24375@twin.jikos.cz>
         <14645aca-930b-2d7d-a7d6-6893f7cfcbbd@suse.com>
         <c8f558835c1a767e24c00b7c3508a48a4d886cc4.camel@wdc.com>
         <20180620165556.GF24375@twin.jikos.cz>
         <de233b2c-8487-5be6-c189-7fca5d453048@suse.com>
In-Reply-To: <de233b2c-8487-5be6-c189-7fca5d453048@suse.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2018-06-20 at 13:19 -0400, Jeff Mahoney wrote:
> The shed should be yellow.
> 
> -Jeff
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 891cd2ed5dd4..57c9da0b459f 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2375,21 +2375,20 @@ static __cold void btrfs_interface_exit(void)
> 
>  static void __init btrfs_print_mod_info(void)
>  {
> -	pr_info("Btrfs loaded, crc32c=%s"
> +	pr_info("Btrfs loaded, crc32c=%s", crc32c_impl());
>  #ifdef CONFIG_BTRFS_DEBUG
> -			", debug=on"
> +	pr_cont(", debug=on");
>  #endif
>  #ifdef CONFIG_BTRFS_ASSERT
> -			", assert=on"
> +	pr_cont(", assert=on");
>  #endif
>  #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
> -			", integrity-checker=on"
> +	pr_cont(", integrity-checker=on");
>  #endif
>  #ifdef CONFIG_BTRFS_FS_REF_VERIFY
> -			", ref-verify=on"
> +	pr_cont(", ref-verify=on")
>  #endif
> -			"\n",
> -			crc32c_impl());
> +	pr_cont("\n");
>  }
> 
>  static int null_open(struct block_device *bdev, fmode_t mode)

Since we are doing bikeshedding, let me contribute to it :-)

>From scripts/checkpatch.pl:

                if ($line =~ /\bprintk\s*\(\s*KERN_CONT\b|\bpr_cont\s*\(/) {
                        WARN("LOGGING_CONTINUATION",
                             "Avoid logging continuation uses where feasible\n" . $herecurr);
                }

Bart.





ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
