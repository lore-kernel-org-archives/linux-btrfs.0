Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34145 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbbLCMJ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Dec 2015 07:09:29 -0500
Received: by lbbcs9 with SMTP id cs9so298490lbb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Dec 2015 04:09:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$6405b$7a197e29$8d0a71a9$2a5649b6@cox.net>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
	<pan$101f2$e235cddd$fea951cb$dcf70182@cox.net>
	<CAK5rZE6-SMfseAfEu1GxLrgYNOBMhNbiQ8tqWVWUr6dFDL8OKw@mail.gmail.com>
	<565F028C.6000707@gmail.com>
	<pan$6405b$7a197e29$8d0a71a9$2a5649b6@cox.net>
Date: Thu, 3 Dec 2015 14:09:27 +0200
Message-ID: <CAK5rZE6Y8Pa68yMDr-a-zNqFdb8VM+t9jv+HwxGck8SJ_vCR+A@mail.gmail.com>
Subject: Re: compression disk space saving - what are your results?
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> On a side note, I really wish BTRFS would just add LZ4 support.  It's a
>> lot more deterministic WRT decompression time than LZO, gets a similar
>> compression ratio, and runs faster on most processors for both
>> compression and decompression.

Relative ratios according to
http://catchchallenger.first-world.info//wiki/Quick_Benchmark:_Gzip_vs_Bzip2_vs_LZMA_vs_XZ_vs_LZ4_vs_LZO

Compressed size
gzip (1) - lzo (1.4) - lz4 (1.4)

Compression Time
gzip (5) - lzo (1) - lz4 (0.8)

Decompression Time
gzip (9) - lzo (4) - lz4 (1)

Compression Memory
gzip (1) - lzo (2) - lz4 (20)

Decompression Memory
gzip (1) - lzo (2) - lz4 (130). Yes 130! not a typo.

But there is a note:
Note: lz4 it's the program using this size, the
code for internal lz4 use very less memory.

However, I could not find any better apples to apples
comparison.

If lz4's real memory consumption is in orders of lzo,
than it looks good.
