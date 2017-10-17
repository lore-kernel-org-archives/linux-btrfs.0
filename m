Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:57185 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754858AbdJQLnh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 07:43:37 -0400
Received: by mail-wr0-f173.google.com with SMTP id r79so1323475wrb.13
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Oct 2017 04:43:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
 <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
 <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com> <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
 <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com> <20171017011443.bupcsskm7joc73wb@angband.pl>
 <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
From: Zoltan <zoltan1980@gmail.com>
Date: Tue, 17 Oct 2017 13:42:55 +0200
Message-ID: <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Adam Borowski <kilobyte@angband.pl>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Tue, Oct 17, 2017 at 1:26 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> I forget sometimes that people insist on storing large volumes of data on
> unreliable storage...

In my opinion the unreliability of the storage is the exact reason for
wanting to use raid1. And I think any problem one encounters with an
unreliable disk can likely happen with more reliable ones as well,
only less frequently, so if I don't feel comfortable using raid1 on an
unreliable medium then I wouldn't trust it on a more reliable one
either.

Zoltan
