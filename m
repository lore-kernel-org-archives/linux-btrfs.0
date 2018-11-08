Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D213C32789
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 12:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E6CF2086A
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 12:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LJbkha+S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E6CF2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbeKHWHY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 17:07:24 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34744 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbeKHWHY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2018 17:07:24 -0500
Received: by mail-ot1-f66.google.com with SMTP id t5so14336997otk.1
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Nov 2018 04:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s+TsPdpB7BmwuT8N5qXpJU4TmB+gefJ9+3+lUEjyuwU=;
        b=LJbkha+SjU+c1jHILIQrhajdnV9GO6tQGfPNAps+glE1c31X2zVj0qCv8H6rVvIku5
         BX5ZneySAPsLjhnn0fnR5YHxuxF4Jw0ZJg1BLG1DU3RMOA5R9cXiE5opiqtcEdNoHmyr
         GRQNQkDn3XKB2/1RPkUaGPgWwZvuP4TAnx7Bv+B06gFmCF+/NLBWtraglS02/af8fpu1
         KuUx7q9rUShEL+1i9SJygWpFI+Xx7FMTZI7gP6gty2rD/TZplExfQJojiB/PiYpp92PO
         YObrmT70aqaIQabj1LlkERAXheTuqBuMIpoNk47i4lQW+dG5jhLk8LNU8k5Dwbv73QLE
         PKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s+TsPdpB7BmwuT8N5qXpJU4TmB+gefJ9+3+lUEjyuwU=;
        b=Ca52MOfYZ4R01vJctWJr2AosZADmzNmGVfjerjQz6INKgT5XUwzECc2mPyyl6no6Jm
         88RxpQOZrpDK34N462sDy73646TEDfslBftcj+njGgqXzc7IZF8NQebWI+b7MXK7ddyY
         bWSfKk1+sVILGPl+yzgumtVJTWYP+hT/llI0cg50sfomDh1AksDEIfXZN7bH21aZcD5k
         rvGdsIjS75nETJozUZ/Hf3oykRJ3+zptavO0IFrWM17Iqu9mRnf1GHgpaxwB35rGLZdc
         Fq/uZ1MTsNOnlupUMR8aZ5oRFEziCcrKeny15ZOw1E8pEXF8UFNpWknvDiOUdiAPHkiJ
         dlqQ==
X-Gm-Message-State: AGRZ1gKCDQwFGn7AgMvZ9QkeWv7t0kmNwWbSziB2thnEEcbEEJZiz4/1
        tok0bXwuWJaTgtfUSboVbzGJpaPsIaMoksS2+rreFd4G
X-Google-Smtp-Source: AJdET5ekai8dkAnLUWuXFpPBXslspuAtEGfZgsy3Lk5vVrhaybaKW+q7klgoxgTIONoA6L19/7t0Zv+SXhutxV65LRA=
X-Received: by 2002:a9d:738a:: with SMTP id j10mr2668916otk.188.1541680327024;
 Thu, 08 Nov 2018 04:32:07 -0800 (PST)
MIME-Version: 1.0
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com> <20181106064122.6154-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20181106064122.6154-3-lufq.fnst@cn.fujitsu.com>
From:   Timofey Titovets <nefelim4ag@gmail.com>
Date:   Thu, 8 Nov 2018 15:31:30 +0300
Message-ID: <CAGqmi75Fd_kDcJ6q0M0AgK4G=xnBnQuB6QGVmi0i=U+SUTMETQ@mail.gmail.com>
Subject: Re: [PATCH v15.1 02/13] btrfs: dedupe: Introduce function to
 initialize dedupe info
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        wangxg.fnst@cn.fujitsu.com, Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

=D0=B2=D1=82, 6 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 9:41, Lu Feng=
qi <lufq.fnst@cn.fujitsu.com>:
>
> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>
> Add generic function to initialize dedupe info.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Reviewed-by: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/Makefile          |   2 +-
>  fs/btrfs/dedupe.c          | 169 +++++++++++++++++++++++++++++++++++++
>  fs/btrfs/dedupe.h          |  12 +++
>  include/uapi/linux/btrfs.h |   3 +
>  4 files changed, 185 insertions(+), 1 deletion(-)
>  create mode 100644 fs/btrfs/dedupe.c
>
> diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
> index ca693dd554e9..78fdc87dba39 100644
> --- a/fs/btrfs/Makefile
> +++ b/fs/btrfs/Makefile
> @@ -10,7 +10,7 @@ btrfs-y +=3D super.o ctree.o extent-tree.o print-tree.o=
 root-tree.o dir-item.o \
