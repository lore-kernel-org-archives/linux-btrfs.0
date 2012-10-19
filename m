Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59528 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2JSSfJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 14:35:09 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so561996pad.19
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 11:35:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK0PdAm4bgVoL7G=Umc4TU8q=JNJ=-puphuxzzHpYyJW7wELCQ@mail.gmail.com>
References: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
	<20121018132850.GA22010@shiny>
	<CAK0PdAkbtT=PynBi0KjEsDBGy4U1RhBmWf5uQRQYQ3Z-M__nvg@mail.gmail.com>
	<CAE5mzvi6B_KqmVBSsNRyK6==k9f_MgYK1y4Aw-5jxZ1AhoxxOg@mail.gmail.com>
	<CAK0PdAk+Q=bY8OMn8mP8HB4iorgLYLYQv6bJM_uLkBozFJwQcg@mail.gmail.com>
	<CAK0PdA=DSoWV-8RDFy10guE1QEL4VegUwrM4JwC5HNpQF8eK5w@mail.gmail.com>
	<CAE5mzvj4_vknNaKnpFG+Q+Tpg1dxA+W+g9xWhDPMLrmt2_Lk3A@mail.gmail.com>
	<CAE5mzvh9VFUxdsRehuZdTC-0VYdwbEL=cmtoU=gqTs8Ne29m8A@mail.gmail.com>
	<CAK0PdAk5jUMFkYek1r-M-D0OygqXbqZD+_fQ9RBZTE7gsEymFQ@mail.gmail.com>
	<CAE5mzvggOwC3W-Jak0GAGky7a2fhWFK-d61US30C9STxbyMVxw@mail.gmail.com>
	<CAK0PdAm4bgVoL7G=Umc4TU8q=JNJ=-puphuxzzHpYyJW7wELCQ@mail.gmail.com>
Date: Fri, 19 Oct 2012 12:35:08 -0600
Message-ID: <CAE5mzvhD4Q58g5sv-i4NAcHUY4we1b90_RwH_CLeBk86Qg8piw@mail.gmail.com>
Subject: Re: initramfs take a long time to load[135s]
From: cwillu <cwillu@cwillu.com>
To: Marguerite Su <i@marguerite.su>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 19, 2012 at 12:33 PM, Marguerite Su <i@marguerite.su> wrote:
> On Sat, Oct 20, 2012 at 2:26 AM, cwillu <cwillu@cwillu.com> wrote:
>> That would work, but it's only necessary to mount with it once (and
>> it's probably been done already with /home), hence the -o
>> remount,space_cache
>
> Now my kernel loads in 10s, another 4s for userspace...then -.mount
> and all the systemd services.
>
> It boots like an animal!

Without space_cache (once), btrfs has to repopulate that information
the slow way every mount; with it, it can just load the data from the
last unmount (modulo some consistency checks).

The setting is sticky, so you don't actually need it in fstab any more
(although it won't hurt anything either).
