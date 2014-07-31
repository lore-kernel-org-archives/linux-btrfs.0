Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42183 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaGaQsV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 12:48:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140731101116.GN31950@carfax.org.uk>
References: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
	<CAPM=9ty2PhMdLykVX4c074Tdkyh0OO_jtfw-CAFHk8ANcZA4kQ@mail.gmail.com>
	<CAPDOMVgXChx5HST-jMEZmWDydWKe0Yv15pyTiPeOuQSVEjihFA@mail.gmail.com>
	<20140731101116.GN31950@carfax.org.uk>
Date: Thu, 31 Jul 2014 12:48:20 -0400
Message-ID: <CAPDOMVjOTCwkesj3KQE54Lxg8tPptTn-X-ZCsU-X4h1RCjYf+Q@mail.gmail.com>
Subject: Re: [PATCH] Remove certain calls for releasing page cache
From: Nick Krause <xerofoify@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Nick Krause <xerofoify@gmail.com>,
        Dave Airlie <airlied@gmail.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 31, 2014 at 6:11 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Wed, Jul 30, 2014 at 10:05:16PM -0400, Nick Krause wrote:
>> On Wed, Jul 30, 2014 at 7:30 PM, Dave Airlie <airlied@gmail.com> wrote:
>> >> This patch removes the lines for releasing the page cache in certain
>> >> files as this may aid in perfomance with writes in the compression
>> >> rountines of btrfs. Please note that this patch has not been tested
>> >> on my own hardware due to no compression based btrfs volumes of my
>> >> own.
>> >>
>> >
>> > For all that is sacred, STOP.
> [snip]
>> > But if you want to work on the kernel, this isn't the way to do it, and
>> > nobody will ever take a patch from you seriously if you continue in this
>> > fashion.
>> >
>> > Dave.
>> Dave ,
>> Seems I need to have tested this code first.
>
>    You've said this before, having made exactly the same error (not
> testing a patch). Yet you do it again. You seem to be ignoring all the
> advice you've been given -- or at least not learning from it, and not
> learning from your experiences. Could you please, for half an hour or
> so, stop thinking about the immediate goal of getting a patch into the
> kernel, and take a short while to think about your process of
> learning. Look at all the advice you've had (from me, from Ted, from
> others), actually understand it, and consider all the things you need
> to do which *aren't* hacking up a lump of C. Actually learn these
> things -- have them in your mind all the time.
>
>    I would appreciate it if you could actually engage with someone
> (doesn't have to be me) about this -- why are you ignoring the advice?
> Is it because you don't understand it? Is it because you think you can
> cut corners? Is it because you're concetrating on the code so much that
> you're forgetting it?
>
>    The main thing you're doing which is making people angry is not
> because you're submitting bad patches (although you are). It's because
> you're not listening to advice, and you're not apparently learning
> anything from the feedback you're given. Your behaviour is not
> changing over time, which makes you look like a waste of time to all
> those people trying to help you.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>          --- That's not rain, that's a lake with slots in it ---

Hugo,
That makes sense seems I need to listen better and test my code first, which is
bad in any environment.
Regards Nick
