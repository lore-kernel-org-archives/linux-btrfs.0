Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:43332 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab2JSSdq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 14:33:46 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so528616iag.19
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 11:33:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvggOwC3W-Jak0GAGky7a2fhWFK-d61US30C9STxbyMVxw@mail.gmail.com>
References: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
 <20121018132850.GA22010@shiny> <CAK0PdAkbtT=PynBi0KjEsDBGy4U1RhBmWf5uQRQYQ3Z-M__nvg@mail.gmail.com>
 <CAE5mzvi6B_KqmVBSsNRyK6==k9f_MgYK1y4Aw-5jxZ1AhoxxOg@mail.gmail.com>
 <CAK0PdAk+Q=bY8OMn8mP8HB4iorgLYLYQv6bJM_uLkBozFJwQcg@mail.gmail.com>
 <CAK0PdA=DSoWV-8RDFy10guE1QEL4VegUwrM4JwC5HNpQF8eK5w@mail.gmail.com>
 <CAE5mzvj4_vknNaKnpFG+Q+Tpg1dxA+W+g9xWhDPMLrmt2_Lk3A@mail.gmail.com>
 <CAE5mzvh9VFUxdsRehuZdTC-0VYdwbEL=cmtoU=gqTs8Ne29m8A@mail.gmail.com>
 <CAK0PdAk5jUMFkYek1r-M-D0OygqXbqZD+_fQ9RBZTE7gsEymFQ@mail.gmail.com> <CAE5mzvggOwC3W-Jak0GAGky7a2fhWFK-d61US30C9STxbyMVxw@mail.gmail.com>
From: Marguerite Su <i@marguerite.su>
Date: Sat, 20 Oct 2012 02:33:25 +0800
Message-ID: <CAK0PdAm4bgVoL7G=Umc4TU8q=JNJ=-puphuxzzHpYyJW7wELCQ@mail.gmail.com>
Subject: Re: initramfs take a long time to load[135s]
To: cwillu <cwillu@cwillu.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 20, 2012 at 2:26 AM, cwillu <cwillu@cwillu.com> wrote:
> That would work, but it's only necessary to mount with it once (and
> it's probably been done already with /home), hence the -o
> remount,space_cache

Now my kernel loads in 10s, another 4s for userspace...then -.mount
and all the systemd services.

It boots like an animal!
