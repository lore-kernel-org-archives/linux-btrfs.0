Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D79C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 10:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AF9E20827
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 10:18:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T/rKKlln"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AF9E20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727596AbeKIT6J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 14:58:09 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:32863 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbeKIT6J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Nov 2018 14:58:09 -0500
Received: by mail-vs1-f67.google.com with SMTP id p74so735756vsc.0;
        Fri, 09 Nov 2018 02:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=MyJTLHCuk3nRKx5M9PhBYsYanvOfqytXTOCWn4cNv30=;
        b=T/rKKllnQHs0PegmUmaPsMixjEFaCpYy74eHHsGJ3gwwPyvH3LivrF+tvDDhq7YI2a
         fcN/uldnT2+0YV3BDpF7z65IodklwBpJ1En/yxeqHIDvjpuJL/l2qnJYR3UE+opPBHL2
         GVuiVBSHgTWLNoQfDR+4I9bdBlANnZlu3BNOi66eOuQkOeXNScXJSZFDNaDRUKJ2TX1S
         3Mtlh86g8nO0R0gOTUdJG04RG/BDyhduTULKaZigo7ajGZti249NFR4wa5gQhC0RTjNB
         vUmy8A91hpG+j/+ZHRK7EaBbht2Tknf0kF3kBdgiEO1vBPrDuw+QijunOI42LZaprvKK
         /lPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=MyJTLHCuk3nRKx5M9PhBYsYanvOfqytXTOCWn4cNv30=;
        b=eUF/SKDMe1x2HQVp/XjErLCRGHmcdbhb/Tih/jnKVQrDJqBWzX02/qBDzsoDu+0LBv
         U8FPnmPenOH414xytDPm5zZV0HZuMcDTUJ3sw9RfgMiJUkAVn4Jo8b3sMoDpB8GlbwW3
         AtslgPOUM+ZuaI7YEkG8B/o/ZIlpD1pYepMU8R4TiwmtokXDQT17zJgYA2QOidwfOC61
         ZXue0b5xyi8CC8gEXINPX05XrRj7WuGa1NBWfvBRfBzNsAUK85XSjMGBrgTwKcfGqxCA
         XrSQ7cyqXrSbpD4UX/Tpl5FrXNN3Hlg7dxrgA4RE7dhPqRDcpVwArQ1vK7JFqPoNdxwb
         nsaw==
X-Gm-Message-State: AGRZ1gLY4nfM5oJPq/SHKIqDOgkNgHs1+5l4qDvZTt5YyHPlNzzLA/Gv
        L0sePAuKpb38fxjV7LOoOEQkm/yV/avp1zbOYpPEWQ==
X-Google-Smtp-Source: AJdET5dJnE7FAFoTORbUDVs+Ui8yYWaOSlTYzNUOC2gDbe3FjXQaRhI0pCQzOWwgVIHCZ0z7prdXJxKWzRlteDPc2Hk=
X-Received: by 2002:a67:3b1b:: with SMTP id i27mr3514382vsa.14.1541758691983;
 Fri, 09 Nov 2018 02:18:11 -0800 (PST)
MIME-Version: 1.0
References: <1540882702-21104-1-git-send-email-robbieko@synology.com>
 <CAL3q7H4p_fa=5UhfBkSs3GU5EydKQ0J76D5RMShMY-2HQY3F+Q@mail.gmail.com>
 <d1c2ad795fa14784e4908fd3fa50617e@synology.com> <CAL3q7H7AG7Nwj-v6scS6c9wxsKELRmLpYVOt1hkfK9Jr_sh1Cw@mail.gmail.com>
 <a79f2503-04ea-ed85-7c95-2033dd37ae01@gmx.com> <a7d63a869c4c7c481d55414f94155103@synology.com>
 <36b3de36f7bf70b295438b2e3e33603c@synology.com>
In-Reply-To: <36b3de36f7bf70b295438b2e3e33603c@synology.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 9 Nov 2018 10:18:00 +0000
Message-ID: <CAL3q7H4nESnSqn-OgL=_J8khtqdpzOETwqoa5twXbds4o83L-w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: incremental send, fix infinite loop when apply
 children dir moves
