Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53563 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751017AbdGaVak (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 17:30:40 -0400
From: Nick Terrell <terrelln@fb.com>
To: Phillip Lougher <phillip.lougher@gmail.com>
CC: "Austin S . Hemmelgarn" <ahferroin7@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>, Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.cz>,
        SquashFS developers <squashfs-devel@lists.sourceforge.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Sean Purcell" <me@seanp.xyz>
Subject: Re: [PATCH v3 4/4] squashfs: Add zstd support
Date: Mon, 31 Jul 2017 21:30:08 +0000
Message-ID: <65F25A58-E706-4D93-847E-1E4016E7367F@fb.com>
References: <20170720212743.3351201-1-terrelln@fb.com>
 <20170720212743.3351201-5-terrelln@fb.com>
 <CAB3wodemv=aP-9chLo5VyN3WC+QNpgRNr1=iPU5ZxmZ37Sk-rw@mail.gmail.com>
In-Reply-To: <CAB3wodemv=aP-9chLo5VyN3WC+QNpgRNr1=iPU5ZxmZ37Sk-rw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/30/17, 6:50 PM, "Phillip Lougher" <phillip.lougher@gmail.com> wrote:
> On Thu, Jul 20, 2017 at 10:27 PM, Nick Terrell <terrelln@fb.com> wrote:
>> Add zstd compression and decompression support to SquashFS. zstd is a
>> great fit for SquashFS because it can compress at ratios approaching xz,
>> while decompressing twice as fast as zlib. For SquashFS in particular,
>> it can decompress as fast as lzo and lz4. It also has the flexibility
>> to turn down the compression ratio for faster compression times.
>
> Hi Nick,
>
> This patch (and none of the previous versions) is showing up on
> squashfs-devel@lists.sourceforge.net.  I also think you should have
> emailed me directly as a courtesy, as I'm the Squashfs author and
> maintainer.

Sorry about that Phillip, it was an oversight on my part. I've added you to
the CC list going forward, and have subscribed to the mailing list.

>> | Method>> | Ratio | Compression MB/s | Decompression MB/s |
>> |----------------|-------|------------------|--------------------|
>> | gzip>>   |  2.92 |>>>   15 |>>>>128 |
>> | lzo>>>|  2.64 |>>>  9.5 |>>>>217 |
>> | lz4>>>|  2.12 |>>>   94 |>>>>218 |
>> | xz>>> |  3.43 |>>>  5.5 |>>>> 35 |
>> | xz 256 KB>  |  3.53 |>>>  5.4 |>>>> 40 |
>> | zstd 1>> |  2.71 |>>>   96 |>>>>210 |
>> | zstd 5>> |  2.93 |>>>   69 |>>>>198 |
>> | zstd 10>>|  3.01 |>>>   41 |>>>>225 |
>> | zstd 15>>|  3.13 |>>> 11.4 |>>>>224 |
>> | zstd 16 256 KB |  3.24 |>>>  8.1 |>>>>210 |
>
>
> Those numbers look good to me.
>
>>
>> This patch was written by Sean Purcell <me@seanp.xyz>, but I will be
>> taking over the submission process.
>>
>> [1] http://releases.ubuntu.com/16.10/
>> [2] https://github.com/facebook/zstd/blob/dev/contrib/linux-kernel/squashfs-benchmark.sh
>
> I can't find your patch that adds zstd to the user-land
> Squashfs-tools.  That would be handy to do any testing :-)
>
> Phillip

I'll include the squashfs-tools patch that Sean just posted in the next
version.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
