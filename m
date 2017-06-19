Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:34642 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752478AbdFSWKP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Jun 2017 18:10:15 -0400
Received: by mail-qt0-f182.google.com with SMTP id v20so5187315qtg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jun 2017 15:10:15 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 20 Jun 2017 01:09:34 +0300
Message-ID: <CAGqmi75fwUz4CcktjTm=KFSUSpmqeb0RDQrAgjL39KGqQMs=rQ@mail.gmail.com>
Subject: RFC: Compression - calculate entropy for data set
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, for last several days i try work on entropy calculation that can
be usable in btrfs compression code (for detect bad compressible
data),

I've implemented:
- avg meaning (Problems with accuracy)
- shannon entropy
- shannon entropy with only integer logic (Accuracy compared to float
shannon +-0.5%)

All writen on C with C++ inserts and can be easy ported to kernel code
if needed.
Repo there:
https://github.com/Nefelim4ag/Entropy_Calculation

It will be great if someone has an interest in profiling and
performance tests of that

Because my stupid tests with ~$ time <binary> and 8MB of test data
Shows that lzo with level 1-6 are fastest way to detect if data are compressible
And that integer shannon entropy are much faster (in 5 times) way in
compare to any gzip level.

Thanks!

P.S.
I get this idea from:
https://btrfs.wiki.kernel.org/index.php/Project_ideas
 - Compression enhancements
    - heuristics -- try to learn in a simple way how well the file
data compress, or not

-- 
Have a nice day,
Timofey.
