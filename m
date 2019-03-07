Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F4CC43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 10:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA26C20675
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 10:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cgNTJom1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfCGKVX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 05:21:23 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:44126 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfCGKVX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2019 05:21:23 -0500
Received: by mail-ua1-f66.google.com with SMTP id r21so9992447uan.11
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Mar 2019 02:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=0SvsEW1B95LwJFL9LWembjVqQD2CjuObdLXSQBhykEM=;
        b=cgNTJom1rLsoQu9RjNi+5lJRAO/xrAcbnoSnzaM4mlu6ku6H1FldYvFPWcrJ7oYlhl
         fnUo5VbauoK76hORXtc1PPDBenKmu8gw34UciZQwV/grCTZyMz7oP5SvvKDDQZj0PQ8J
         wl4y4pw443quqzib4cWddZ77bwyOh3gQxae2EtHq9BujwRNW1VakeTHC7el8g5aeI7rN
         7Jrp4q7P/uO7eVGhqwyel7EmQF4jBe7f9FfOaCpdzTdZCDkdGy6kE6PsWRu3HEgInpoZ
         Whu0nf5ypQ5li+90P4vob0v4CNJtHOxVjbq/suDQ8rM3mnJ/rmSEQDYthr8uZrKbkNuS
         y1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=0SvsEW1B95LwJFL9LWembjVqQD2CjuObdLXSQBhykEM=;
        b=KETkitsgAXyvyA+tRtW4aCqztRMeMZeb5RxxX/hDaGNjUGpLOxP1uQUFpVrWgjIlz5
         S8lWxjwffvYMI69CuYAoT5+gj8ebkGwG181m101oYaou4slhhYLB4GBJ9bJ9THk8OQds
         ydHl9UnefMm+Iral2Usa4/6JI588end+87It339h/MHc8X3kiCGcLR7Q9LNHuIWOQDda
         elS3vWe9uYnyvgng7lAyjv0lsrCG7dvl5y7BGiKJ6t8Xh/I9dE2KL3ua5mSAC7BJKwCa
         gogNS4ApTyHsXTASGIiYAWd/6LwQnIWs5rwovER0zUQYe6HvRE40PQX1oUhaaTrf3ads
         sIMQ==
X-Gm-Message-State: APjAAAXvN3WZN+8O14pB/7SUQevCRTAa9DqkPo4TPN65iAQrWEoOcNv+
        vs5KGkGyldRXoV4P19GfwRh8WQA9PRIQic9vjFKVSA==
X-Google-Smtp-Source: APXvYqy8xRi7ZQJOAf+At/kyDLoRmmhXfe6/KZ4Trt4ehXqwaWJ4AJN6y1mofbSUSlGCHN2IyKsRcWBW3ell++PBm6o=
X-Received: by 2002:ab0:1e03:: with SMTP id m3mr6397355uak.108.1551954081777;
 Thu, 07 Mar 2019 02:21:21 -0800 (PST)
MIME-Version: 1.0
References: <20190306221304.29503-1-josef@toxicpanda.com>
In-Reply-To: <20190306221304.29503-1-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 7 Mar 2019 10:21:10 +0000
Message-ID: <CAL3q7H4-N-Ra=4gVsd43pYa-et8VdJKwWQU_bqQyj2xJE+rh3g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: remove WARN_ON() in log_dir_items
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 6, 2019 at 10:15 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> When Filipe added the recursive directory logging stuff he specifically
> didn't take the directory i_mutex for the children directories that we
> need to log because of lockdep.  This is generally fine, but can lead to
> this WARN_ON() tripping if we happen to run delayed deletion's in
> between our first search and our second search of dir_item/dir_indexes
> for this directory.  We expect this to happen, so the WARN_ON() isn't
> necessary.  Drop the WARN_ON() and add a comment so we know why this
> case can happen.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks!

> ---
>  fs/btrfs/tree-log.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index f06454a55e00..bccb62c1c587 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3578,9 +3578,16 @@ static noinline int log_dir_items(struct btrfs_tra=
ns_handle *trans,
>         }
>         btrfs_release_path(path);
>
> -       /* find the first key from this transaction again */
> +       /*
> +        * Find the first key from this transaction again.  See the note =
for
> +        * log_new_dir_dentries, if we're logging a directory recursively=
 we
> +        * won't be holding its i_mutex, which means we can modify the di=
rectory
> +        * while we're logging it.  If we remove an entry between our fir=
st
> +        * search and this search we'll not find the key again and can ju=
st
> +        * bail.
> +        */
>         ret =3D btrfs_search_slot(NULL, root, &min_key, path, 0, 0);
> -       if (WARN_ON(ret !=3D 0))
> +       if (ret !=3D 0)
>                 goto done;
>
>         /*
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
