Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34247 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755220AbdESVP7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 17:15:59 -0400
Received: by mail-qk0-f193.google.com with SMTP id u75so11773742qka.1
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 14:15:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d42097e1-2deb-eb2a-9cae-ad9aa8725bde@bouton.name>
References: <20170519133835.27843-1-nefelim4ag@gmail.com> <20170519133835.27843-3-nefelim4ag@gmail.com>
 <6a1f17d5-3cc8-f5c0-36af-39b41eebc426@bouton.name> <d42097e1-2deb-eb2a-9cae-ad9aa8725bde@bouton.name>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 20 May 2017 00:15:18 +0300
Message-ID: <CAGqmi75+vNVsz1CjOVhrhmvBCQAK82Cs0G899Jzw3fr2s5Sifg@mail.gmail.com>
Subject: Re: [PATCH 2/3] Btrfs: lzo compression must free at least PAGE_SIZE
To: Lionel Bouton <lionel-subscription@bouton.name>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-05-19 23:19 GMT+03:00 Lionel Bouton <lionel-subscription@bouton.name>:
> I was too focused on other problems and having a fresh look at what I
> wrote I'm embarrassed by what I read.
> Used pages for a given amount of data should be (amount / PAGE_SIZE) +
> ((amount % PAGE_SIZE) == 0 ? 0 : 1) this seems enough of a common thing
> to compute that the kernel might have a macro defined for this.

If i understand the code correctly, the logic of comparing the size of
input/output by bytes is enough (IMHO) for skipping the compression of
non-compressible data, and as btrfs uses PAGE_SIZE as a data cluster
size (and if i understand correctly it's minimum IO size), the logic
of that can be improved in case when compressed data use 126978 <
compressed_size < 131072.
The easiest way to improve that case, i think, is making the
compressed size bigger by PAGE_SIZE.

JFYI:
Once I've read on the list that btrfs don't compress data, if data are
less then PAGE_SIZE because it's useless (i didn't find that in the
code, so i think that i don't fully understand code of compress
routine)

After some time i got a idea that if btrfs determines store data
compressed or not by comparing input/output size of data (i.e. if
compressed size is bigger in compare to input data, don't store
compressed version), this logic can be improved by also checking if
compression profit is more then PAGE_SIZE, because if it's not,
compressed data will pass check and comsume the same amount of space
and as a result will not show any gain.

-- 
Have a nice day,
Timofey.
