Return-Path: <SRS0=Yn0v=SJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1246C10F0E
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7245B20B1F
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:54:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A+CYsKZ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbfDGHya (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 03:54:30 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39809 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfDGHya (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2019 03:54:30 -0400
Received: by mail-wr1-f66.google.com with SMTP id j9so12655035wrn.6;
        Sun, 07 Apr 2019 00:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1t+UQKqomSG9Oju3veI9OgJ2qKMahuvYfzDPeTuHLfQ=;
        b=A+CYsKZ4p242LsazODe1oJMq/uANfk3EG0ugtAcwJTi9TkNW0HaM09yBzaS5TqKAsY
         ywIwcJ3/YHICg78Ey6NXnPbTjI8bhIZD4Sukz1uBqNi6+r+iSk8sirgWcdIaj3edQN+/
         THuyGxMj5tEHhKRxSglOXLsitjIy4qYDU2e73eWT9Leohf1pjiGrHNQZQMvNoQBztuWO
         6GTylr2m+RoWPjSGpcGO1TzMXVPpWmV+3FappyvR1+RkVJxUmZRSEjsX9N48JDSrgbTX
         c0HQjDFF1+UECHT31JNs1jhAdVi9/YgAVPtKtp9szi2LKdLjLYLhQM1DKIv79EWTKbe3
         T14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1t+UQKqomSG9Oju3veI9OgJ2qKMahuvYfzDPeTuHLfQ=;
        b=gcAd2uSXFTZXjylCPSzJHPiZA9LcKV45V1wVCK+CIE36pF/vzxKhKk4Hi89ZBSrZVK
         0qve0gmPfFgy9cK6vlclxWLuEutbzWJWhrq6pgW1hKl8Q1ob4dbiDm5KvJqKi+QeOi+M
         W/9KjvVJUKskOtFRMTpNh9oK/jB3yWVEz/QS5iGfMUum0l0GQQqkpmMRQ1+GKu7zx2qe
         iRCJ3Emee/5gybezA1Bga8eHSRMqOsuTRiYkfIzVgA/oLkKR0lrGq+grqlqUDCujfTTI
         v+jKUUWFIafNq+R7/UkMRH/GKWiRxlVS6sVR1PzutOXpIMDo4o58oU6stCUZA0lBo7Bf
         GUJw==
X-Gm-Message-State: APjAAAXOWJ/bsHpSxcRIw93lyi5ZaHe9rI6ElUFgLyE9KGbuHNgjYO6j
        bEcB3bvRDEewaJ5igxRW0DrHJ6LD9BZyXIEmkWw=
X-Google-Smtp-Source: APXvYqxEu80hG17XpufJgDG3qG/ApMW91xvYFBy7Y3eqYPM45yuDkCzGVsz1zpfdisplL2n0L7Y1HR2u6IYDj/58n+I=
X-Received: by 2002:adf:ce8f:: with SMTP id r15mr13804631wrn.90.1554623668138;
 Sun, 07 Apr 2019 00:54:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190406215428.3131-1-ming.lei@redhat.com> <20190407065205.GA8799@lst.de>
 <CACVXFVOZxK7jGUmMH1Q_djE7O=cK1v40O4XQJs4i7TGErJe8Qw@mail.gmail.com>
In-Reply-To: <CACVXFVOZxK7jGUmMH1Q_djE7O=cK1v40O4XQJs4i7TGErJe8Qw@mail.gmail.com>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Sun, 7 Apr 2019 15:54:16 +0800
Message-ID: <CACVXFVO9EAFtnspU0H4BNr4UCTry3q6icuHcXDB=c6Ura6BtMw@mail.gmail.com>
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

On Sun, Apr 7, 2019 at 3:37 PM Ming Lei <tom.leiming@gmail.com> wrote:
>
> On Sun, Apr 7, 2019 at 2:53 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > The change itself looks fine to be, but a few comments on semingly
> > unrelated changes:
> >
> > > +#define bio_for_each_segment_all(bvl, bio, i, iter_all)                      \
> > > +     for (i = 0, bvl = bvec_init_iter_all(&iter_all);                \
> > > +             iter_all.idx < (bio)->bi_vcnt &&                        \
> > > +             (mp_bvec_advance(&((bio)->bi_io_vec[iter_all.idx]),     \
> > > +                              &iter_all), 1); i++)
> >
> > Instead of the complicated expression inside the for loop test
> > expression can't we move the index check into mp_bvec_advance and let
> > it return a bool?
>
> OK, will move index check into mp_bvec_advance.

oops, I recall the above line, because:

1) the index check expression is quite straight-forward

2) it has been in my todo list to re-use bvec_advance() to re-write
iterate_bvec()
given bvec_advance() is much light-weight than for_each_bvec(). If we
move the index check into bvec_advance(), the helper has to be moved
to bio.h, then we can't use that for iterate_bvec().

thanks,
Ming Lei
