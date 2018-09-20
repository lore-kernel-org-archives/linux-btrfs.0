Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45175 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbeITPWR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 11:22:17 -0400
Received: by mail-ot1-f66.google.com with SMTP id a19-v6so8752136otl.12
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 02:39:42 -0700 (PDT)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id x61-v6sm7551839ota.39.2018.09.20.02.39.40
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Sep 2018 02:39:40 -0700 (PDT)
Received: by mail-oi0-f49.google.com with SMTP id c190-v6so7774344oig.6
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 02:39:40 -0700 (PDT)
MIME-Version: 1.0
References: <20180918153348.7723-1-timofey.titovets@synesis.ru> <CAEtw4r1UaR1ydbF-YNbiifhTtJ8M2kK=xpV0QYFMTjZcn=Nydw@mail.gmail.com>
In-Reply-To: <CAEtw4r1UaR1ydbF-YNbiifhTtJ8M2kK=xpV0QYFMTjZcn=Nydw@mail.gmail.com>
From: Timofey Titovets <timofey.titovets@synesis.ru>
Date: Thu, 20 Sep 2018 12:39:03 +0300
Message-ID: <CAGqmi74eV3ER+tF3g7EzDfOy5=2pFOVt0B_BSeSGyAkwf70=SA@mail.gmail.com>
Subject: Re: [PATCH V5 RESEND] Btrfs: enchanse raid1/10 balance heuristic
To: floyd.net@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

чт, 20 сент. 2018 г. в 12:05, Peter Becker <floyd.net@gmail.com>:
>
> i like the idea.
> do you have any benchmarks for this change?
>
> the general logic looks good for me.

https://patchwork.kernel.org/patch/10137909/

>
> Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
>
> Benchmark summary (arithmetic mean of 3 runs):
> Mainline Patch
> --------------------------------------------------------------
> RAID1 | 18.9 MiB/s | 26.5 MiB/s
> RAID10 | 30.7 MiB/s | 30.7 MiB/s


> fio configuration:
> [global]
> ioengine=libaio
> buffered=0
> direct=1
> bssplit=32k/100
> size=8G
> directory=/mnt/
> iodepth=16
> time_based
> runtime=900
>
> [test-fio]
> rw=randread
>
> All tests were run on 4 HDD btrfs filesystem in a VM with 4 Gb
> of ram on idle host. Full results attached to the email.

Also:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg71758.html
- - -
So, IIRC its works at least.
