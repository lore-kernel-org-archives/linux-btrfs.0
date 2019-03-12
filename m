Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDC5C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 18:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2B5E2171F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 18:16:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VydeQRn8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfCLSQf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 14:16:35 -0400
Received: from mail-it1-f172.google.com ([209.85.166.172]:51168 "EHLO
        mail-it1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfCLSQf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 14:16:35 -0400
Received: by mail-it1-f172.google.com with SMTP id m137so6027929ita.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 11:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q+to0Tif8Zfrj7rAhLjytRjWqMzxh0GUkOuh5f+As/4=;
        b=VydeQRn8K+l5mIHXlaYPrKRxh88UoUCRLLvoOu+TJjvG5eMDzvTZIQXdAVLEBKfM/0
         hHG6TTmfV5wtaHcFhbKj5iXjq//WXefvb4taWZYN3RqPAqmwMmNJyF6kgfBlHls/wPEJ
         ZOx35bVVb2Y3ajiK9BKCP+MtDCi/rWcpv4gLXzw6Bd3F/XeRg2XDBatUdo9a3NFDikXw
         W4rWFdu2vYSwlYRJTxfqfAMsjdvn4RYj7yCeUX9YbVWOHrZ2Fez1Kl+VNc8d9Nwv8nxO
         FXKDKLMwWXtOU+we7txfmLuGwRDioIuunXDt3w7BSxfA+6JzHFbuOK/QgyE2VNQFLWc/
         QagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q+to0Tif8Zfrj7rAhLjytRjWqMzxh0GUkOuh5f+As/4=;
        b=WPQpUaynJdysqYL41P9rbMnKD5vNrrKG5Ty2Ee9O5u3XBKW2rBbyF9d5w/tJCENf40
         NF5IhYfyB5K3x63Xt0aOJLykCUgUoOVW6fE53UJEcb/1vUWJTpavtMe6hCKD9qJ2wMfu
         OixukaLhqlXB0z3LSbob0e7yayZuZdRCc6zu76YxJsr7CzZz7eosIa1KeFJi2hQJ/rx2
         foN5wGlTdJQbvmWhV0dUsBYTmC2bJeLJTW4PQ5x94Ru2gm8SjSgk49PZvyH6YUyAWiuI
         sc1IndizZnvQlrc5ocY4o+Nsc5h0Dmvf5P1wtyZ2AICQJPnguInBObEGPY3I1cZOA8X/
         koNw==
X-Gm-Message-State: APjAAAVB+mQfg/zXtVEKO/FPWzdzDQpSjaLhQqCBz/1iyqkJE015TJCo
        +vb3w1T/WDpH4Q9MeLq6Wlcx+wr+SrzWBXzgocE=
X-Google-Smtp-Source: APXvYqytKGXbaHdrvf2unigT1ZOEj81182DY98Wsx2fCRpjhWV9YnT6bhLhKAdk4aIul0t58p3JbrRT/G3fHPqGlEfk=
X-Received: by 2002:a02:7b0b:: with SMTP id q11mr10798290jac.47.1552414594069;
 Tue, 12 Mar 2019 11:16:34 -0700 (PDT)
MIME-Version: 1.0
References: <0102016972971d54-e7d79438-f177-48d2-ac42-55f162b6b63f-000000@eu-west-1.amazonses.com>
 <4f6e2661-e828-7a58-0256-d08e1ad40df8@gmail.com>
In-Reply-To: <4f6e2661-e828-7a58-0256-d08e1ad40df8@gmail.com>
From:   Noah Massey <noah.massey@gmail.com>
Date:   Tue, 12 Mar 2019 14:15:57 -0400
Message-ID: <CADfjVrievuXQc744rwVq01B4dUa2L9RWDZrhHGfLNKZvkEgsvA@mail.gmail.com>
Subject: Re: Allow sending of rw-subvols if file system is mounted ro
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Martin Raiber <martin@urbackup.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 12, 2019 at 2:04 PM Andrei Borzenkov <arvidjaar@gmail.com> wrot=
e:
>
> 12.03.2019 18:48, Martin Raiber =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > Hi,
> >
> > I know there are corner cases that probably make this difficult (such a=
s
> > remounting the file system rw while a send is in progress), but it woul=
d
> > be nice if one could send all subvolumes as long as a file system is
> > mounted read-only (pretend every subvol ist read-only if the file syste=
m
> > is mounted read-only).
> >
>
> It is possible to mount top level read-only and still mount subvolume
> read-write.

How about if the underlying medium is currently ro?


>
> > Background/use case:
> >
> > Through no fault of btrfs, metadata got damaged, which makes a file
> > system go read-only after a while and I'd like to btrfs send/receive th=
e
> > subvolumes and snapshots that are still readable to another btrfs file
> > system (btrfs send/receive being the only option that does this somewha=
t
> > efficiently). Only I cannot send the subvolumes that are not set to
> > read-only prior to the file system going read-only.
> > I patched the kernel and btrfs-tools (just commenting the checks out) t=
o
> > support this in my case, but it would be great if this would be possibl=
e
> > without patching.
> >
> > Regards,
> > Martin Raiber
> >
>
