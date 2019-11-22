Return-Path: <SRS0=P1qN=ZO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C58C432C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Nov 2019 14:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 309E320715
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Nov 2019 14:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XG4VGhFC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfKVOhW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 09:37:22 -0500
Received: from mail-ed1-f51.google.com ([209.85.208.51]:38636 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfKVOhV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Nov 2019 09:37:21 -0500
Received: by mail-ed1-f51.google.com with SMTP id s10so6224237edi.5
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2019 06:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=wj7MhRKYNn4w+pi0iYk3oIUmBvepA4GUHiCNXrjX7M8=;
        b=XG4VGhFChvGOT9BKOjmciQ+aJ265XVhVwgnB4e9sRykAChDzorHurBfbL9RS6c0xRI
         1L1YCV1mejXzXgw9Eb2hPgqzCG6enEJXhkquzHBbd61mATnAoiMU9Eyn6qD/9qjJuUp9
         d/a/ECan93zW8/XMn+N7GQ7h6aiCUn+McT1dmud6LN/qcbJC8OwXkSUlfJyCu7x1YxQC
         f3MnRTVJfV2UOxpFKuBpguJRh+pvj0suJK4XpzPT/IrMJcmKb4rLT7ooKSy/knyfa0vr
         iH67HFo0eQmE83M2LeEYLbIBJDamj3HYgtr+pMYKub6ebUNU+drZwAT3YJCw1wHNWnlt
         5SAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=wj7MhRKYNn4w+pi0iYk3oIUmBvepA4GUHiCNXrjX7M8=;
        b=GWnetaHntnJoJYLXhQf5bnac5+mUZf/xeu/W5U49c+46TR5JlNJvvvxeshwuYg6yVs
         N6hjcKDzzR50SNdK1wZFGI3D5VWNFT48xmyNy/t1oxVaBu6w35duuqvb2fzN3hJH3fOq
         zGo+KrxcGuvj2Lwc+zOQ+Fmg1gx3J0uqscgf0EAHhZZ5mVCDvKYspS6kOiHx6TV57iA3
         kq41DkmXkvJYJdtVLMuaRppqi9Lw/aUfWdSz71vtzVxRz29PN/l/GL/0W4GT5g8KBgC9
         nOh2zhaDSIJNyfRom6+dQYKEW/Ugu+Rb6e73RbP1dEKWt0tLvJCZ83vcUTE0inGHo7QQ
         d84g==
X-Gm-Message-State: APjAAAVi4Aqn/wj7ln4FGhatWwDxIBa46J4Ae1x98uGGunf9mEK1nt6H
        Nb8kQJUe68S+gDka7cafwmLqCXjCXJmG7CxuAqnm
X-Google-Smtp-Source: APXvYqyq0SQgoRwaEkM2MNvx70i2KJBqf4q0uh948W9k0aVbx4mQ8fANcCpdg9zto6xf9Ck6agJ2VEDIa4vtQzJuhN4=
X-Received: by 2002:a17:906:411:: with SMTP id d17mr22253984eja.299.1574433439498;
 Fri, 22 Nov 2019 06:37:19 -0800 (PST)
MIME-Version: 1.0
References: <20191112183425.GA1257@tik.uni-stuttgart.de> <7f628741-b32e-24dc-629f-97338fde3d16@googlemail.com>
 <CAKbQEqGOXNhHUSdHQyjQDijh3ezVK-QZgg7dK5LJJNUNqRiHpg@mail.gmail.com> <20191121222228.GG22121@hungrycats.org>
In-Reply-To: <20191121222228.GG22121@hungrycats.org>
From:   Christian Pernegger <pernegger@gmail.com>
Date:   Fri, 22 Nov 2019 15:36:43 +0100
Message-ID: <CAKbQEqFBYdi59QFPLXiiPvpFEzRnM-wG2Yz=2mdkeLOiOAAwmA@mail.gmail.com>
Subject: Re: freezes during snapshot creation/deletion -- to be expected?
 (Was: Re: btrfs based backup?)
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Am Do., 21. Nov. 2019 um 23:22 Uhr schrieb Zygo Blaxell
<ce3g8jdj@umail.furryterror.org>:
> Snapshot delete is pretty aggressive with IO [...]  can effectively hang for a few minutes
> while btrfs-cleaner runs.

It's doesn't look like it's btrfs-cleaner that blocks here, though,
more like it's btrfs-transacti.

> Snapshot create has unbounded running time on 5.0 kernels.

It looks to me like delete, not create, is the culprit here.

> Anything that needs to take a sb_writer lock (which is almost everything
> that modifies the filesystem) will hang until the snapshot create is done;

It's not just fs activity, either. Even if I'm just typing in
LibreOffice or at a bash prompt, the input isn't registered during the
freeze (it's buffered, so it comes out all at once in the end).

Cheers,
C.
