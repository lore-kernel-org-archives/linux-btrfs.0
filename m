Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:54240 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751729AbdJSOnQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 10:43:16 -0400
Received: by mail-wr0-f171.google.com with SMTP id u40so2716185wrf.10
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 07:43:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0a93b5df-dad5-ff27-b7d3-ac2519892696@gmail.com>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
 <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
 <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com> <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
 <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com> <20171017011443.bupcsskm7joc73wb@angband.pl>
 <e8497dd4-7341-a708-7828-282001738a95@gmail.com> <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
 <23015.23766.971947.937708@tree.ty.sabi.co.uk> <cc34039f-9e84-c280-c793-1e381cbb2001@gmail.com>
 <23016.34313.523398.532675@tree.ty.sabi.co.uk> <CAA-GF5vfbm=fzhRchfTK=w9bHbApUGHeDw7Bgm3awZ1HN6s0jg@mail.gmail.com>
 <0a93b5df-dad5-ff27-b7d3-ac2519892696@gmail.com>
From: Zoltan <zoltan1980@gmail.com>
Date: Thu, 19 Oct 2017 16:42:34 +0200
Message-ID: <CAA-GF5vaP-O+6rBiRVKF_cUnmfWHW9+Qp8a=RzecmizmEcoW1g@mail.gmail.com>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Peter Grandi <pg@btrfs.list.sabi.co.uk>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 19, 2017 at 4:27 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> and thus when the same device reappears (as it will when the disconnect was
> due to a transient bus error, which happens a lot), it shows up as a
> different device node, which gets scanned for filesystems by udev, and BTRFS
> then gets really confused because it now sees 3 (or more) devices for a 2
> device filesystem.

And what would happen with a regular, single-device BTRFS volume after
a reconnect? Isn't this issue just as bad for that case?

Thanks,

Zoltan
