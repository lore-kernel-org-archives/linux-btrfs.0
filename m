Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33242 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbbDTPfF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 11:35:05 -0400
Received: by oica37 with SMTP id a37so125610283oic.0
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 08:35:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150420144928.GT1258@merlins.org>
References: <5534D201.7080803@onsd.eu> <20150420102705.GF18187@carfax.org.uk> <20150420144928.GT1258@merlins.org>
From: =?UTF-8?Q?F=C3=A1bio_Pfeifer?= <fmpfeifer@gmail.com>
Date: Mon, 20 Apr 2015 12:34:44 -0300
Message-ID: <CABtk0xR0f_o1DWbdVn2BZ9Sc_cUMd7cJ9HfNhWahSiFi+uRxYw@mail.gmail.com>
Subject: Re: Is btrfs on top of bcache stable now?
To: Marc MERLIN <marc@merlins.org>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?Q?N=C3=A9moz_Saint=2DDizier=2C_Olivier?= <olivier@onsd.eu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm one of those that used to have problems with btrfs on top of bcache.
After some corruptions, I gave up this setup.

Recently (from February, I think) I gave it another shot, and I have
had no problems since.
I use bcache in writeback mode, with very good performance. I'm
feeling btrfs very stable in this setup.

Best Regards,

Fabio Pfeifer

2015-04-20 11:49 GMT-03:00 Marc MERLIN <marc@merlins.org>:
> On Mon, Apr 20, 2015 at 10:27:05AM +0000, Hugo Mills wrote:
>>    See the first issue here: https://btrfs.wiki.kernel.org/index.php/Gotchas
>
> Hi Hugo, looking at the page again, I see
> "bcache + btrfs does not seem to be stable yet"
> linking to a thread more than 2 years old and btrfs kernels that
> wouldn't be stable without bcache anyway.
>
> I've seen others mention they switched to bcache recently and not seen
> new "it's broken" reports.
>
> So, is it ok
> 1) to assume bcache and btrfs play ok together now?
> 2) remove the warning from that gotchas page?
>
> Thanks,
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
