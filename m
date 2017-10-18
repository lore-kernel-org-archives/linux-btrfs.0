Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:47350 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751657AbdJROHv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 10:07:51 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:60336)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e4p0f-0003yQ-Qz
        for linux-btrfs@vger.kernel.org; Wed, 18 Oct 2017 15:07:49 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e4oml-0007N7-Sv
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Oct 2017 14:53:27 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23015.23766.971947.937708@tree.ty.sabi.co.uk>
Date: Wed, 18 Oct 2017 14:53:26 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
In-Reply-To: <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
        <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
        <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
        <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
        <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com>
        <20171017011443.bupcsskm7joc73wb@angband.pl>
        <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
        <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> I forget sometimes that people insist on storing large
>> volumes of data on unreliable storage...

Here obviously "unreliable" is used on the sense of storage that
can work incorrectly, not in the sense of storage that can fail.

> In my opinion the unreliability of the storage is the exact
> reason for wanting to use raid1. And I think any problem one
> encounters with an unreliable disk can likely happen with more
> reliable ones as well, only less frequently, so if I don't
> feel comfortable using raid1 on an unreliable medium then I
> wouldn't trust it on a more reliable one either.

Oh please, please a bit less silliness would be welcome here.
In a previous comment on this tedious thread I had written:

  > If the block device abstraction layer and lower layers work
  > correctly, Btrfs does not have problems of that sort when
  > adding new devices; conversely if the block device layer and
  > lower layers do not work correctly, no mainline Linux
  > filesystem I know can cope with that.

  > Note: "work correctly" does not mean "work error-free".

The last line is very important and I added it advisedly.

You seem to be using "unreliable" in two completely different
meanings, without realizing it, as both "working incorrectly"
and "reporting a failure". They are really very different.

The "working incorrectly" general case is the so called
"bizantine generals problem" and (depending on assumptions) it
is insoluble.

Btrfs has some limited ability to detect (and sometimes recover
from) "working incorrectly" storage layers, but don't expect too
much from that.
