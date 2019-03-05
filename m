Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDBBC43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 10:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA5A5206DD
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 10:52:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r1HSOT/L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfCEKwL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 05:52:11 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34560 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfCEKwL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Mar 2019 05:52:11 -0500
Received: by mail-yw1-f67.google.com with SMTP id u205so6616477ywe.1;
        Tue, 05 Mar 2019 02:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lpK3gGsm+sacyGbhgh60qBuEUZi6LlslZitfkoyrMlI=;
        b=r1HSOT/LnkarW4382oMb3KMd8SpUYBx9fbTR/CAy07HxG1LsRi7TEePGZj0VRBQZP4
         FBhv8FT1H3SV5tQZEHhLZYDEyso0BnZuHe9aK3zQHdewLxH1A35JBPfUJjd2KQR/CDkl
         vbbViLNswdzCvi2sdYBDTRUXJD0thrSfPkyT5tYObXSWIJE4Vc8hKL/Qxq0zCCuuUl6K
         tV0BQ0EjtJ19banHKnMn7Qp+/5vg6GuK9JKcKn2RDrKC0lBCZ43DdWKA9DlB+uq/nxgz
         azAWf4cpIMg88kYKa9AD24NsFj8B+wZ2WJMZ4VkAjxKaYBdNlGqAruOXexm4Ukg8oq3b
         NTMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lpK3gGsm+sacyGbhgh60qBuEUZi6LlslZitfkoyrMlI=;
        b=kFpuGnuWMiUj2VEd6o+cQvfS4DraK/NuPA5RI1rOt/uNrxM8548/ae7sqnaD4Ak+fI
         4uTXMF1GSxXRM1qGTN04Ai6NAmh/Z9STK01B9HAuKb1XxIOe/ot8GGo0bQxkPNwLruMY
         ocUb1OuvceD3vH1P3pSLV+T7ZnKeKG/33EJvtYxffP6yES4H4IxYUh1GUqnwvJdPE1zZ
         tB3TPnLBepRNAr+C7Jv0P6BAaPRdSiuY7LNxNDVaWZmSs4oAVfHDgyvOZ7kWMMVAeRol
         tJiU6lF2b/BbawNtQ6U4+g7eW7LO2VuzNjEZVjfGQNBlCMU6Yd+kzZ0nZKd2XOQgtDeN
         D4gQ==
X-Gm-Message-State: APjAAAWXMKqRAFsIjbzSX5MhakH9fMpaeHXMo5WhWBC+lQIyhakm+M+u
        pD6E499x7whiZulde1MvAllRvdwe8bHJZOdtWiw=
X-Google-Smtp-Source: APXvYqwBibRSnV8KO4lif8SYDlauzH6idGm2zgjwygpITV6ZQtd/Mu9SDoFkaCCB/nojiCeBWKxmAEWi+QliLWkdYqc=
X-Received: by 2002:a0d:c944:: with SMTP id l65mr339324ywd.34.1551783130275;
 Tue, 05 Mar 2019 02:52:10 -0800 (PST)
MIME-Version: 1.0
References: <20190304140622.23997-1-fdmanana@kernel.org> <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <CAL3q7H6ceptNOyf65jbzojbZV5Nq3d0iKvYOvvE=pLaVnpgO2w@mail.gmail.com>
 <CAOQ4uxhno=ORXpLgLC2O7KoJJXm2sVEtZ8DgiHZi-4p_HmfEwg@mail.gmail.com>
 <CAL3q7H6XDTkp+wHmM9+ON+smcqk6fR5fL3Bf1OmVFE06BRnEjw@mail.gmail.com>
 <CAOQ4uxg_D0r2L=6zg4yxN1AfzkK8aHkWwOQPKEaKt8Z7WtVf2w@mail.gmail.com> <CAL3q7H7F8tuczjCXCUOewuJu3CKLq+MgYv-B2mbLA8qep7+xyA@mail.gmail.com>
In-Reply-To: <CAL3q7H7F8tuczjCXCUOewuJu3CKLq+MgYv-B2mbLA8qep7+xyA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 5 Mar 2019 12:51:59 +0200
Message-ID: <CAOQ4uxjMh-Nh2-spNCVUR07mYkuDNfJozVm8dTUmOtZxF+eSCQ@mail.gmail.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and rename
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> > As I wrote to Dave, if file is not "metadata dirty" before rename,
> > then whether or not rename dirties to file for fsync is a filesystem
> > specific implementation detail that is not in any standard.
> >
> > Since filesystems tend to try to optimize out unneeded journal
> > commits, so the observation about what filesystems do today
> > empirically is not a sufficiently strong argument.
>
> Even if the strictly ordered metadata guarantees Dave explained so
> many time before is not formally defined anywhere,
> I think it's a behavior that shouldn't change, as not only it makes
> sense, but applications might be relying on it and therefore
> useful to make sure no regressions happen. If such tests should be
> shared (and run only filesystems known to support
> the strictly ordered metadata) or require something special, is
> another question.
>

I agree with you that it is good to test and verify those semantics.
I was not arguing against assuming strictly ordered metadata.
I was arguing against assuming that rename marks the inode dirty.
If rename does not mark the inode dirty, then fsync(file) may be optimized
away by filesystem and will not require persisting anything, without
breaking strictly ordered metadata semantics.


> >
> > Again, if your test can afford to do fsync of file and parent dir
> > it is best to be on the safe side (please audit other similar tests
> > that you know about). If your test cannot afford to fsync parent
> > dir, then at least a fat comment about this issue is worth about
> > the expected (but not guaranteed) effects of fsync of file.
>
> I'm sending a v2 with the fsync against the parent directory, despite
> not being needed for any fs I could
> run the tests against, because it's a generic test.

ACK.

Thanks,
Amir.
