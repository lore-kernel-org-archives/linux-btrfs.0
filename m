From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: licenses (for apple OSX and others)?
Date: Mon, 15 Aug 2011 00:54:18 -0500
Message-ID: <CAGAVQTHxUDst6rO8=y4yzY1aU3+xiZHgt36wqLm_Ra=cm2j1FQ@mail.gmail.com>
References: <CAPr7RtVfNtNno=7KTJvyvNFnkumHd3PiJSo8eoswBZT-0vwFQA@mail.gmail.com>
 <CANZ96zU5f_2cCZGstHsSnuWrC6y0tXh=3kPhkuO5Xs+goKxP+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: ivo welch <ivowel@gmail.com>, linux-btrfs@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANZ96zU5f_2cCZGstHsSnuWrC6y0tXh=3kPhkuO5Xs+goKxP+A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 14, 2011 at 9:53 PM, Billy Crook <billycrook@gmail.com> wro=
te:
> On Sun, Aug 14, 2011 at 19:34, ivo welch <ivowel@gmail.com> wrote:
>> curiosity question---could btrfs be licensed in multiple ways to all=
ow
>> Apple and other vendors to adopt it?
>
> Great question, Ivo.
>
> And it turns out, btrfs is already licensed to permit commercial use,
> integration into other products, and resale.
>
> The license of btrfs isn't stopping Apple or Microsoft from using
> btrfs. =C2=A0All licenses have terms (You should read the terms on so=
me of
> Apple and Microsoft's software), but so long as they don't violate an=
y
> terms, they are welcome to use all parts of the btrfs code for their
> corporation's profit, and their customer's benefit.

=2E.. and while some will certainly argue one way or another, this is a
case where (IMO) the code for btrfs (as a module) is clearly distinct
from the OSX kernel (as it was not even designed for it originally)
and would not constitute far reaching public release of Apple IP ...
though tbh i know nothing about OSX kernel and whether it support
things like dynamic modules, so i could be mistaken ...

=2E.. but im confident there is a way Apple could wire it up so IP
release could be very small or nonexistent.  or maintain a "port" if
they so wished.

the real question is whether or not they would even desire using it
with infrastructure around HFS+/etc ... in my observations Apple and
friends are incredibly ... ehm ... selective -- the hardware and
everything above it *must* have the `Seal of Approval` -- maybe to
reduce/isolate their problem pool or maintain it's clique-crazed
"chic" aura :-), i dont know, but it's not for the end-user's
flexibility -- that's for sure.  the glaring example to me is
virtually the entire mobile/handheld/device industry deciding on
micro-USB as the power+data xchange connection *except* one infamous
product line ...

but meh, who really knows anyway; it certainly would be incredibly
cool to have a common denominator greater than FAT, especially since
commodity flash chips are 8-16GB now.

--=20

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
