Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23879 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751452AbdBNJ30 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 04:29:26 -0500
Subject: Re: [PATCH 2/7] btrfs: ulist: make the finalization function public
To: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1486995885.git.dsterba@suse.com>
 <0e94449a7f999c37d1a69809d49857f0855bfdec.1486995885.git.dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <50638123-8b6a-c102-47f4-57a176cca873@cn.fujitsu.com>
Date: Tue, 14 Feb 2017 17:29:14 +0800
MIME-Version: 1.0
In-Reply-To: <0e94449a7f999c37d1a69809d49857f0855bfdec.1486995885.git.dsterba@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/13/2017 10:30 PM, David Sterba wrote:
> Make ulist_fini externally visible so the ulist API is complete.

Looks good to me.

While I'm not pretty sure if the name "ulist_fini" is good enough.

Maybe "ulist_finish" or "ulist_release" (just like release_path and 
free_path)?

Thanks,
Qu
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ulist.c | 2 +-
>  fs/btrfs/ulist.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
> index b1434bb57e36..5deee56434fc 100644
> --- a/fs/btrfs/ulist.c
> +++ b/fs/btrfs/ulist.c
> @@ -58,7 +58,7 @@ void ulist_init(struct ulist *ulist)
>   * This is useful in cases where the base 'struct ulist' has been statically
>   * allocated.
>   */
> -static void ulist_fini(struct ulist *ulist)
> +void ulist_fini(struct ulist *ulist)
>  {
>  	struct ulist_node *node;
>  	struct ulist_node *next;
> diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
> index 007b22fff3f9..1a4130443d7e 100644
> --- a/fs/btrfs/ulist.h
> +++ b/fs/btrfs/ulist.h
> @@ -44,6 +44,7 @@ struct ulist {
>  };
>
>  void ulist_init(struct ulist *ulist);
> +void ulist_fini(struct ulist *ulist);
>  void ulist_reinit(struct ulist *ulist);
>  struct ulist *ulist_alloc(gfp_t gfp_mask);
>  void ulist_free(struct ulist *ulist);
>


