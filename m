Return-Path: <SRS0=Yn0v=SJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D90C282DE
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 08:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5B56218CD
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 08:14:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tW13knfb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfDGIOA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 04:14:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42255 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfDGIOA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2019 04:14:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id g3so12654344wrx.9;
        Sun, 07 Apr 2019 01:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sq0WbUBuZhKDl0luQlyRsloRutRbTE7UQW+xk/5RszU=;
        b=tW13knfbvNgJpIFRMPK34ZEjItIRzq5jVnJblMvCLORVU/lD+9uO+2FdgSSut64Fxs
         JksXql5kXsbTpdxG4tTTTSpMsBTPKJvYO9lP7MqgM4K85IiAktAfLA43S1befOJjOTVO
         ILE8QH86Hgv4nhRLKFOW5u3NfXHXyc02RVzmxX+QdC8X/my3hizHmLcHvCAITrs+/64s
         W2CKeIU2p1Pao0FsiHnDYIlVEcIhvtHPRZuubZK7jt863hyeLBk/Hx6l7L0bAZtF4sA/
         YIoRefSJHtvHiSTKdYG7xuzqXichWTIfIN781RDozRfx61wiZSChMO2KkS6WtXpNXeos
         Tq0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sq0WbUBuZhKDl0luQlyRsloRutRbTE7UQW+xk/5RszU=;
        b=fHwdtV1GivAvxOX+mU3/yoNV/pUhh+J+MP34bVm5fvBAicmpTsO6wIkGLM62ddklhC
         M6eAFCAdE6opFJUg2nzlRD2bcnb69COYPhJRnmCMqSUkGSruGpeDDBECkQPhKKA5r50L
         TArJjwD1AkAiDyQ4bhRNwD0Q9prqHRt5NoDuGgVZuNYbOsiC6PPZTnSTemKl4I8/oZMx
         Z8aey1kW3h/2wzNcJgDYO8PMF8YZnWrdsA0pCHUnraQy7kpchmkQyHMI2Ql9nBNe1m2L
         717EWbBi1eB4l2DqV0oM0KQE5G1LfUQvI9DWLDCAChxMXL1a5V9Nodtp8ogjau1xKtRA
         qkHw==
X-Gm-Message-State: APjAAAUcjge+abotAGHwyFBEfK95EXvSY/mzWGCzgbGOZXaR933UMmKk
        HUwUazk2QpZDYzomfRPd9LdR5tQsbJR5xzd857A=
X-Google-Smtp-Source: APXvYqxZ8Ws5R7Y4uGzAcXyl1XIa2NRPDGJMs4fQT+ggJ+e7JmWZF8bZxabYlClSKUFRKMUHlavyzwJbqEH1NTN+3MU=
X-Received: by 2002:adf:f1c7:: with SMTP id z7mr14831143wro.274.1554624838682;
 Sun, 07 Apr 2019 01:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190406215428.3131-1-ming.lei@redhat.com> <20190407065205.GA8799@lst.de>
 <CACVXFVOZxK7jGUmMH1Q_djE7O=cK1v40O4XQJs4i7TGErJe8Qw@mail.gmail.com>
 <CACVXFVO9EAFtnspU0H4BNr4UCTry3q6icuHcXDB=c6Ura6BtMw@mail.gmail.com> <20190407075800.GA9925@lst.de>
In-Reply-To: <20190407075800.GA9925@lst.de>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Sun, 7 Apr 2019 16:13:46 +0800
Message-ID: <CACVXFVPFvBDb1aQf4gaBj566RJJpY7=npFeJKsJHjYOSVOZPCQ@mail.gmail.com>
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

On Sun, Apr 7, 2019 at 3:58 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Sun, Apr 07, 2019 at 03:54:16PM +0800, Ming Lei wrote:
> > > OK, will move index check into mp_bvec_advance.
> >
> > oops, I recall the above line, because:
> >
> > 1) the index check expression is quite straight-forward
> >
> > 2) it has been in my todo list to re-use bvec_advance() to re-write
> > iterate_bvec()
> > given bvec_advance() is much light-weight than for_each_bvec(). If we
> > move the index check into bvec_advance(), the helper has to be moved
> > to bio.h, then we can't use that for iterate_bvec().
>
> You can always create a tiny wrapper around bvec_advance() that sits
> in bio.h.  Which in general is much better style than complex
> expressions inside of loops inside of macros..

OK, fair enough.


Thanks,
Ming Lei
