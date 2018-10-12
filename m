Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA6EC71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 20:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AE87204EC
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 20:45:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bAd0YrP4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AE87204EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbeJMETx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 00:19:53 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:33682 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbeJMETx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 00:19:53 -0400
Received: by mail-vk1-f194.google.com with SMTP id l186so2680105vke.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 13:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=c0wZiI8WrehMMgKaDrkE3XoV5k7IcWJMyDsDqVjEA8I=;
        b=bAd0YrP4Km+Vfgn6Co0vEh3rdt8kU05irHX2Q6mI1rf4utvhG8f0rXT51uoZSyc095
         fQUanem/adVgZKyu7QvVXZmBYF4XqRsDogBzUPnUOeZEFAXj9JPIAQ1zZPUINbpb6Gkb
         OFcff7ipHJYh086QAHcBmLfo3OA0K6F+pmPyy8WCBK/Ke7VIX3eu/iRf+e2EORMXTCM1
         /X0qZjz0ot1dW8uYTW75JxKGwRnDMMCx2/iIVjydFHfg0+hszcBiPsgedZDr6ezt4up8
         utQ3TnxQxL7Nb48rSZQ+cHIiidhdhy0EX6qOpNaixtx3A6t887Gvm8OwI+RV/2DgswWP
         hSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=c0wZiI8WrehMMgKaDrkE3XoV5k7IcWJMyDsDqVjEA8I=;
        b=hZ9RvR1wNn1g4/Kps+aQlCuTM+/XJ4xobfh8RFjwUO8x4fCvlE5Fuk9/02Ab84Nrhm
         XJAnRWjjutQCAPjn68+LSeJ9x3/6aw4Wss/aE3P9nMEUy3ggZz3QA2I5wL5d18mK+jcC
         VSRqzhiG+6KZ4h0vwj858gIC439kQ5tbOMig678o5mMigZaByEJoc5+0sgn8OqbX87RD
         asKw97t5BA9LD8k1+wx4lrXbKu+azfF5IPcBtmMjojaDursBcuYIUTuF0GDArB4QHgJU
         6qAuWPIhbeSWNROuVKlQcB99U6Dr12mwt8X8vNBerv5fyZ43AfmjODy/I8SojyuRdrEa
         WNuA==
X-Gm-Message-State: ABuFfogOYSu8/RQrwTAW+ax7mN6lhnEGNQ9zh1Clv0yurJie2tkKlIpo
        ZJlLjwNZSDZd3iVqsto1dcLwuS+MiTwgoZavvvq1hQ==
X-Google-Smtp-Source: ACcGV62uXz3TX1Qsr0qi2E0PSe4P8G9yAeIXF9QtiMzIssE3w7LYsA1M+sLBbSZX7CYQUWv76PbC0/cdLdOuijW+Jq4=
X-Received: by 2002:a1f:b995:: with SMTP id j143-v6mr3170757vkf.88.1539377136539;
 Fri, 12 Oct 2018 13:45:36 -0700 (PDT)
MIME-Version: 1.0
References: <20181012193256.13735-1-josef@toxicpanda.com> <20181012193256.13735-43-josef@toxicpanda.com>
In-Reply-To: <20181012193256.13735-43-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 12 Oct 2018 21:45:25 +0100
Message-ID: <CAL3q7H7sTLnjtbDG_chSomXowGS5MAekXjOgPrp70uSei5Vf6Q@mail.gmail.com>
Subject: Re: [PATCH 42/42] btrfs: don't run delayed_iputs in commit
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 8:35 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> This could result in a really bad case where we do something like
>
> evict
>   evict_refill_and_join
>     btrfs_commit_transaction
>       btrfs_run_delayed_iputs
>         evict
>           evict_refill_and_join
>             btrfs_commit_transaction
> ... forever
>
> We have plenty of other places where we run delayed iputs that are much
> safer, let those do the work.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/transaction.c | 9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 9168efaca37e..c91dc36fccae 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2265,15 +2265,6 @@ int btrfs_commit_transaction(struct btrfs_trans_ha=
ndle *trans)
>
>         kmem_cache_free(btrfs_trans_handle_cachep, trans);
>
> -       /*
> -        * If fs has been frozen, we can not handle delayed iputs, otherw=
ise
> -        * it'll result in deadlock about SB_FREEZE_FS.
> -        */
> -       if (current !=3D fs_info->transaction_kthread &&
> -           current !=3D fs_info->cleaner_kthread &&
> -           !test_bit(BTRFS_FS_FROZEN, &fs_info->flags))
> -               btrfs_run_delayed_iputs(fs_info);
> -
>         return ret;
>
>  scrub_continue:
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
