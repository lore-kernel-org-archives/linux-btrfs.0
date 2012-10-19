Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:62655 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2JSSaB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 14:30:01 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so525510iag.19
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 11:30:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvh9VFUxdsRehuZdTC-0VYdwbEL=cmtoU=gqTs8Ne29m8A@mail.gmail.com>
References: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
 <20121018132850.GA22010@shiny> <CAK0PdAkbtT=PynBi0KjEsDBGy4U1RhBmWf5uQRQYQ3Z-M__nvg@mail.gmail.com>
 <CAE5mzvi6B_KqmVBSsNRyK6==k9f_MgYK1y4Aw-5jxZ1AhoxxOg@mail.gmail.com>
 <CAK0PdAk+Q=bY8OMn8mP8HB4iorgLYLYQv6bJM_uLkBozFJwQcg@mail.gmail.com>
 <CAK0PdA=DSoWV-8RDFy10guE1QEL4VegUwrM4JwC5HNpQF8eK5w@mail.gmail.com>
 <CAE5mzvj4_vknNaKnpFG+Q+Tpg1dxA+W+g9xWhDPMLrmt2_Lk3A@mail.gmail.com> <CAE5mzvh9VFUxdsRehuZdTC-0VYdwbEL=cmtoU=gqTs8Ne29m8A@mail.gmail.com>
From: Marguerite Su <i@marguerite.su>
Date: Sat, 20 Oct 2012 02:29:40 +0800
Message-ID: <CAK0PdAn_GUCJLnqS9PFiqm7FVh-riFwW8YtUJRP=7YW-K6zypw@mail.gmail.com>
Subject: Re: initramfs take a long time to load[135s]
To: cwillu <cwillu@cwillu.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 20, 2012 at 12:55 AM, cwillu <cwillu@cwillu.com> wrote:
> It appears space_cache isn't enabled on your rootfs; can you do a
> "mount / -o remount,space_cache", sync a couple times, make some
> coffee, and then reboot, and see if it's better?
>
> You should see two instances of "btrfs: disk space caching is enabled"
> in your dmesg, one for / and the second for /home.
>
> Also, make sure to reply-all so that others interested can still follow along.

Marvelous! cwillu, you're the most brilliant man I've ever seen in this world!

I can't find a most suitable word to say thank you!

You saved my life! I mean, 1 year and a half's struggling now comes to an end!

Hugggggggggggg!


Can you tell me what my problem actually is? do you or do I need a
patch of something added to the code base? I mean, I'm an openSUSE
Memeber, our distro didn't have my:

default,space_cache,comment="systemd.automount" and 0 1

set by default, actually it was:

default 0 2

so is there anything I can do to make this happiness come to everyone
in my distribution?


Huggggg againnn!

Marguerite
