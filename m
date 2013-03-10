Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:41412 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3CJWnC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 18:43:02 -0400
Received: by mail-lb0-f177.google.com with SMTP id go11so2676788lbb.36
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 15:43:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130310222423.GG30771@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <513CAA25.2010803@gmail.com> <20130310222423.GG30771@carfax.org.uk>
From: Harald Glatt <mail@hachre.de>
Date: Sun, 10 Mar 2013 23:42:40 +0100
Message-ID: <CAFWF=amtTscj9-Bso67E+LW+TwnxggsFrTGDS4asSt0ttnCy+Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
To: Hugo Mills <hugo@carfax.org.uk>, kreijack <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 10, 2013 at 11:24 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On 03/09/2013 09:31 PM, Hugo Mills wrote:
>> >    Some time ago, and occasionally since, we've discussed altering the
>> > "RAID-n" terminology to change it to an "nCmSpP" format, where n is the
>> > number of copies, m is the number of (data) devices in a stripe per copy,
>> > and p is the number of parity devices in a stripe.
>> >
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>        --- Great oxymorons of the world, no. 6: Mature Student ---

It's important that the userland tools will output the things in both
a 'human readable' format as well as the short forms. I would say when
giving btrfs a parameter, it should only accept the short forms. But
in order to allow users to figure out what they actually mean when
doing something like 'btrfs fi show' it should tell you sometihng by
the lines of  '1 copy, 3 stripes, 1 parity (1C3S1P)' instead of just
the short form.

I would also make the case that leaving out 'defaults' from the output
is bad for the learning curve as well. Even when it's just 1C I
wouldn't remove that from the output, but the input parameter when you
work with it should know what you mean when you leave 1C out, of
course, and not require it.
