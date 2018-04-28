Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35683 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751331AbeD1UQ7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 16:16:59 -0400
Received: by mail-pg0-f65.google.com with SMTP id j11-v6so3830278pgf.2
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Apr 2018 13:16:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA7pwKOGS1MfwiO7AvfGPMP5ddhA6EMF+u3eZ+yE++RYvM=bfg@mail.gmail.com>
References: <CAMoswehF-GGV-yi_5fFnuvmZWVkeb71F7OcgOgr80r1F-=R_tg@mail.gmail.com>
 <CAA7pwKOGS1MfwiO7AvfGPMP5ddhA6EMF+u3eZ+yE++RYvM=bfg@mail.gmail.com>
From: Paul Richards <paul.richards@gmail.com>
Date: Sat, 28 Apr 2018 21:16:58 +0100
Message-ID: <CAMoswejKgjw+ktxc7iGX9m6F-n5Xq_=kzyLiR4xYUf2s=bYaDA@mail.gmail.com>
Subject: Re: fs/btrfs/ctree.h:1559 warnings
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28 April 2018 at 20:39, Patrik Lundquist <patrik.lundquist@gmail.com> wrote:
> On 28 April 2018 at 20:54, Paul Richards <paul.richards@gmail.com> wrote:
>>
>> Hi,
>> I recently upgraded from Linux 4.4.0 to 4.13.0 (Ubuntu 16.04 stock to
>> hwe kernel).
>>
>> Since then, I've noticed lots of btrfs warnings in dmesg (example at
>> the end).  I believe these warnings to be benign, and they relate to
>> my partition not being a multiple of 4KiB in size (I confirmed that
>> alignment is okay in this instance).
>
>
> Run btrfs rescue fix-device-size <device>.
>


Excellent, that looks like exactly what I need.  It's a shame my
google-fu didn't uncover it before I posted.

However, the "fix-device-size" sub-command is not available in
btrfs-tools (v4.4) from Ubuntu 16.04.  I guess my original question
still stands.  Is this warning safe for me to ignore?


I will likely upgrade to Ubuntu 18.04 in a few months at which point
I'll get a newer btrfs-tools, but until then can I safely ignore this
warning?