To:     Robbie Ko <robbieko@synology.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-btrfs-owner@vger.kernel.org,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 9, 2018 at 1:21 AM robbieko <robbieko@synology.com> wrote:
>
> robbieko =E6=96=BC 2018-11-06 20:23 =E5=AF=AB=E5=88=B0:
> > Hi,
> >
> > I can reproduce the infinite loop, the following will describe the
> > reason and example.
> >
> > Example:
> > tree --inodes parent/ send/
> > parent/
> > `-- [    261]  261
> >     `-- [    271]  271
> >         `-- [    266]  266
> >             |-- [    259]  259
> >             |-- [    260]  260
> >             |   `-- [    267]  267
> >             |-- [    264]  264
> >             |   `-- [    258]  258
> >             |       `-- [    257]  257
> >             |-- [    265]  265
> >             |-- [    268]  268
> >             |-- [    269]  269
> >             |   `-- [    262]  262
> >             |-- [    270]  270
> >             |-- [    272]  272
> >             |   |-- [    263]  263
> >             |   `-- [    275]  275
> >             `-- [    274]  274
> >                 `-- [    273]  273
> > send/
> > `-- [    275]  275
> >     `-- [    274]  274
> >         `-- [    273]  273
> >             `-- [    262]  262
> >                 `-- [    269]  269
> >                     `-- [    258]  258
> >                         `-- [    271]  271
> >                             `-- [    268]  268
> >                                 `-- [    267]  267
> >                                     `-- [    270]  270
> >                                         |-- [    259]  259
> >                                         |   `-- [    265]  265
> >                                         `-- [    272]  272
> >                                             `-- [    257]  257
> >                                                 |-- [    260]  260
> >                                                 `-- [    264]  264
> >                                                     `-- [    263]  263
> >                                                         `-- [    261]
> > 261
> >                                                             `-- [
> > 266]  266
> >
> >
> > 1. While process inode 257, we delay its rename operation because inode
> > 272
> > has not been renamed (since 272 > 257, that is, beyond the current
> > progress).
> >
> > 2. And so on (inode 258-274), we can get a bunch of waiting waiting
> > relationships
> > 257 -> (wait for) 272
> > 258 -> 269
> > 259 -> 270
> > 260 -> 272
> > 261 -> 263
> > 262 -> 274
> > 263 -> 264
> > 264 -> 257
> > 265 -> 270
> > 266 -> 263
> > 267 -> 268
> > 268 -> 271
> > 269 -> 262
> > 270 -> 271
> > 271 -> 258
> > 272 -> 274
> > 274 -> 275
> >
> > 3. While processing inode 275, we rename ./261/271/272/275 to ./275,
> > and then now we start processing the waiting subdirectories in
> > apply_children_dir_moves.
> >
> > 4. We first initialize the stack into an empty list, and then we add
> > 274 to the stack
> > because 274 is waiting for 275 to complete.
> >     Every time we take the first object in the stack to process it.
> >
> > 5. So we can observe the change in object in the stack.
> > loop:
> >  round 1. 274
> >             2. 262 -> 272
> >             3. 272 -> 269
> >             4. 269 -> 257 -> 260
> >             5. 257 -> 260 -> 258
> >             6. 260 -> 258 -> 264
> >             7. 258 -> 264
> >             8. 264 -> 271
> >             9. 271 -> 263
> >           10. 263 -> 268 -> 270
> >           11. 268 -> 270 -> 261 -> 266
> >           12. 270 -> 261 -> 266 -> 267
> >           13. 261 -> 266 -> 267 -> 259 -> 265 (since 270 path loop, so
> > we add 270 waiting for 267)
> >           14. 266 -> 267 -> 259 -> 265
> >           15. 267 -> 266 -> 259 -> 265  (since 266 path loop, so we
> > add 266 waiting for 270, but we don't add to stack)
> >           16. 266 -> 259 -> 265 -> 270
> >           17. 266 -> 259 -> 265 -> 270  (since 266 path loop, so we
> > add 266 waiting for 270, but we don't add to stack)
> >           18. 266 -> 259 -> 265 -> 270  (since 266 path loop, so we
> > add 266 waiting for 270, but we don't add to stack)
> >           19. 266 -> 259 -> 265 -> 270  (since 266 path loop, so we
> > add 266 waiting for 270, but we don't add to stack)
> >            ... infinite loop
> >
> > 6. In round 13, we processing 270, we delayed the rename because 270
> > has a path loop with 267,
> > and then we add 259, 265 to the stack, but we don't remove from
> > pending_dir_moves rb_tree.
> >
> > 7. In round 15, we processing 266, we delayed the rename because 266
> > has a path loop with 270,
> > So we look for parent_ino equal to 270 from pending_dir_moves, and we
> > find ino 259
> > because it was not removed from pending_dir_moves.
> > Then we create a new pending_dir and join the ino 259, because the ino
> > 259 is currently in the stack,
> > the new pending_dir ino 266 is also indirectly added to the stack,
> > placed between 267 and 259.
> >
> > So we fix this problem by remove node from pending_dir_moves,
> > avoid add new pending_dir_move to stack list.
> >
>
> Does anyone have any suggestions ?

A better changelog. But for that I'll have to go through it and
understand what's happening (and see if this is the right way to fix
it). Will probably do it next week.

> Later, I will submit the case in xfstest.
>
>
> > Qu Wenruo =E6=96=BC 2018-11-05 22:35 =E5=AF=AB=E5=88=B0:
> >> On 2018/11/5 =E4=B8=8B=E5=8D=887:11, Filipe Manana wrote:
> >>> On Mon, Nov 5, 2018 at 4:10 AM robbieko <robbieko@synology.com>
> >>> wrote:
> >>>>
> >>>> Filipe Manana =E6=96=BC 2018-10-30 19:36 =E5=AF=AB=E5=88=B0:
> >>>>> On Tue, Oct 30, 2018 at 7:00 AM robbieko <robbieko@synology.com>
> >>>>> wrote:
> >>>>>>
> >>>>>> From: Robbie Ko <robbieko@synology.com>
> >>>>>>
> >>>>>> In apply_children_dir_moves, we first create an empty list
> >>>>>> (stack),
> >>>>>> then we get an entry from pending_dir_moves and add it to the
> >>>>>> stack,
> >>>>>> but we didn't delete the entry from rb_tree.
> >>>>>>
> >>>>>> So, in add_pending_dir_move, we create a new entry and then use
> >>>>>> the
> >>>>>> parent_ino in the current rb_tree to find the corresponding entry,
> >>>>>> and if so, add the new entry to the corresponding list.
> >>>>>>
> >>>>>> However, the entry may have been added to the stack, causing new
> >>>>>> entries to be added to the stack as well.
> >>
> >> I'm not a send guy, so I can totally be wrong, but that 'may' word
> >> seems
> >> to hide the demon.
> >>
> >>>>>>
> >>>>>> Finally, each time we take the first entry from the stack and
> >>>>>> start
> >>>>>> processing, it ends up with an infinite loop.
> >>>>>>
> >>>>>> Fix this problem by remove node from pending_dir_moves,
> >>>>>> avoid add new pending_dir_move to error list.
> >>>>>
> >>>>> I can't parse that explanation.
> >>>>> Can you give a concrete example (reproducer) or did this came out
> >>>>> of
> >>>>> thin air?
> >>>>>
> >>>>> Thanks.
> >>>>>
> >>>>
> >>>> I am sorry that I replied so late.
> >>>>
> >>>> I have no way to give a simple example.
> >>>> But I can provide a btrfs image file
> >>>> You can restore the Image via btrfs-image
> >>>> Then directly command "btrfs send -e -p parent send -f dump_file"
> >>
> >> According to the name, it doesn't look like a real world case, but
> >> some
> >> more or less manually crafted image.
> >> It shouldn't be that hard to describe the root cause in details if
> >> it's
> >> crafted.
> >>
> >> Or, if it's a image caused by some stress test, then I really hope you
> >> could locate the direct and root cause, or at least minimize the
> >> image.
> >> The extra noise will really take a lot of time from reviewer.
> >>
> >> IMHO, it shouldn't be that hard to locate the key/key range that send
> >> loops, with that located it should provide some clue to further pin
> >> down
> >> the root cause.
> >>
> >> I totally understand that everyone has their own work, if you can't
> >> really spare time for this, would you please upload the image to
> >> public
> >> for anyone (me for example) to look into the case?
> >>
> >> Thanks,
> >> Qu
> >>
> >>>> Infinite loop will occur.
> >>>> I use ubuntu 16.04, kernel 4.15.0.36-generic can be stable reproduce
> >>>
> >>> You have been occasionally submitting fixes for send/receive for a
> >>> few
> >>> years now, and you know already
> >>> that I always ask for a changelog that describes well the problem and
> >>> an example/reproducer.
> >>>
> >>> Why did you do this?
> >>>
> >>> What I can read from your answer is that you were too lazy to extract
> >>> a reproducer from that image.
> >>> Just made some change that fixes the infinite loop and because it
> >>> apparently works you're done with it,
> >>> Without an example at least, I don't think you or anyone can fully
> >>> understand the problem, and if what
> >>> you have (despite somewhat making theoretical sense) is really a good
> >>> solution or just a workaround for
> >>> the cause of the problem - after all if you can't give an example,
> >>> you
> >>> can't explain how in practice such loop
> >>> of dependencies between directories happens. This, as with most
> >>> send/receive problems, is a pure sequential
> >>> and deterministic problem so there's really no excuse for not getting
> >>> a reproducer.
> >>>
> >>> Without an example, an explanation how it happens in the real world,
> >>> does one know that your change is
> >>> fixing the problem is the right place and not introducing other
> >>> problems? Like the receiver not getting some
> >>> changes (missing directories, files, or renames, etc).
> >>>
> >>> Tests are not just to prove a change is correct, they exist to catch
> >>> and prevent regressions in the future too.
> >>>
> >>> You can do better than that.
> >>>
> >>>>
> >>>> Image file, please refer to the attachment.
> >>>>
> >>>> Thanks.
> >>>>
> >>>>
> >>>>>>
> >>>>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
> >>>>>> ---
> >>>>>>  fs/btrfs/send.c | 11 ++++++++---
> >>>>>>  1 file changed, 8 insertions(+), 3 deletions(-)
> >>>>>>
> >>>>>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> >>>>>> index 094cc144..5be83b5 100644
> >>>>>> --- a/fs/btrfs/send.c
> >>>>>> +++ b/fs/btrfs/send.c
> >>>>>> @@ -3340,7 +3340,8 @@ static void free_pending_move(struct
> >>>>>> send_ctx
> >>>>>> *sctx, struct pending_dir_move *m)
> >>>>>>         kfree(m);
> >>>>>>  }
> >>>>>>
> >>>>>> -static void tail_append_pending_moves(struct pending_dir_move
> >>>>>> *moves,
> >>>>>> +static void tail_append_pending_moves(struct send_ctx *sctx,
> >>>>>> +                                     struct pending_dir_move
> >>>>>> *moves,
> >>>>>>                                       struct list_head *stack)
> >>>>>>  {
> >>>>>>         if (list_empty(&moves->list)) {
> >>>>>> @@ -3351,6 +3352,10 @@ static void
> >>>>>> tail_append_pending_moves(struct
> >>>>>> pending_dir_move *moves,
> >>>>>>                 list_add_tail(&moves->list, stack);
> >>>>>>                 list_splice_tail(&list, stack);
> >>>>>>         }
> >>>>>> +       if (!RB_EMPTY_NODE(&moves->node)) {
> >>>>>> +               rb_erase(&moves->node, &sctx->pending_dir_moves);
> >>>>>> +               RB_CLEAR_NODE(&moves->node);
> >>>>>> +       }
> >>>>>>  }
> >>>>>>
> >>>>>>  static int apply_children_dir_moves(struct send_ctx *sctx)
> >>>>>> @@ -3365,7 +3370,7 @@ static int apply_children_dir_moves(struct
> >>>>>> send_ctx *sctx)
> >>>>>>                 return 0;
> >>>>>>
> >>>>>>         INIT_LIST_HEAD(&stack);
> >>>>>> -       tail_append_pending_moves(pm, &stack);
> >>>>>> +       tail_append_pending_moves(sctx, pm, &stack);
> >>>>>>
> >>>>>>         while (!list_empty(&stack)) {
> >>>>>>                 pm =3D list_first_entry(&stack, struct
> >>>>>> pending_dir_move,
> >>>>>> list);
> >>>>>> @@ -3376,7 +3381,7 @@ static int apply_children_dir_moves(struct
> >>>>>> send_ctx *sctx)
> >>>>>>                         goto out;
> >>>>>>                 pm =3D get_pending_dir_moves(sctx, parent_ino);
> >>>>>>                 if (pm)
> >>>>>> -                       tail_append_pending_moves(pm, &stack);
> >>>>>> +                       tail_append_pending_moves(sctx, pm,
> >>>>>> &stack);
> >>>>>>         }
> >>>>>>         return 0;
> >>>>>>
> >>>>>> --
> >>>>>> 1.9.1
> >>>>>>
> >>>
> >>>
> >>>
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
