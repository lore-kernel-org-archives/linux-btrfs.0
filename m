From: Avi Kivity <avi@redhat.com>
Subject: Re: Compile error of latest hotfix release of btrfs
Date: Mon, 03 Nov 2008 22:22:51 +0200
Message-ID: <490F5D9B.5040400@redhat.com>
References: <490EB395.2020803@turknet.net.tr>	 <977a2be20811030549l6b9a04edxafe7aec9729c3471@mail.gmail.com>	 <490F0C87.20300@turknet.net.tr> <977a2be20811030719q674bc5bo1f6ce200806e583@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Tarkan Erimer <tarkan.erimer@turknet.net.tr>,
	linux-btrfs@vger.kernel.org
To: yanhai zhu <zhu.yanhai@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <977a2be20811030719q674bc5bo1f6ce200806e583@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

yanhai zhu wrote:
> sorry,
>
> --
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 9b37ce6..04a0e58 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2539,7 +2539,11 @@ int extent_readpages(struct extent_io_tree *tree,
>                         /* open coding of lru_cache_add, also not exported */
>                         page_cache_get(page);
>                         if (!pagevec_add(&pvec, page))
> +                       #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
> +                               __pagevec_lru_add_file(&pvec);
> +                       #else
>                                 __pagevec_lru_add(&pvec);
> +                       #endif
>   

Suggest sticking in some compat header:

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
+#     define  __pagevec_lru_add_file __pagevec_lru_add
+#endif


To reduce impact on code that is intended to go to mainline.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

