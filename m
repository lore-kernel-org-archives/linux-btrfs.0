Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39083 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab3IMMgQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 08:36:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130913121529.GA1437@flint.arm.linux.org.uk>
References: <20130912153629.16487.88969@localhost.localdomain>
	<CA+5PVA5GogJnewWvdmVo03oZRZDerE=H7BR49Xi1DZQyE_CG4Q@mail.gmail.com>
	<CAMuHMdWgzQvKkASycHSzpTwi2c3qG+wn52YSr-=c8cDtro7NyQ@mail.gmail.com>
	<CA+5PVA6Hm6XLdJa=x9TmZnjSH160337i-CM2HGHBpQMf06Bv9w@mail.gmail.com>
	<20130913121529.GA1437@flint.arm.linux.org.uk>
Date: Fri, 13 Sep 2013 14:36:15 +0200
Message-ID: <CAMuHMdXMDmF4YqMWdGB8LxWsV7wr0koS47xak-isb5KAX-1sNQ@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Josh Boyer <jwboyer@fedoraproject.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Mason <chris.mason@fusionio.com>, Mark Fasheh <mfasheh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 2:15 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> On Fri, Sep 13, 2013 at 07:53:21AM -0400, Josh Boyer wrote:
>> I'm not an ARM expert, so I don't know if ARM should use the
>> asm-generic implementations, or just use __get_user/__put_user in all
>> cases.  I've CC'd rmk.
>
> Why do we have uaccess-unaligned.h ?  Normally, these kinds of things
> are spawned by architectures which have problems with unaligned accesses,
> ARM being one of them, but afaik we've never need this.
>
> With the kernel-side trapping of unaligned accesses on older hardware,
> we've always dealt with the normal accessor faulting.
>
> From what I can tell in the git history, these unaligned put_user and
> get_user have existed all the way back to the dawn of git use.
>
> Can someone enlighten me why we have them?

You removed the answer when trimming the quoted part:

| "Btrfs is the first user of __put_user_unaligned() outside the compat code,

 __put_user_unaligned() is used in fs/compat.c, presumably because
alignment restrictions may differ between 32- and 64-bit versions of the
same CPU family.

No one seems to actully use __get_user_unaligned().

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
