Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:41247 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751569AbeERJmb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 05:42:31 -0400
Received: by mail-ot0-f173.google.com with SMTP id t1-v6so8394707oth.8
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 02:42:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca> <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Fri, 18 May 2018 05:42:30 -0400
Message-ID: <CA+X5Wn51gEdshKO+g-o+UQtjTtMsBwV02ziyHjOQ2R4Anh=Dzw@mail.gmail.com>
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Steve Leung <sjleung@shaw.ca>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 18, 2018 at 1:49 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> And btrfs check doesn't report the same problem as the default original
> mode doesn't have such check.
>
> Please also post the result of "btrfs check --mode=lowmem /dev/sda1"

Are you saying "--mode=lowmem" does more checks than without it?  "man
btrfs check" says it's experimental and the difference is just
original is unoptimized regarding memory consumption and can run out
of memory, and low memory addresses this with increased IO cost from
re-reading blocks increasing run time.  It doesn't indicate lowmem is
a better check.
