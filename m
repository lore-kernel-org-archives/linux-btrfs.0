Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:44745 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750769AbdKWFZM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 00:25:12 -0500
Received: by mail-ot0-f170.google.com with SMTP id d27so15415517ote.11
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 21:25:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHzMYBQ7tsHFuHkJ5zjK6Wx0bD0XHp0TGti_uJNV5pz4ak7wJA@mail.gmail.com>
References: <CAHzMYBQ7tsHFuHkJ5zjK6Wx0bD0XHp0TGti_uJNV5pz4ak7wJA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 22 Nov 2017 22:25:11 -0700
Message-ID: <CAJCQCtQpCJc1h8qnLv6M_aMf-0q_9saNwCrNwt1HML1jFLHq8g@mail.gmail.com>
Subject: Re: btrfs restore corrupt file
To: Jorge Bastos <jorge.mrbastos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 22, 2017 at 12:18 PM, Jorge Bastos <jorge.mrbastos@gmail.com> wrote:
> Hello,
>
> While doing btrfs checksum testing I purposely corrupted a file and
> got the expect I/O error when trying to copy it, I also tested btrfs
> restore to see if I could recover a known corrupt file and it did copy
> it but there was no checksum error or warning. I used btrfs restore -v
>
> Is this expect behavior or should restore warn about checksum failures?
>
> Kernel used was 4.13.13,  btrfs-progs v4.13.2

I think it's expected. "The checks done by restore are less strict"
from the man page. Although it'd be nice if -v option at least could
flag such files as possibly being corrupt.

-- 
Chris Murphy
