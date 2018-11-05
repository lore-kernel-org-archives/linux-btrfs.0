Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EEAC0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 11:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C6B420869
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 11:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W+/ChsMN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C6B420869
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbeKEUbW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 15:31:22 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:45375 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbeKEUbW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2018 15:31:22 -0500
Received: by mail-vk1-f194.google.com with SMTP id n126so1698149vke.12;
        Mon, 05 Nov 2018 03:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=ePfiqWNkVaTCFg3fhTmbKSLpWlIRHnltkojrNRgLV4g=;
        b=W+/ChsMNnUEPwj4xCByY1I1u+EqmF0N89gwhlqLi2eNOdqeiGlGVyeTI+KWoTcaH88
         zk/AvIXTeeWd6rS2x6UFyUyN5kQQcMjuaWEv3NW/YyZ4O21iIH11wreUDAJ4TSnzxhrf
         +Cb/WoxNe7OHLxcECVmrU1vHOIeA1lOnsmHbiUvse7h9mP2oIwPm8NZ8qWT7DJAytnYB
         9XyC+B85/brYJJmEOsZgXyBZwU4AyUQjRtodnpg8DZ+PUM5+ritkc7R3A11b8GMNR1oK
         xYJWC8dzHOHf2/QdaTpUooHvJW786u4EqHawvHw0xVuorY24PKFVEBa0QBMKk+i30Klc
         cZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=ePfiqWNkVaTCFg3fhTmbKSLpWlIRHnltkojrNRgLV4g=;
        b=ed/eUAJSJVf8dO1lMo3l5egTjTm1U46Swakk9SyL7c7kfF73LRz9N/79AeaXVnvzfD
         m58/3bjZnm3FFYdrtwmFubk1EpVUw7uJbGdwnNep5pT30DC1VCsJKbsEFojZs8rvBT5F
         NXV1GEOGQavmmuj+Qv72QfcssPaML5a26vQMpdn6066Hdsaj0zhAl1b9yq+e+gColuyJ
         7B8lH8k+MHm0UlpWXcFLsR6KBq6jxXrlIHimaxHiISnJiKfNR7cA/F7swJkyQh7CjqUL
         R70DwUuEVbXJJHm5qhL42eWd9fGIa5p282RgUtQfdVKr/z7OMtcA5D76T1Locup5SezB
         L+Gg==
X-Gm-Message-State: AGRZ1gKlUDyye7Pt3tZb0FI+Fg8p1e/YQyNqZ94T3hJV3LkiCIUb/pV/
        sZtI4dnFli0Kbpf0Z6CokMJP2/Bkt7LoR2sI/+sxAA==
X-Google-Smtp-Source: AJdET5fO68aWLT5gUTikRYeZ9SkFA8ifDmiOQ4i+jszNXqr8U/xf3M7mBHPi1aN2m86uhhoADqu9v5cr/hoMKZP7tuo=
X-Received: by 2002:a1f:5a01:: with SMTP id o1mr4171064vkb.4.1541416330197;
 Mon, 05 Nov 2018 03:12:10 -0800 (PST)
MIME-Version: 1.0
References: <1540882702-21104-1-git-send-email-robbieko@synology.com>
 <CAL3q7H4p_fa=5UhfBkSs3GU5EydKQ0J76D5RMShMY-2HQY3F+Q@mail.gmail.com> <d1c2ad795fa14784e4908fd3fa50617e@synology.com>
In-Reply-To: <d1c2ad795fa14784e4908fd3fa50617e@synology.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 5 Nov 2018 11:11:58 +0000
Message-ID: <CAL3q7H7AG7Nwj-v6scS6c9wxsKELRmLpYVOt1hkfK9Jr_sh1Cw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: incremental send, fix infinite loop when apply
 children dir moves
