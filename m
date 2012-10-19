Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42397 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab2JSTCr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 15:02:47 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so1139784iea.19
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 12:02:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvhD4Q58g5sv-i4NAcHUY4we1b90_RwH_CLeBk86Qg8piw@mail.gmail.com>
References: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
 <20121018132850.GA22010@shiny> <CAK0PdAkbtT=PynBi0KjEsDBGy4U1RhBmWf5uQRQYQ3Z-M__nvg@mail.gmail.com>
 <CAE5mzvi6B_KqmVBSsNRyK6==k9f_MgYK1y4Aw-5jxZ1AhoxxOg@mail.gmail.com>
 <CAK0PdAk+Q=bY8OMn8mP8HB4iorgLYLYQv6bJM_uLkBozFJwQcg@mail.gmail.com>
 <CAK0PdA=DSoWV-8RDFy10guE1QEL4VegUwrM4JwC5HNpQF8eK5w@mail.gmail.com>
 <CAE5mzvj4_vknNaKnpFG+Q+Tpg1dxA+W+g9xWhDPMLrmt2_Lk3A@mail.gmail.com>
 <CAE5mzvh9VFUxdsRehuZdTC-0VYdwbEL=cmtoU=gqTs8Ne29m8A@mail.gmail.com>
 <CAK0PdAk5jUMFkYek1r-M-D0OygqXbqZD+_fQ9RBZTE7gsEymFQ@mail.gmail.com>
 <CAE5mzvggOwC3W-Jak0GAGky7a2fhWFK-d61US30C9STxbyMVxw@mail.gmail.com>
 <CAK0PdAm4bgVoL7G=Umc4TU8q=JNJ=-puphuxzzHpYyJW7wELCQ@mail.gmail.com> <CAE5mzvhD4Q58g5sv-i4NAcHUY4we1b90_RwH_CLeBk86Qg8piw@mail.gmail.com>
From: Marguerite Su <i@marguerite.su>
Date: Sat, 20 Oct 2012 03:02:26 +0800
Message-ID: <CAK0PdA=RqD7rAywEkU_fpRjAm58HX1WbGwK8Pfx6CXZJ2e8pEQ@mail.gmail.com>
Subject: Re: initramfs take a long time to load[135s]
To: cwillu <cwillu@cwillu.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 20, 2012 at 2:35 AM, cwillu <cwillu@cwillu.com> wrote:
> Without space_cache (once), btrfs has to repopulate that information
> the slow way every mount; with it, it can just load the data from the
> last unmount (modulo some consistency checks).
>
> The setting is sticky, so you don't actually need it in fstab any more
> (although it won't hurt anything either).

Thanks, cwillu!

I transfer the message to openSUSE bugzilla and ask them help making
that happen by default in openSUSE.

Marguerite
