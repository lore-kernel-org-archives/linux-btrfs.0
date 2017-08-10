Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48950 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752658AbdHJRlo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 13:41:44 -0400
Subject: Re: [PATCH v5 2/5] lib: Add zstd modules
To: Eric Biggers <ebiggers3@gmail.com>, Nick Terrell <terrelln@fb.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, <kernel-team@fb.com>,
        <squashfs-devel@lists.sourceforge.net>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023553.3200875-3-terrelln@fb.com>
 <20170810083017.GA10462@zzz.localdomain>
From: Chris Mason <clm@fb.com>
Message-ID: <0ceeccb4-1a0f-cacb-dd2b-2913e1cf73ab@fb.com>
Date: Thu, 10 Aug 2017 13:41:21 -0400
MIME-Version: 1.0
In-Reply-To: <20170810083017.GA10462@zzz.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/10/2017 04:30 AM, Eric Biggers wrote:
> On Wed, Aug 09, 2017 at 07:35:53PM -0700, Nick Terrell wrote:

>> The memory reported is the amount of memory the compressor requests.
>>
>> | Method   | Size (B) | Time (s) | Ratio | MB/s    | Adj MB/s | Mem (MB) |
>> |----------|----------|----------|-------|---------|----------|----------|
>> | none     | 11988480 |    0.100 |     1 | 2119.88 |        - |        - |
>> | zstd -1  | 73645762 |    1.044 | 2.878 |  203.05 |   224.56 |     1.23 |
>> | zstd -3  | 66988878 |    1.761 | 3.165 |  120.38 |   127.63 |     2.47 |
>> | zstd -5  | 65001259 |    2.563 | 3.261 |   82.71 |    86.07 |     2.86 |
>> | zstd -10 | 60165346 |   13.242 | 3.523 |   16.01 |    16.13 |    13.22 |
>> | zstd -15 | 58009756 |   47.601 | 3.654 |    4.45 |     4.46 |    21.61 |
>> | zstd -19 | 54014593 |  102.835 | 3.925 |    2.06 |     2.06 |    60.15 |
>> | zlib -1  | 77260026 |    2.895 | 2.744 |   73.23 |    75.85 |     0.27 |
>> | zlib -3  | 72972206 |    4.116 | 2.905 |   51.50 |    52.79 |     0.27 |
>> | zlib -6  | 68190360 |    9.633 | 3.109 |   22.01 |    22.24 |     0.27 |
>> | zlib -9  | 67613382 |   22.554 | 3.135 |    9.40 |     9.44 |     0.27 |
>>
> 
> Theses benchmarks are misleading because they compress the whole file as a
> single stream without resetting the dictionary, which isn't how data will
> typically be compressed in kernel mode.  With filesystem compression the data
> has to be divided into small chunks that can each be decompressed independently.
> That eliminates one of the primary advantages of Zstandard (support for large
> dictionary sizes).

I did btrfs benchmarks of kernel trees and other normal data sets as 
well.  The numbers were in line with what Nick is posting here.  zstd is 
a big win over both lzo and zlib from a btrfs point of view.

It's true Nick's patches only support a single compression level in 
btrfs, but that's because btrfs doesn't have a way to pass in the 
compression ratio.  It could easily be a mount option, it was just 
outside the scope of Nick's initial work.

-chris



