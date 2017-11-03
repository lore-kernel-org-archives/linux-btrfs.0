Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:53753 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbdKCGdT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 02:33:19 -0400
Received: by mail-ua0-f181.google.com with SMTP id s41so1247985uab.10
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 23:33:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKuJGC-ZyN-HS_rn4fvC485pA2uBtL+qSQ-Mn5sEtjLENcHgxw@mail.gmail.com>
References: <CAKuJGC8M3NFbZ5Ky0gsuwz3oioCayPWK+JcxtC+BZ9=DuG4TXw@mail.gmail.com>
 <92334609-a0a2-6cb4-5127-0c3767917ad2@gmx.com> <CAKuJGC_pagdiUy-csrK4G1KL01iib+CVdtW5wwd8dsiWTjrysQ@mail.gmail.com>
 <0bc63e4d-1176-9534-01ac-5cf6292bccdd@gmx.com> <CAKuJGC8vE+vdTXf-WKuMfP-Sd=hiNmaCsm_1=vTQi7ngBh3kCQ@mail.gmail.com>
 <CAKuJGC_cwYHe_Y2bEADNR0UGrB7kncE-N5vrE=CRvMJ8g9726Q@mail.gmail.com>
 <c8b15c71-1557-85d5-6cbf-06cbaef369e0@gmx.com> <CAKuJGC-ZyN-HS_rn4fvC485pA2uBtL+qSQ-Mn5sEtjLENcHgxw@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Fri, 3 Nov 2017 12:02:38 +0530
Message-ID: <CAKuJGC-7zZXHNzH3_QDtepretKP+u9tjnJ6et4CZU8q3Vh94yA@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.h:3457!
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, the patch works.  Enabled both CONFIG_BTRFS_FS_CHECK_INTEGRITY
and CONFIG_BTRFS_FS_RUN_SANITY_TESTS.
And applied above patch. This method also resolved the issue. thanks.
----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org
