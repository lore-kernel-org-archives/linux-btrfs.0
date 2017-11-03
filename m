Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:52784 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdKCEBU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 00:01:20 -0400
Received: by mail-vk0-f54.google.com with SMTP id i133so1009819vke.9
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 21:01:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKuJGC8vE+vdTXf-WKuMfP-Sd=hiNmaCsm_1=vTQi7ngBh3kCQ@mail.gmail.com>
References: <CAKuJGC8M3NFbZ5Ky0gsuwz3oioCayPWK+JcxtC+BZ9=DuG4TXw@mail.gmail.com>
 <92334609-a0a2-6cb4-5127-0c3767917ad2@gmx.com> <CAKuJGC_pagdiUy-csrK4G1KL01iib+CVdtW5wwd8dsiWTjrysQ@mail.gmail.com>
 <0bc63e4d-1176-9534-01ac-5cf6292bccdd@gmx.com> <CAKuJGC8vE+vdTXf-WKuMfP-Sd=hiNmaCsm_1=vTQi7ngBh3kCQ@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Fri, 3 Nov 2017 09:30:39 +0530
Message-ID: <CAKuJGC_cwYHe_Y2bEADNR0UGrB7kncE-N5vrE=CRvMJ8g9726Q@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.h:3457!
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After disabling FS_CHECK_INTEGRITY and FS_RUN_SANITY_TESTS in the
config. Now the issue resolved. thanks.

cast: https://asciinema.org/a/Dy6eHhhWPEIxotVbVUBWrhFeF
----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org


On Thu, Nov 2, 2017 at 12:55 PM, Lakshmipathi.G
<lakshmipathi.g@gmail.com> wrote:
> Okay thanks, I'll disable above mentioned entry in kernel config and
> run the tests.
> Will get back with  updated results.
>
>
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
