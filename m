Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:62454 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab3IMPiQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 11:38:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA6Qon0cskv5wDyiCxSZzc2WjUFmzYmGE0zoNJC5ms1-XQ@mail.gmail.com>
References: <20130912153629.16487.88969@localhost.localdomain>
	<CA+5PVA5GogJnewWvdmVo03oZRZDerE=H7BR49Xi1DZQyE_CG4Q@mail.gmail.com>
	<CAMuHMdWgzQvKkASycHSzpTwi2c3qG+wn52YSr-=c8cDtro7NyQ@mail.gmail.com>
	<CA+5PVA6Hm6XLdJa=x9TmZnjSH160337i-CM2HGHBpQMf06Bv9w@mail.gmail.com>
	<20130913121529.GA1437@flint.arm.linux.org.uk>
	<CA+5PVA6Qon0cskv5wDyiCxSZzc2WjUFmzYmGE0zoNJC5ms1-XQ@mail.gmail.com>
Date: Fri, 13 Sep 2013 11:38:15 -0400
Message-ID: <CA+5PVA4NAmFnc3s6CaaDow9P3xLXOiEngHjQ_P5+TEG--LZ9ZQ@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Mason <chris.mason@fusionio.com>, Mark Fasheh <mfasheh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 11:06 AM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Fri, Sep 13, 2013 at 8:15 AM, Russell King <rmk@arm.linux.org.uk> wrote:
>> On Fri, Sep 13, 2013 at 07:53:21AM -0400, Josh Boyer wrote:
>>> I'm not an ARM expert, so I don't know if ARM should use the
>>> asm-generic implementations, or just use __get_user/__put_user in all
>>> cases.  I've CC'd rmk.
>>
>> Why do we have uaccess-unaligned.h ?  Normally, these kinds of things
>> are spawned by architectures which have problems with unaligned accesses,
>> ARM being one of them, but afaik we've never need this.
>>
>> With the kernel-side trapping of unaligned accesses on older hardware,
>> we've always dealt with the normal accessor faulting.
>>
>> From what I can tell in the git history, these unaligned put_user and
>> get_user have existed all the way back to the dawn of git use.
>>
>> Can someone enlighten me why we have them?

I somehow fail at email and dropped Russell from CC on accident.  Sigh.

> So while that gets sorted out, would it be safe to just do as Geert
> did on m68k and put:
>
> #define __put_user_unaligned(x, ptr) __put_user((x), (ptr))
>
> in arch/arm/include/asm/uaccess.h, and let the normal accessors and
> kernel-side trapping deal with things?  I'm thinking that's a local
> fix until something gets sorted upstream, but I don't want to do it if
> it's going to break things.
>
> josh
