Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:44172 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaCJPZL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 11:25:11 -0400
Received: by mail-ob0-f178.google.com with SMTP id wp18so7075593obc.23
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Mar 2014 08:25:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1392608637-24756-1-git-send-email-sachin.kamat@linaro.org>
References: <1392608637-24756-1-git-send-email-sachin.kamat@linaro.org>
Date: Mon, 10 Mar 2014 20:55:11 +0530
Message-ID: <CAK9yfHyz66Zt5ZdKy1LYfE1skh-Z5Qx9p6y5Agg1EtKzof0jYg@mail.gmail.com>
Subject: Re: [PATCH Resend] btrfs: Use PTR_ERR_OR_ZERO
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: clm <clm@fb.com>, jbacik <jbacik@fb.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17 February 2014 09:13, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> PTR_RET is deprecated. Use PTR_ERR_OR_ZERO instead. While at it
> also include missing err.h header.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  fs/btrfs/root-tree.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 1389b69059de..38bb47e7d6b1 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -16,6 +16,7 @@
>   * Boston, MA 021110-1307, USA.
>   */
>
> +#include <linux/err.h>
>  #include <linux/uuid.h>
>  #include "ctree.h"
>  #include "transaction.h"
> @@ -271,7 +272,7 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
>                 key.offset++;
>
>                 root = btrfs_read_fs_root(tree_root, &root_key);
> -               err = PTR_RET(root);
> +               err = PTR_ERR_OR_ZERO(root);
>                 if (err && err != -ENOENT) {
>                         break;
>                 } else if (err == -ENOENT) {
> --
> 1.7.9.5
>

 Ping..

-- 
With warm regards,
Sachin
