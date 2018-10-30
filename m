Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D17C2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 11:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D8922082B
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 11:37:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KFI111dF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D8922082B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbeJ3UaT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 16:30:19 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:32967 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbeJ3UaT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 16:30:19 -0400
Received: by mail-vk1-f196.google.com with SMTP id l186so2904511vke.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 04:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=7QCZNP9QxDv7ZtxwlD8BKfcV7oACRmE+wh7z+ysxWPg=;
        b=KFI111dFJhUhLVaZmRpl/UQPmW9Y7UURsq7b42H9ObgOrvWu4kgObh14EzAFMHZJ0Y
         2uPbCWITK6SOjqFv5bIxnyHLTG3SukN4G0oDfJiKnh7g6QC8j1R48F4K3W58LsBk58zY
         xFR9SRFnmtfv8qAJQsWLG7fLpzNg49n72Bt6PPL8AVc+dyxih38Bkzo5QraFb8hKk4xq
         av50JFvp5DSUkxwPSgi5u/ZrcW9d1532tZ00IJQwMz/617hy+OeTRi3XusHRlFOUzt1U
         e/VsJ/WKM0JyxgUFlhlDj+AHUl8Hfnpg+xl0nXhtqGeUccY6GWSRzytucglyuaR8znvM
         R6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=7QCZNP9QxDv7ZtxwlD8BKfcV7oACRmE+wh7z+ysxWPg=;
        b=QitVfQF3UXftrz7zBYG8eKGu0APxYidWVS6hwp7FgKkyWaJ1WLWrZeBOV5HPSyrVkJ
         w9/YM9ycG3v18FMu3D9kdyaSMpDwkZbeHcgVGaRl+8Q3W6/kAC9wfvXguz+C2EaJpwQV
         gsr2xyd8VzX+0ur3ii8QvK4JuCKcSaqzyQEqKLXvfeoMRfovSJO1XYXsZnHB9QlJNAeh
         MlEqZWXc9oTkrmwl0D4iSbklWSkvmkqCEhxcQ1CeF19TdwY8L00y36Zh8sgQ3+9ZnMY3
         dyiSnEslQvtS+hrZIsu5tY099k5UMVEHHlQEj0xpRkJAOq2Q0ILFrxNGRJNrsu5Ilwgs
         OC8w==
X-Gm-Message-State: AGRZ1gIq8JLjzTwNxsSI3esHgLP3i50xj+6zwC3oVlC5HgIxNQIivkOK
        4SaRbYETDVclTzrfrvk264mvyoB6+k/NkSXrp3X+vQ==
X-Google-Smtp-Source: AJdET5e1oWlpy8S79Ru6naNHLCkWeicbIjq7DEAgZpYig628lHffTIFtlhXtEadh7tS6rJuQkTxzpafgDgr/XLGAAoI=
X-Received: by 2002:a1f:234a:: with SMTP id j71-v6mr7642386vkj.81.1540899430783;
 Tue, 30 Oct 2018 04:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <1540882702-21104-1-git-send-email-robbieko@synology.com>
In-Reply-To: <1540882702-21104-1-git-send-email-robbieko@synology.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 30 Oct 2018 11:36:59 +0000
Message-ID: <CAL3q7H4p_fa=5UhfBkSs3GU5EydKQ0J76D5RMShMY-2HQY3F+Q@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: incremental send, fix infinite loop when apply
 children dir moves
To:     Robbie Ko <robbieko@synology.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 30, 2018 at 7:00 AM robbieko <robbieko@synology.com> wrote:
>
> From: Robbie Ko <robbieko@synology.com>
>
> In apply_children_dir_moves, we first create an empty list (stack),
> then we get an entry from pending_dir_moves and add it to the stack,
> but we didn't delete the entry from rb_tree.
>
> So, in add_pending_dir_move, we create a new entry and then use the
> parent_ino in the current rb_tree to find the corresponding entry,
> and if so, add the new entry to the corresponding list.
>
> However, the entry may have been added to the stack, causing new
> entries to be added to the stack as well.
>
> Finally, each time we take the first entry from the stack and start
> processing, it ends up with an infinite loop.
>
> Fix this problem by remove node from pending_dir_moves,
> avoid add new pending_dir_move to error list.

I can't parse that explanation.
Can you give a concrete example (reproducer) or did this came out of thin a=
ir?

Thanks.

>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/send.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 094cc144..5be83b5 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3340,7 +3340,8 @@ static void free_pending_move(struct send_ctx *sctx=
, struct pending_dir_move *m)
>         kfree(m);
>  }
>
> -static void tail_append_pending_moves(struct pending_dir_move *moves,
> +static void tail_append_pending_moves(struct send_ctx *sctx,
> +                                     struct pending_dir_move *moves,
>                                       struct list_head *stack)
>  {
>         if (list_empty(&moves->list)) {
> @@ -3351,6 +3352,10 @@ static void tail_append_pending_moves(struct pendi=
ng_dir_move *moves,
>                 list_add_tail(&moves->list, stack);
>                 list_splice_tail(&list, stack);
>         }
> +       if (!RB_EMPTY_NODE(&moves->node)) {
> +               rb_erase(&moves->node, &sctx->pending_dir_moves);
> +               RB_CLEAR_NODE(&moves->node);
> +       }
>  }
>
>  static int apply_children_dir_moves(struct send_ctx *sctx)
> @@ -3365,7 +3370,7 @@ static int apply_children_dir_moves(struct send_ctx=
 *sctx)
>                 return 0;
>
>         INIT_LIST_HEAD(&stack);
> -       tail_append_pending_moves(pm, &stack);
> +       tail_append_pending_moves(sctx, pm, &stack);
>
>         while (!list_empty(&stack)) {
>                 pm =3D list_first_entry(&stack, struct pending_dir_move, =
list);
> @@ -3376,7 +3381,7 @@ static int apply_children_dir_moves(struct send_ctx=
 *sctx)
>                         goto out;
>                 pm =3D get_pending_dir_moves(sctx, parent_ino);
>                 if (pm)
> -                       tail_append_pending_moves(pm, &stack);
> +                       tail_append_pending_moves(sctx, pm, &stack);
>         }
>         return 0;
>
> --
> 1.9.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