>            export.o tree-log.o free-space-cache.o zlib.o lzo.o zstd.o \
>            compression.o delayed-ref.o relocation.o delayed-inode.o scrub=
.o \
>            reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56=
.o \
> -          uuid-tree.o props.o free-space-tree.o tree-checker.o
> +          uuid-tree.o props.o free-space-tree.o tree-checker.o dedupe.o
>
>  btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) +=3D acl.o
>  btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) +=3D check-integrity.o
> diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
> new file mode 100644
> index 000000000000..06523162753d
> --- /dev/null
> +++ b/fs/btrfs/dedupe.c
> @@ -0,0 +1,169 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2016 Fujitsu.  All rights reserved.
> + */
> +
> +#include "ctree.h"
> +#include "dedupe.h"
> +#include "btrfs_inode.h"
> +#include "delayed-ref.h"
> +
> +struct inmem_hash {
> +       struct rb_node hash_node;
> +       struct rb_node bytenr_node;
> +       struct list_head lru_list;
> +
> +       u64 bytenr;
> +       u32 num_bytes;
> +
> +       u8 hash[];
> +};
> +
> +static struct btrfs_dedupe_info *
> +init_dedupe_info(struct btrfs_ioctl_dedupe_args *dargs)
> +{
> +       struct btrfs_dedupe_info *dedupe_info;
> +
> +       dedupe_info =3D kzalloc(sizeof(*dedupe_info), GFP_NOFS);
> +       if (!dedupe_info)
> +               return ERR_PTR(-ENOMEM);
> +
> +       dedupe_info->hash_algo =3D dargs->hash_algo;
> +       dedupe_info->backend =3D dargs->backend;
> +       dedupe_info->blocksize =3D dargs->blocksize;
> +       dedupe_info->limit_nr =3D dargs->limit_nr;
> +
> +       /* only support SHA256 yet */
> +       dedupe_info->dedupe_driver =3D crypto_alloc_shash("sha256", 0, 0)=
;
> +       if (IS_ERR(dedupe_info->dedupe_driver)) {
> +               kfree(dedupe_info);
> +               return ERR_CAST(dedupe_info->dedupe_driver);
> +       }
> +
> +       dedupe_info->hash_root =3D RB_ROOT;
> +       dedupe_info->bytenr_root =3D RB_ROOT;
> +       dedupe_info->current_nr =3D 0;
> +       INIT_LIST_HEAD(&dedupe_info->lru_list);
> +       mutex_init(&dedupe_info->lock);
> +
> +       return dedupe_info;
> +}
> +
> +/*
> + * Helper to check if parameters are valid.
> + * The first invalid field will be set to (-1), to info user which param=
eter
> + * is invalid.
> + * Except dargs->limit_nr or dargs->limit_mem, in that case, 0 will retu=
rned
> + * to info user, since user can specify any value to limit, except 0.
> + */
> +static int check_dedupe_parameter(struct btrfs_fs_info *fs_info,
> +                                 struct btrfs_ioctl_dedupe_args *dargs)
> +{
> +       u64 blocksize =3D dargs->blocksize;
> +       u64 limit_nr =3D dargs->limit_nr;
> +       u64 limit_mem =3D dargs->limit_mem;
> +       u16 hash_algo =3D dargs->hash_algo;
> +       u8 backend =3D dargs->backend;
> +
> +       /*
> +        * Set all reserved fields to -1, allow user to detect
> +        * unsupported optional parameters.
> +        */
> +       memset(dargs->__unused, -1, sizeof(dargs->__unused));
> +       if (blocksize > BTRFS_DEDUPE_BLOCKSIZE_MAX ||
> +           blocksize < BTRFS_DEDUPE_BLOCKSIZE_MIN ||
> +           blocksize < fs_info->sectorsize ||
> +           !is_power_of_2(blocksize) ||
> +           blocksize < PAGE_SIZE) {
> +               dargs->blocksize =3D (u64)-1;
> +               return -EINVAL;
> +       }
> +       if (hash_algo >=3D ARRAY_SIZE(btrfs_hash_sizes)) {
> +               dargs->hash_algo =3D (u16)-1;
> +               return -EINVAL;
> +       }
> +       if (backend >=3D BTRFS_DEDUPE_BACKEND_COUNT) {
> +               dargs->backend =3D (u8)-1;
> +               return -EINVAL;
> +       }
> +
> +       /* Backend specific check */
> +       if (backend =3D=3D BTRFS_DEDUPE_BACKEND_INMEMORY) {
> +               /* only one limit is accepted for enable*/
> +               if (dargs->limit_nr && dargs->limit_mem) {
> +                       dargs->limit_nr =3D 0;
> +                       dargs->limit_mem =3D 0;
> +                       return -EINVAL;
> +               }
> +
> +               if (!limit_nr && !limit_mem)
> +                       dargs->limit_nr =3D BTRFS_DEDUPE_LIMIT_NR_DEFAULT=
;
> +               else {
> +                       u64 tmp =3D (u64)-1;
> +
> +                       if (limit_mem) {
> +                               tmp =3D div_u64(limit_mem,
> +                                       (sizeof(struct inmem_hash)) +
> +                                       btrfs_hash_sizes[hash_algo]);
> +                               /* Too small limit_mem to fill a hash ite=
m */
> +                               if (!tmp) {
> +                                       dargs->limit_mem =3D 0;
> +                                       dargs->limit_nr =3D 0;
> +                                       return -EINVAL;
> +                               }
> +                       }
> +                       if (!limit_nr)
> +                               limit_nr =3D (u64)-1;
> +
> +                       dargs->limit_nr =3D min(tmp, limit_nr);
> +               }
> +       }
> +       if (backend =3D=3D BTRFS_DEDUPE_BACKEND_ONDISK)
> +               dargs->limit_nr =3D 0;
> +
> +       return 0;
> +}
> +
> +int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info,
> +                       struct btrfs_ioctl_dedupe_args *dargs)
> +{
> +       struct btrfs_dedupe_info *dedupe_info;
> +       int ret =3D 0;
> +
> +       ret =3D check_dedupe_parameter(fs_info, dargs);
> +       if (ret < 0)
> +               return ret;
> +
> +       dedupe_info =3D fs_info->dedupe_info;
> +       if (dedupe_info) {
> +               /* Check if we are re-enable for different dedupe config =
*/
> +               if (dedupe_info->blocksize !=3D dargs->blocksize ||
> +                   dedupe_info->hash_algo !=3D dargs->hash_algo ||
> +                   dedupe_info->backend !=3D dargs->backend) {
> +                       btrfs_dedupe_disable(fs_info);
> +                       goto enable;
> +               }
> +
> +               /* On-fly limit change is OK */
> +               mutex_lock(&dedupe_info->lock);
> +               fs_info->dedupe_info->limit_nr =3D dargs->limit_nr;
> +               mutex_unlock(&dedupe_info->lock);
> +               return 0;
> +       }
> +
> +enable:
> +       dedupe_info =3D init_dedupe_info(dargs);
> +       if (IS_ERR(dedupe_info))
> +               return PTR_ERR(dedupe_info);
> +       fs_info->dedupe_info =3D dedupe_info;
> +       /* We must ensure dedupe_bs is modified after dedupe_info */
> +       smp_wmb();
> +       fs_info->dedupe_enabled =3D 1;
> +       return ret;
> +}
> +
> +int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
> +{
> +       /* Place holder for bisect, will be implemented in later patches =
*/
> +       return 0;
> +}
> diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
> index 222ce7b4d827..87f5b7ce7766 100644
> --- a/fs/btrfs/dedupe.h
> +++ b/fs/btrfs/dedupe.h
> @@ -52,6 +52,18 @@ static inline int btrfs_dedupe_hash_hit(struct btrfs_d=
edupe_hash *hash)
>         return (hash && hash->bytenr);
>  }
>
> +static inline int btrfs_dedupe_hash_size(u16 algo)
> +{
> +       if (WARN_ON(algo >=3D ARRAY_SIZE(btrfs_hash_sizes)))
> +               return -EINVAL;
> +       return sizeof(struct btrfs_dedupe_hash) + btrfs_hash_sizes[algo];
> +}
> +
> +static inline struct btrfs_dedupe_hash *btrfs_dedupe_alloc_hash(u16 algo=
)
> +{
> +       return kzalloc(btrfs_dedupe_hash_size(algo), GFP_NOFS);
> +}
> +
>  /*
>   * Initial inband dedupe info
>   * Called at dedupe enable time.
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 9cd15d2a40aa..ba879ac931f2 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -683,6 +683,9 @@ struct btrfs_ioctl_get_dev_stats {
>  /* Hash algorithm, only support SHA256 yet */
>  #define BTRFS_DEDUPE_HASH_SHA256               0
>
> +/* Default dedupe limit on number of hash */
> +#define BTRFS_DEDUPE_LIMIT_NR_DEFAULT  (32 * 1024)
> +
>  /*
>   * This structure is used for dedupe enable/disable/configure
>   * and status ioctl.
> --
> 2.19.1
>
>
>
Reviewed-by: Timofey Titovets <nefelim4ag@gmail.com>

Thanks.

--=20
Have a nice day,
Timofey.
