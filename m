Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:51265 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752793AbdJPQ6U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 12:58:20 -0400
Received: by mail-wr0-f180.google.com with SMTP id j14so3603726wre.8
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 09:58:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
 <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com> <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
From: Zoltan <zoltan1980@gmail.com>
Date: Mon, 16 Oct 2017 18:57:38 +0200
Message-ID: <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, Oct 16, 2017 at 1:53 PM, Austin S. Hemmelgarn wrote:

> you will need to scrub regularly to avoid data corruption

Is there any indication that a scrub is needed? Before actually doing
a scrub, is btrfs already aware that one of the devices did not
receive all data due to being unavailable for a brief time? If so,
which command shows this info in its output?

Additionally, how does btrfs scrub compare to btrfs balance
-dconvert=raid1,soft -mconvert=raid1,soft in this scenario? I would
suppose that if btrfs is aware that some data does not have a
replication count of 2, then a convert could fix that without a scrub
reading through the whole disk. On the other hand, while I would
expect btrfs scrub to find data with bad checksum, I would not expect
it do balance as well in order to achieve the desired replication
count of 2 for all data. So do I need to run both a scrub and a
convert, or is a scrub enough?

Thanks,

Zoltan
