Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A463ECDE47
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 20:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5460820817
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 20:18:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVbNqFyq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5460820817
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbeKIFzs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 00:55:48 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35340 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbeKIFzs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Nov 2018 00:55:48 -0500
Received: by mail-oi1-f195.google.com with SMTP id v198-v6so18096209oif.2
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Nov 2018 12:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MOaPrOyj40gcVldS48NBuFq6zRhE+Vi2DMvprT+YAU0=;
        b=RVbNqFyq/bzhMWiqi4hKxdZsfNJm5p3y+CxSTX1mLrl/56/TPunJxasRbxa9DC2u9S
         ZCtZW7fX1Duro85mmPXABBuFLJ3G8sxHO+XPd7HAdoVMoiimRYIRA7VifNF5yRblQ62n
         ElokrY19CoYp5SwwEJb3NIV8Laqu5KnXJu+ElCQAiy8V8zp0ykp0vv7OsaTTaC8rO1oU
         9SJJ+1j7bS/4dGsJ1fheH59jXRoqkwtBR2YAFd8HAUHtrgyoJknaC7FF/IczBaYzZgY3
         4KvhHaJjWXvFe/uYBFBj3J9qwFrYs9PvRw+mnZC/KdR5fAO3Z2zehimCpM9BR8RgqoGL
         Tm9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MOaPrOyj40gcVldS48NBuFq6zRhE+Vi2DMvprT+YAU0=;
        b=jWEovgNbHqgoOvQWhl+9NT8ulVMHHTs9+5SWjZ4I3hhXGwyX3hlsNfdQ8QVbcMFv9a
         s43yMMzXbmgDWBtGWZYNCHwWq0/qHyo9bujjKpy6QkGCQWgGLTEUdoYkfM1bX2MMQrpi
         NntmfcF8fG1E3P62FFaHz6bgsZqQpinSZ12q75ftSuxnMadGpeg7NdSF0xg4AkAW0GbH
         RZyQoe/BaMl9lt0grwAsvqxksu5YVQe9x6YQEALdQ7XGBiu0ES65f1J/dCXCD035gkrc
         EOor1cC/uArEcSezaFgZjaHUflphaSi2oiu6Lj6FzyYoyISdsYl//Br5fxT8IAxxIWNc
         vU8w==
X-Gm-Message-State: AGRZ1gIyITYsWrEmb1SovgahixIds7xhMCQb+u92gXwkudd5AB11PTzs
        LzJgPIMo9Rq/kBCLQ1i/yezW/1j42Hl3Rlm/PvFLCz8L
X-Google-Smtp-Source: AJdET5ewcjQQXVwA3EHwo1CYx2kW4L5rZCPP0jZDCHnz2/lhNEAeXGGCoLPbXX5TJl7wzpSTSUOuVcJq8fMqtCB4yTU=
X-Received: by 2002:aca:a809:: with SMTP id r9-v6mr3604085oie.5.1541708323629;
 Thu, 08 Nov 2018 12:18:43 -0800 (PST)
