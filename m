Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:35447 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752449AbdFTJN7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 05:13:59 -0400
Received: by mail-qt0-f169.google.com with SMTP id w1so128251635qtg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 02:13:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi75fwUz4CcktjTm=KFSUSpmqeb0RDQrAgjL39KGqQMs=rQ@mail.gmail.com>
References: <CAGqmi75fwUz4CcktjTm=KFSUSpmqeb0RDQrAgjL39KGqQMs=rQ@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 20 Jun 2017 12:13:17 +0300
Message-ID: <CAGqmi75snUUa3MzBVzu6wcWV6qzPpOBmCU-Ug4xGBVuz_E5gEg@mail.gmail.com>
Subject: Re: RFC: Compression - calculate entropy for data set
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-06-20 1:09 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
> Hi, for last several days i try work on entropy calculation that can
> be usable in btrfs compression code (for detect bad compressible
> data),
>
> I've implemented:
> - avg meaning (Problems with accuracy)
> - shannon entropy
> - shannon entropy with only integer logic (Accuracy compared to float
> shannon +-0.5%)
>
> All writen on C with C++ inserts and can be easy ported to kernel code
> if needed.
> Repo there:
> https://github.com/Nefelim4ag/Entropy_Calculation
>
> It will be great if someone has an interest in profiling and
> performance tests of that
>
> Because my stupid tests with ~$ time <binary> and 8MB of test data
> Shows that lzo with level 1-6 are fastest way to detect if data are compressible
> And that integer shannon entropy are much faster (in 5 times) way in
> compare to any gzip level.
>
> Thanks!
>
> P.S.
> I get this idea from:
> https://btrfs.wiki.kernel.org/index.php/Project_ideas
>  - Compression enhancements
>     - heuristics -- try to learn in a simple way how well the file
> data compress, or not
>
> --
> Have a nice day,
> Timofey.

Update:
Rewrite that on pure C, now performance for 10000 times of run on
128KB data (64kb random, 64kb zeroes)
---
avg_meaning_entropy
10s
---
shannon_entropy
23s
---
shannon_int_entropy
14s
---
gzip -f -k -3 ./indata.bin
43s
---
lzop -f -k -3 ./indata.bin
18s

Thanks.
-- 
Have a nice day,
Timofey.
