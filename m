Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:43541 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbdJSNsy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 09:48:54 -0400
Received: by mail-wr0-f174.google.com with SMTP id p46so8404777wrb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 06:48:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <23016.34313.523398.532675@tree.ty.sabi.co.uk>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
 <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
 <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com> <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
 <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com> <20171017011443.bupcsskm7joc73wb@angband.pl>
 <e8497dd4-7341-a708-7828-282001738a95@gmail.com> <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
 <23015.23766.971947.937708@tree.ty.sabi.co.uk> <cc34039f-9e84-c280-c793-1e381cbb2001@gmail.com>
 <23016.34313.523398.532675@tree.ty.sabi.co.uk>
From: Zoltan <zoltan1980@gmail.com>
Date: Thu, 19 Oct 2017 15:48:12 +0200
Message-ID: <CAA-GF5vfbm=fzhRchfTK=w9bHbApUGHeDw7Bgm3awZ1HN6s0jg@mail.gmail.com>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
To: Peter Grandi <pg@btrfs.list.sabi.co.uk>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Thu, Oct 19, 2017 at 1:01 PM, Peter Grandi <pg@btrfs.list.sabi.co.uk> wrote:

> What the OP was doing was using "unreliable" both for the case
> where the device "lies" and the case where the device does not
> "lie" but reports a failure. Both of these are malfunctions in a
> wide sense:
>
>   * The [block] device "lies" as to its status or what it has done.
>   * The [block] device reports truthfully that an action has failed.

Thanks for making this point, it made me realize that I had different
assumption than what you use in your reasoning. I assumed that when
writes to a USB device fail due to a temporary disconnection, the
kernel can actually recognize that a write error happened. So are you
saying that a write error due to USB problems can go completely
unnoticed? That seems very strange to me; are USB drives really that
unreliable or is that some software limitation?

Thanks,

Zoltan