MIME-Version: 1.0
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com> <20181106064122.6154-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20181106064122.6154-4-lufq.fnst@cn.fujitsu.com>
From:   Timofey Titovets <nefelim4ag@gmail.com>
Date:   Thu, 8 Nov 2018 23:18:07 +0300
Message-ID: <CAGqmi769aCwRcC893u+ms101_BEG5uaS-3_Nh7jYQhhCkzRARA@mail.gmail.com>
Subject: Re: [PATCH v15.1 03/13] btrfs: dedupe: Introduce function to add hash
 into in-memory tree
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
> Introduce static function inmem_add() to add hash into in-memory tree.
> And now we can implement the btrfs_dedupe_add() interface.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Reviewed-by: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/dedupe.c | 150 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 150 insertions(+)
>
> diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
> index 06523162753d..784bb3a8a5ab 100644
> --- a/fs/btrfs/dedupe.c
> +++ b/fs/btrfs/dedupe.c
> @@ -19,6 +19,14 @@ struct inmem_hash {
>         u8 hash[];
>  };
>
> +static inline struct inmem_hash *inmem_alloc_hash(u16 algo)
> +{
> +       if (WARN_ON(algo >=3D ARRAY_SIZE(btrfs_hash_sizes)))
> +               return NULL;
> +       return kzalloc(sizeof(struct inmem_hash) + btrfs_hash_sizes[algo]=
,
> +                       GFP_NOFS);
> +}
> +
>  static struct btrfs_dedupe_info *
>  init_dedupe_info(struct btrfs_ioctl_dedupe_args *dargs)
>  {
> @@ -167,3 +175,145 @@ int btrfs_dedupe_disable(struct btrfs_fs_info *fs_i=
nfo)
>         /* Place holder for bisect, will be implemented in later patches =
*/
>         return 0;
>  }
> +
> +static int inmem_insert_hash(struct rb_root *root,
> +                            struct inmem_hash *hash, int hash_len)
> +{
> +       struct rb_node **p =3D &root->rb_node;
> +       struct rb_node *parent =3D NULL;
> +       struct inmem_hash *entry =3D NULL;
> +
> +       while (*p) {
> +               parent =3D *p;
> +               entry =3D rb_entry(parent, struct inmem_hash, hash_node);
> +               if (memcmp(hash->hash, entry->hash, hash_len) < 0)
> +                       p =3D &(*p)->rb_left;
> +               else if (memcmp(hash->hash, entry->hash, hash_len) > 0)
> +                       p =3D &(*p)->rb_right;
> +               else
> +                       return 1;
> +       }
> +       rb_link_node(&hash->hash_node, parent, p);
> +       rb_insert_color(&hash->hash_node, root);
> +       return 0;
> +}
> +
> +static int inmem_insert_bytenr(struct rb_root *root,
> +                              struct inmem_hash *hash)
> +{
> +       struct rb_node **p =3D &root->rb_node;
> +       struct rb_node *parent =3D NULL;
> +       struct inmem_hash *entry =3D NULL;
> +
> +       while (*p) {
> +               parent =3D *p;
> +               entry =3D rb_entry(parent, struct inmem_hash, bytenr_node=
);
> +               if (hash->bytenr < entry->bytenr)
> +                       p =3D &(*p)->rb_left;
> +               else if (hash->bytenr > entry->bytenr)
> +                       p =3D &(*p)->rb_right;
> +               else
> +                       return 1;
> +       }
> +       rb_link_node(&hash->bytenr_node, parent, p);
> +       rb_insert_color(&hash->bytenr_node, root);
> +       return 0;
> +}
> +
> +static void __inmem_del(struct btrfs_dedupe_info *dedupe_info,
> +                       struct inmem_hash *hash)
> +{
> +       list_del(&hash->lru_list);
> +       rb_erase(&hash->hash_node, &dedupe_info->hash_root);
> +       rb_erase(&hash->bytenr_node, &dedupe_info->bytenr_root);
> +
> +       if (!WARN_ON(dedupe_info->current_nr =3D=3D 0))
> +               dedupe_info->current_nr--;
> +
> +       kfree(hash);
> +}
> +
> +/*
> + * Insert a hash into in-memory dedupe tree
> + * Will remove exceeding last recent use hash.
> + *
> + * If the hash mathced with existing one, we won't insert it, to
> + * save memory
> + */
> +static int inmem_add(struct btrfs_dedupe_info *dedupe_info,
> +                    struct btrfs_dedupe_hash *hash)
> +{
> +       int ret =3D 0;
> +       u16 algo =3D dedupe_info->hash_algo;
> +       struct inmem_hash *ihash;
> +
> +       ihash =3D inmem_alloc_hash(algo);
> +
> +       if (!ihash)
> +               return -ENOMEM;
> +
> +       /* Copy the data out */
> +       ihash->bytenr =3D hash->bytenr;
> +       ihash->num_bytes =3D hash->num_bytes;
> +       memcpy(ihash->hash, hash->hash, btrfs_hash_sizes[algo]);
> +
> +       mutex_lock(&dedupe_info->lock);
> +
> +       ret =3D inmem_insert_bytenr(&dedupe_info->bytenr_root, ihash);
> +       if (ret > 0) {
> +               kfree(ihash);
> +               ret =3D 0;
> +               goto out;
> +       }
> +
> +       ret =3D inmem_insert_hash(&dedupe_info->hash_root, ihash,
> +                               btrfs_hash_sizes[algo]);
> +       if (ret > 0) {
> +               /*
> +                * We only keep one hash in tree to save memory, so if
> +                * hash conflicts, free the one to insert.
> +                */
> +               rb_erase(&ihash->bytenr_node, &dedupe_info->bytenr_root);
> +               kfree(ihash);
> +               ret =3D 0;
> +               goto out;
> +       }
> +
> +       list_add(&ihash->lru_list, &dedupe_info->lru_list);
> +       dedupe_info->current_nr++;
> +
> +       /* Remove the last dedupe hash if we exceed limit */
> +       while (dedupe_info->current_nr > dedupe_info->limit_nr) {
> +               struct inmem_hash *last;
> +
> +               last =3D list_entry(dedupe_info->lru_list.prev,
> +                                 struct inmem_hash, lru_list);
> +               __inmem_del(dedupe_info, last);
> +       }
> +out:
> +       mutex_unlock(&dedupe_info->lock);
> +       return 0;
> +}
> +
> +int btrfs_dedupe_add(struct btrfs_fs_info *fs_info,
> +                    struct btrfs_dedupe_hash *hash)
> +{
> +       struct btrfs_dedupe_info *dedupe_info =3D fs_info->dedupe_info;
> +
> +       if (!fs_info->dedupe_enabled || !hash)
> +               return 0;
> +
> +       if (WARN_ON(dedupe_info =3D=3D NULL))
> +               return -EINVAL;
> +
> +       if (WARN_ON(!btrfs_dedupe_hash_hit(hash)))
> +               return -EINVAL;
> +
> +       /* ignore old hash */
> +       if (dedupe_info->blocksize !=3D hash->num_bytes)
> +               return 0;
> +
> +       if (dedupe_info->backend =3D=3D BTRFS_DEDUPE_BACKEND_INMEMORY)
> +               return inmem_add(dedupe_info, hash);
> +       return -EINVAL;
> +}
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
