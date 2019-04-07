Return-Path: <SRS0=Yn0v=SJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7098C282DD
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74787218CD
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:37:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wm7eGHOP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfDGHhO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 03:37:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55900 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfDGHhO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2019 03:37:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id o25so10801541wmf.5;
        Sun, 07 Apr 2019 00:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wvrBYYS7G+jSg6bhwaJRqoD0wimq37jBLXYJ/U4fGIU=;
        b=Wm7eGHOPLf6Eu7ZXlg8Fiowxoa8bjmxB1BWsUdZ0j29dOKZXzgitf6kHZUHY1FVaoH
         CWnUat/s6kVvouWf4Jsp4I7mSk77tNZ+1IxT3Po5IEFWWGiTeLVDfxZh0qHS3biEoDvC
         DhH3zX/EVEpodPLV3jYhxgRjEnHTHB07pcF8TvxFQBNAT5i7HE8C9bqZap3J6FR+vkEb
         QMh3nOpskimouzTPEV3yuHVMUPJeKwdG/Gc5Bi/ZKClT5C3GEXz6Q1HiPZTFrajtc/nI
         Qv1lHIuWdOxDJs4pxdiobV8x5RdJF7PfhQYyTONzKnYsD8YfZowQZ46bmEkqBnzM6SpC
         bRFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wvrBYYS7G+jSg6bhwaJRqoD0wimq37jBLXYJ/U4fGIU=;
        b=FjOcll8jo29umhui6z9PdAXs/e0ecEhFsiGiGKyV1vSypY9j+8t3TaoV4G9vXWGlyb
         a71PePfzXU/9KYHlAmsXffjs/20IE0i1sZrTmSyxlwH7bK0V2Jh6JLtRGW5ncStQi7O6
         QZiKUt03bB8eZYrNAaE6FqA208wR8qVSHTbvL7pGoZQ22JpNRHlupv4SawrX4TA3wFsY
         DZ+dDkIjn1rKVOWH5B9RqzwSZvoT2J1/uKFcqRGR5pMeq3gGIB+Xlke3t7a3Es0XOgZd
         CIFxss53wv2N4rkGNK5ccBS33fVjSTznEInelPjX2yqr2TCLWY6lXJ3t1azI9WoqE0wg
         ORuQ==
X-Gm-Message-State: APjAAAVQEa43oH2FBf/e2rjw+j2LH7b3JhVgmEfal+FUS1/rZAXYPsMa
        GxFiqtF+Mo8d/iZyFD8MVYPts6jOnXs2rt9GVow=
X-Google-Smtp-Source: APXvYqwy2mngj91zkUE0HrX06roIYOPmtugKNirTH4K4pz5X5HmOJXwSjYQCocJUE6oeVNeIETJK4PQR5ravQIc34dE=
X-Received: by 2002:a7b:c00b:: with SMTP id c11mr12993802wmb.23.1554622632146;
 Sun, 07 Apr 2019 00:37:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190406215428.3131-1-ming.lei@redhat.com> <20190407065205.GA8799@lst.de>
In-Reply-To: <20190407065205.GA8799@lst.de>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Sun, 7 Apr 2019 15:37:00 +0800
Message-ID: <CACVXFVOZxK7jGUmMH1Q_djE7O=cK1v40O4XQJs4i7TGErJe8Qw@mail.gmail.com>
Subject: Re: [PATCH] block: don't use for-inside-for in bio_for_each_segment_all
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Omar Sandoval <osandov@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Apr 7, 2019 at 2:53 PM Christoph Hellwig <hch@lst.de> wrote:
>
> The change itself looks fine to be, but a few comments on semingly
> unrelated changes:
>
> > +#define bio_for_each_segment_all(bvl, bio, i, iter_all)                      \
> > +     for (i = 0, bvl = bvec_init_iter_all(&iter_all);                \
> > +             iter_all.idx < (bio)->bi_vcnt &&                        \
> > +             (mp_bvec_advance(&((bio)->bi_io_vec[iter_all.idx]),     \
> > +                              &iter_all), 1); i++)
>
> Instead of the complicated expression inside the for loop test
> expression can't we move the index check into mp_bvec_advance and let
> it return a bool?

OK, will move index check into mp_bvec_advance.

>
> > diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> > index f6275c4da13a..6e4996dfc847 100644
> > --- a/include/linux/bvec.h
> > +++ b/include/linux/bvec.h
> > @@ -48,7 +48,7 @@ struct bvec_iter {
> >  struct bvec_iter_all {
> >       struct bio_vec  bv;
> >       int             idx;
> > -     unsigned        done;
> > +     unsigned        bv_done;
>
> Why the rename here?

'done' may be a bit misleading given we know this field is for recording how
many bytes we have done on the current bvec. Or .bvec_done?

>
> > +static inline void mp_bvec_advance(const struct bio_vec *bvec,
> > +                                struct bvec_iter_all *iter_all)
>
> If we rename this we should probably drop the mp_ prefix..

OK.

>
> Also not for this patch, but we should really consider moving this
> function out of line given how big it is.

It  is fine for me, but I think they shouldn't belong to this fix.


Thanks,
Ming Lei