To:     Robbie Ko <robbieko@synology.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-btrfs-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 5, 2018 at 4:10 AM robbieko <robbieko@synology.com> wrote:
>
> Filipe Manana =E6=96=BC 2018-10-30 19:36 =E5=AF=AB=E5=88=B0:
> > On Tue, Oct 30, 2018 at 7:00 AM robbieko <robbieko@synology.com> wrote:
> >>
> >> From: Robbie Ko <robbieko@synology.com>
> >>
> >> In apply_children_dir_moves, we first create an empty list (stack),
> >> then we get an entry from pending_dir_moves and add it to the stack,
> >> but we didn't delete the entry from rb_tree.
> >>
> >> So, in add_pending_dir_move, we create a new entry and then use the
> >> parent_ino in the current rb_tree to find the corresponding entry,
> >> and if so, add the new entry to the corresponding list.
> >>
> >> However, the entry may have been added to the stack, causing new
> >> entries to be added to the stack as well.
> >>
> >> Finally, each time we take the first entry from the stack and start
> >> processing, it ends up with an infinite loop.
> >>
> >> Fix this problem by remove node from pending_dir_moves,
> >> avoid add new pending_dir_move to error list.
> >
> > I can't parse that explanation.
> > Can you give a concrete example (reproducer) or did this came out of
> > thin air?
> >
> > Thanks.
> >
>
> I am sorry that I replied so late.
>
> I have no way to give a simple example.
> But I can provide a btrfs image file
> You can restore the Image via btrfs-image
> Then directly command "btrfs send -e -p parent send -f dump_file"
> Infinite loop will occur.
> I use ubuntu 16.04, kernel 4.15.0.36-generic can be stable reproduce

You have been occasionally submitting fixes for send/receive for a few
years now, and you know already
that I always ask for a changelog that describes well the problem and
an example/reproducer.

Why did you do this?

What I can read from your answer is that you were too lazy to extract
a reproducer from that image.
Just made some change that fixes the infinite loop and because it
apparently works you're done with it,
Without an example at least, I don't think you or anyone can fully
understand the problem, and if what
you have (despite somewhat making theoretical sense) is really a good
solution or just a workaround for
the cause of the problem - after all if you can't give an example, you
can't explain how in practice such loop
of dependencies between directories happens. This, as with most
send/receive problems, is a pure sequential
and deterministic problem so there's really no excuse for not getting
a reproducer.

Without an example, an explanation how it happens in the real world,
does one know that your change is
fixing the problem is the right place and not introducing other
problems? Like the receiver not getting some
changes (missing directories, files, or renames, etc).

Tests are not just to prove a change is correct, they exist to catch
and prevent regressions in the future too.

You can do better than that.

>
> Image file, please refer to the attachment.
>
> Thanks.
>
>
> >>
> >> Signed-off-by: Robbie Ko <robbieko@synology.com>
> >> ---
> >>  fs/btrfs/send.c | 11 ++++++++---
> >>  1 file changed, 8 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> >> index 094cc144..5be83b5 100644
> >> --- a/fs/btrfs/send.c
> >> +++ b/fs/btrfs/send.c
> >> @@ -3340,7 +3340,8 @@ static void free_pending_move(struct send_ctx
> >> *sctx, struct pending_dir_move *m)
> >>         kfree(m);
> >>  }
> >>
> >> -static void tail_append_pending_moves(struct pending_dir_move *moves,
> >> +static void tail_append_pending_moves(struct send_ctx *sctx,
> >> +                                     struct pending_dir_move *moves,
> >>                                       struct list_head *stack)
> >>  {
> >>         if (list_empty(&moves->list)) {
> >> @@ -3351,6 +3352,10 @@ static void tail_append_pending_moves(struct
> >> pending_dir_move *moves,
> >>                 list_add_tail(&moves->list, stack);
> >>                 list_splice_tail(&list, stack);
> >>         }
> >> +       if (!RB_EMPTY_NODE(&moves->node)) {
> >> +               rb_erase(&moves->node, &sctx->pending_dir_moves);
> >> +               RB_CLEAR_NODE(&moves->node);
> >> +       }
> >>  }
> >>
> >>  static int apply_children_dir_moves(struct send_ctx *sctx)
> >> @@ -3365,7 +3370,7 @@ static int apply_children_dir_moves(struct
> >> send_ctx *sctx)
> >>                 return 0;
> >>
> >>         INIT_LIST_HEAD(&stack);
> >> -       tail_append_pending_moves(pm, &stack);
> >> +       tail_append_pending_moves(sctx, pm, &stack);
> >>
> >>         while (!list_empty(&stack)) {
> >>                 pm =3D list_first_entry(&stack, struct pending_dir_mov=
e,
> >> list);
> >> @@ -3376,7 +3381,7 @@ static int apply_children_dir_moves(struct
> >> send_ctx *sctx)
> >>                         goto out;
> >>                 pm =3D get_pending_dir_moves(sctx, parent_ino);
> >>                 if (pm)
> >> -                       tail_append_pending_moves(pm, &stack);
> >> +                       tail_append_pending_moves(sctx, pm, &stack);
> >>         }
> >>         return 0;
> >>
> >> --
> >> 1.9.1
> >>



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
