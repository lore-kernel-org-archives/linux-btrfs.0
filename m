Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016AAC677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 20:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA26620644
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 20:36:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TDoo3Fyh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA26620644
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbeJLEFY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 00:05:24 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:39995 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbeJLEFY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 00:05:24 -0400
Received: by mail-vs1-f66.google.com with SMTP id z130-v6so9879050vsc.7
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 13:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=NY7+FCsh7jtR3vWsxpTFn5v123ULd4qoLLkUBGAQymY=;
        b=TDoo3FyhrhcDZDFlPwWyfGRhn4QLXkb0RVKyKgh7tH8c3/oVtQ+t9Ah+k+fOAHUguH
         nteVodA2H4exlri5KjH+y1NyhkmXrKe6aqZVUtzWc1ERL3pB0/T56aLXYR1IzWBsecW/
         1E5RM5yalrp9WrK+xQ9ngs4O99Ex3zM5qTaicjbIdkuMil9LjsOgtXCLPn5YqvOGXot+
         iYdcSsd/xKmobveyWyTiBmRcge1dVfjFs2oTx6W0Y1XWoYGfd5nKvuTHiAwAyBvav/p3
         4Nkx+ITGwBOjmN8Y1S2ar8h6dyPssZUuE8eIEvSOXgNb2pzfG7mcFch6bz/S6xv7Qz9V
         E7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=NY7+FCsh7jtR3vWsxpTFn5v123ULd4qoLLkUBGAQymY=;
        b=W9mdNQXayggZ1nafzhzFz2ifPLzxDl+Hz7hiPHrCQP2KJULKt8iJZRDu95+o61OPUe
         0ffoDRJ2GyyM+Km4NVWyD6YCQEmqY2M3kDBdu8GJzr35ShzEC6D5FSbxOfiA/4V+3YKw
         n9EsCjziwZMk9ApCtmo1OGoVCfBDTxEDypulQ8WFmSqsVvBN7YcqhAnmqicZLYABLmTj
         Yukmr3wM5/AXxhaO4VRVV7arVRp+OP5gqX674lVfwtQSQUc7niLqQroR+P67zWp8cR3A
         hs7wPJ6LnM8JY3iOyXzW6JSNu83ekVtvZysDZyX1GqpnzE1rBTdaeiW8nR7wR81bTVZN
         wFCQ==
X-Gm-Message-State: ABuFfogFiN7D9ApLXKbccOqPTjt113G3NAy8/1bjJAwb6ZAgyS7xD6gX
        AH1/Qm2EAV/Uk2UUy6h9dH+31avS2RoXFqHvOHVkS6fZ
X-Google-Smtp-Source: ACcGV623DsODujXKMebK4PmvPhiuv15Ai+9o+EbVY2TqH522I4OnpHN8fvx8W8VVCfZ4pBVF3MnnwBFTQCJhobxStuc=
X-Received: by 2002:a67:4482:: with SMTP id y2mr1317555vsf.90.1539290188913;
 Thu, 11 Oct 2018 13:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <20181011195431.3441-1-josef@toxicpanda.com> <20181011195431.3441-43-josef@toxicpanda.com>
In-Reply-To: <20181011195431.3441-43-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 11 Oct 2018 21:36:17 +0100
Message-ID: <CAL3q7H5s+nVkay9-9BYJuQiKoGR-ayp-EzZEUSWGqCt7sDX9uA@mail.gmail.com>
Subject: Re: [PATCH 42/42] btrfs: don't run delayed_iputs in commit
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 8:58 PM Josef Bacik <josef@toxicpanda.com> wrote:
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

Great catch!

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
