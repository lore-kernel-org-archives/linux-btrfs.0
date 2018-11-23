Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1241CC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 16:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC9C620824
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 16:59:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pnmc3aT/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC9C620824
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440698AbeKXDor (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 22:44:47 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:45335 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391367AbeKXDor (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 22:44:47 -0500
Received: by mail-ua1-f65.google.com with SMTP id e16so4282376uam.12
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Nov 2018 08:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=Zo0g6ltEAh+g7i4+nZqlUKbwaBewMVJctlIHRxefqio=;
        b=Pnmc3aT/68PHCCQ7MLikrhOKj7KFJYZttjjKqx0FlVC65Gwbbk4K3otcjAFtjoDmrh
         noRWEW/+luIF6tcBzZY7drzwn2dSoulPlpIEP0V8aSTYuSR6MyhpWWMP10bOYX8idG1n
         8k0KoW73EgnaoDRKZWJ+A39RKE46wi5kAcwVltzd5JgxhwX+TlNsOr7BHmxmOazJnbPu
         z6Jx99LOEfNy8t+s/1pjstX3ifYV9jD0Fr8hTtC43dQLyrog4zymbWP580VwAsVkBiI6
         wvtzFhR4mbobP4/6Ktx70JjJvRWRrGZvg+QmK/5m1DdUNPpHLa1hGhGWApWjUDoFt5tN
         Omrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=Zo0g6ltEAh+g7i4+nZqlUKbwaBewMVJctlIHRxefqio=;
        b=fw3NNzZJx532BcHzK2+XYV7d8VJSN18+qL+hmFqJgYN+jpsKyrFiqGiN03AgCwGcPJ
         B7kn4r+XCqXyNiiSEALwmTq8R96ZluSd5jw8phyQOpXd6/pJN6TUgmwoamU/6FFhRE4H
         4Mx+cHJELBG3LZOeykbFA+QM8R3aPMIOIaB4RoYh1IRfGiBdHETtuj3pdS/57yQJ4zDH
         bEC5Xpf6hCr1MiKAEpka/Omaj098JY2efSXUCtSqeBhLD4eGYG3lQKiN7SAGvYKcaAei
         09weH0UMg8BhLOTKeuW2O41NyS4PFHjZtqiBIbtkXQEu9wEpjVzJRA0Wwo0VXW6d33Pl
         U5rQ==
X-Gm-Message-State: AA+aEWYYKCClKvWjm+t5kobFen3PF2jEILxDgeoiW7PEsTc0s2JKNEPb
        h4ks8iGTShaAFWN9YJXkw8GM7DGwfLpmee/JNAQ=
X-Google-Smtp-Source: AFSGD/XL7x9GvDJ+uvDTYzNAg9kGGqgba/0BJ3zGS+GKKO1wXncrQ9hyJ2wla7PpLVM+cf1rzXvz5+llVJPjxn2OJi0=
X-Received: by 2002:ab0:5b9b:: with SMTP id y27mr7242760uae.30.1542992384206;
 Fri, 23 Nov 2018 08:59:44 -0800 (PST)
MIME-Version: 1.0
References: <20181121191016.25224-1-josef@toxicpanda.com>
In-Reply-To: <20181121191016.25224-1-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 23 Nov 2018 16:59:32 +0000
Message-ID: <CAL3q7H45FX3VO0h_9u5-M38ObiWaZPgyXezUDT-4rJvx7BUkhw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: only run delayed refs if we're committing
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 12:35 AM Josef Bacik <josef@toxicpanda.com> wrote:
>
> I noticed in a giant dbench run that we spent a lot of time on lock
> contention while running transaction commit.  This is because dbench
> results in a lot of fsync()'s that do a btrfs_transaction_commit(), and
> they all run the delayed refs first thing, so they all contend with
> each other.  This leads to seconds of 0 throughput.  Change this to only
> run the delayed refs if we're the ones committing the transaction.  This
> makes the latency go away and we get no more lock contention.

Can you share the following in the changelog please?

1) How did you ran dbench (parameters, config).

2) What results did you get before and after this change. So that we all ge=
t
    an idea of how good the impact is.

While the reduced contention makes all sense and seems valid, I'm not
sure this is always a win.
It certainly is when multiple tasks are calling
btrfs_commit_transaction() simultaneously, but,
what about when only one does it?

By running all delayed references inside the critical section of the
transaction commit
(state =3D=3D TRANS_STATE_COMMIT_START), instead of running most of them
outside/before,
we will be blocking for a longer a time other tasks calling
btrfs_start_transaction() (which is used
a lot - creating files, unlinking files, adding links, etc, and even fsync)=
.

Won't there by any other types of workload and tests other then dbench
that can get increased
latency and/or smaller throughput?

I find that sort of information useful to have in the changelog. If
you verified that or you think
it's irrelevant to measure/consider, it would be great to have it
mentioned in the changelog
(and explained).

Thanks.

>
> Reviewed-by: Omar Sandoval <osandov@fb.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/transaction.c | 24 +++++++++---------------
>  1 file changed, 9 insertions(+), 15 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 3c1be9db897c..41cc96cc59a3 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1918,15 +1918,6 @@ int btrfs_commit_transaction(struct btrfs_trans_ha=
ndle *trans)
>         btrfs_trans_release_metadata(trans);
>         trans->block_rsv =3D NULL;
>
> -       /* make a pass through all the delayed refs we have so far
> -        * any runnings procs may add more while we are here
> -        */
> -       ret =3D btrfs_run_delayed_refs(trans, 0);
> -       if (ret) {
> -               btrfs_end_transaction(trans);
> -               return ret;
> -       }
> -
>         cur_trans =3D trans->transaction;
>
>         /*
> @@ -1938,12 +1929,6 @@ int btrfs_commit_transaction(struct btrfs_trans_ha=
ndle *trans)
>
>         btrfs_create_pending_block_groups(trans);
>
> -       ret =3D btrfs_run_delayed_refs(trans, 0);
> -       if (ret) {
> -               btrfs_end_transaction(trans);
> -               return ret;
> -       }
> -
>         if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
>                 int run_it =3D 0;
>
> @@ -2014,6 +1999,15 @@ int btrfs_commit_transaction(struct btrfs_trans_ha=
ndle *trans)
>                 spin_unlock(&fs_info->trans_lock);
>         }
>
> +       /*
> +        * We are now the only one in the commit area, we can run delayed=
 refs
> +        * without hitting a bunch of lock contention from a lot of peopl=
e
> +        * trying to commit the transaction at once.
> +        */
> +       ret =3D btrfs_run_delayed_refs(trans, 0);
> +       if (ret)
> +               goto cleanup_transaction;
> +
>         extwriter_counter_dec(cur_trans, trans->type);
>
>         ret =3D btrfs_start_delalloc_flush(fs_info);
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
