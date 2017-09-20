Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:46322 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdITWEy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 18:04:54 -0400
Received: by mail-io0-f175.google.com with SMTP id d16so6892873ioj.3
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 15:04:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <63fd4cdb-52d4-4aee-cc82-dbb7eba72a06@redhat.com>
References: <CAGqmi74kxPpkuYCBwfdyzxUKAHE6TP9x1FGDz0FURud21u=nOA@mail.gmail.com>
 <63fd4cdb-52d4-4aee-cc82-dbb7eba72a06@redhat.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 21 Sep 2017 01:04:04 +0300
Message-ID: <CAGqmi74r6FfC2KG8A5FaVTvDSNc7XLrV7SHULXVQ+A6a3U1uQg@mail.gmail.com>
Subject: Re: Does btrfs use crc32 for error correction?
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-19 19:51 GMT+03:00 Eric Sandeen <sandeen@redhat.com>:
> On 9/19/17 10:35 AM, Timofey Titovets wrote:
>> Stupid question:
>> Does btrfs use crc32 for error correction?
>> If no, why?
>>
>> (AFAIK if using CRC that possible to fix 1 bit flip)
>>
>> P.S. I try check that (i create image, create text file, flip bit, try
>> read and btrfs show IO-error)
>>
>> Thanks!
>
> I wasn't aware that crc32 could (in general) be used for single bit correction; I've read up on that, and it seems pretty cool.
>
> However, I don't think that the generator polynomial used in crc32c /can/ be used for error correction.  I just skimmed some reading, but that seems to be the case if I understand it correctly.
>
> -Eric

That possible, but if i understood doc about CRC16 bit correction
correctly, that need some tricks (As example preprocess all possible
bit flips and have a map of that) for fast find bit error.
Also in theory for CRC32C that possible with some state machine, to
move algo backward and forward over data.

I also check [1], so CRC32C (for our case) have hamming distance about 4.
So CRC32 in theory can fix up to HD-1 ~= 3 bit (If i understand all
things correctly);

So that possible to just brute force over data and flip 1-3 bit, and
try check if CRC fixed %)
In theory that safe for 1-2 bit error (Because again HD for input
data) (Proof of concept[2]).

Thanks.

1. https://users.ece.cmu.edu/~koopman/networks/dsn02/dsn02_koopman.pdf
2. https://github.com/Nefelim4ag/CRC32C_AND_8Byte_parity/commit/cb0fe76eac2ff036468bbc5ea75ebc06cb1e9928

-- 
Have a nice day,
Timofey.
