Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:63925 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759793Ab3ICJ0L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Sep 2013 05:26:11 -0400
Received: by mail-vc0-f180.google.com with SMTP id gf11so3594530vcb.39
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Sep 2013 02:26:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$97a5$71cfb7f0$286a61f9$62ed2e15@cox.net>
References: <20130902220006.GA6389@carfax.org.uk>
	<pan$97a5$71cfb7f0$286a61f9$62ed2e15@cox.net>
Date: Tue, 3 Sep 2013 19:26:10 +1000
Message-ID: <CAA1QwTbiYGWpxctxOrF67wOzdAr6U6TKR__HZW44c2q9XeVM2w@mail.gmail.com>
Subject: Re: Recovering from csum errors
From: David MacKinnon <blaedd@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3 September 2013 18:54, Duncan <1i5t5.duncan@cox.net> wrote:
>
> > In case the data is wrong, there may be a reverse CRC32 algorithm
> > implemented. Most likely it's only several bytes which got "flipped".
>
...
>
> But... that flips the entire reason for choosing direct-IO in the first
> place -- performance -- on its head, incurring a **HUGE** slowdown just


Not wanting to put words in the original posters mouth, but I read
that as an offline recovery method (scrub?), rather than real time
recovery attempts. If the frequency of errors is low, then for certain
purposes accepting, a few errors if you had a recovery option might be
acceptable.

As mentioned, nocow is probably best for VM images anyhow, but still :)

-David
