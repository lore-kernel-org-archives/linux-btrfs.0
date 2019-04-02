Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4604C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 19:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5B522082C
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 19:19:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WJ34s1V0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbfDBTTp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 15:19:45 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:46112 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfDBTTp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 15:19:45 -0400
Received: by mail-vk1-f196.google.com with SMTP id x2so3236141vkx.13
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2019 12:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=8LlsvWXU2csKzKWBTwtfbBpg7C+eQ4E8kEBvQexB49k=;
        b=WJ34s1V0NguYBqzFMU13Cf7imoA2IZI3WnCnQ1qmimkw8m80Uh2tXIT+ib5trvSFsD
         8qCu6RH3iesFmujGMKjHWPJ+UFVsQ+ieywP0nGJjNjZK4ZJH98yy794kYMlxazddr7LG
         4kx4/3n8O1bMGJFt+18AEmF8XtKAAO7/malddkZx4hy27oI7xh/z/LOJKPFssHL2sxGy
         NtzLvKs88JZ6cEnQWXaIDXC5uvQEjo7K1662ZD9N7//pn4zeRgWrpZe+AdMsSWsCKBt2
         ID6as9QZ4ZfuCeFx3Z3IjDYdHOwCs2wnV8ZHgpZ32BwEqcZMe5yc5Pr/UhKwudrPdTKZ
         WCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=8LlsvWXU2csKzKWBTwtfbBpg7C+eQ4E8kEBvQexB49k=;
        b=NNTiyQsHrIrFULjoDWekzPowslts8zbPeGLvtIgaCggB1qRmDxFN+KCz587v39dVrd
         ER4i76agigikDmE/GDEftiRFMNHU0JJQZpk1NyHBCVKsyWOEJkKIjYAsrhtxJCTQ/FUp
         d9dHYqqe4n1NtbV2Srcwl+4i4YvjkRkyhhfK7W/xP1cML/0FH/Vd/aGkCAOH7pqYKjbW
         l5DHngnTyhX5bbUbH6TkxbX76b8wwMFm6D7sx6f8N9LTRlfrqaUP24Nc1C51/2j6qKV7
         mebq4u+o0uhLq3UA6aJ18//2eNJ7VK5+PmDFOFktwPmaTCv+oXKEXKFcByeqGc0dXw/A
         IbOA==
X-Gm-Message-State: APjAAAVMPiKMa3Ivkfjp//E+c0aBhHxilRCW8mew1OFkKlg0F2fgP/p/
        CXmtGvBmsRLHlwzHKmxiZXUUs5lFi0TkIVEymKOfvrVJ
X-Google-Smtp-Source: APXvYqy807eyoiXjNktV8ZE1WKienol5dOLEWw5rj88qQa4AmylF//DjUAR6Z3HJRS2KfaW+j1A2nYi2fZ+yDzX/8WY=
X-Received: by 2002:a1f:4f44:: with SMTP id d65mr41802830vkb.58.1554232784064;
 Tue, 02 Apr 2019 12:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190402180956.28893-1-jeffm@suse.com>
In-Reply-To: <20190402180956.28893-1-jeffm@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 2 Apr 2019 19:19:32 +0000
Message-ID: <CAL3q7H7O=ZqJdQUXYZjJRfZF04Or7kLgEVnRUGE97YRsV=3pMg@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs-progs: check: run delayed refs after writing
 out dirty block groups
To:     Jeff Mahoney <jeffm@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 2, 2019 at 7:29 PM <jeffm@suse.com> wrote:
>
> From: Jeff Mahoney <jeffm@suse.com>
>
> When repairing the extent tree, it's possible for delayed extents to
> be created when running btrfs_write_dirty_block_groups.  We run
> delayed refs one last time in the kernel but that is missing in
> the userspace tools.
>
> That results in delayed refs getting dropped on the floor, the extent
> records not getting created, and in the next tranaction, when the
> extent tree is CoW'd again, we hit the BUG_ON when we can't find
> the extent record.
>
> We can fix this by running the delayed refs after writing out the
> dirty block groups.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  transaction.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/transaction.c b/transaction.c
> index e756db33..2f19e9c8 100644
> --- a/transaction.c
> +++ b/transaction.c
> @@ -194,6 +194,8 @@ commit_tree:
>         ret =3D btrfs_run_delayed_refs(trans, -1);
>         BUG_ON(ret);
>         btrfs_write_dirty_block_groups(trans);
> +       ret =3D btrfs_run_delayed_refs(trans, -1);
> +       BUG_ON(ret);

And running delayed refs can dirty more block groups as well.
At this point shouldn't we loop running delayed refs until no more
dirty block groups exist? Just like in the kernel.

thanks

>         __commit_transaction(trans, root);
>         if (ret < 0)
>                 goto out;
> --
> 2.16.4
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
