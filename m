Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48378 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753154AbdHKNUg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Aug 2017 09:20:36 -0400
Subject: Re: [PATCH v5 2/5] lib: Add zstd modules
To: Hugo Mills <hugo@carfax.org.uk>, Eric Biggers <ebiggers3@gmail.com>,
        Nick Terrell <terrelln@fb.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, <kernel-team@fb.com>,
        <squashfs-devel@lists.sourceforge.net>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023553.3200875-3-terrelln@fb.com>
 <20170810083017.GA10462@zzz.localdomain>
 <0ceeccb4-1a0f-cacb-dd2b-2913e1cf73ab@fb.com>
 <20170810192506.GF7140@carfax.org.uk>
From: Chris Mason <clm@fb.com>
Message-ID: <6cd9c58a-1bcb-02c2-9329-c5acc0e79121@fb.com>
Date: Fri, 11 Aug 2017 09:20:10 -0400
MIME-Version: 1.0
In-Reply-To: <20170810192506.GF7140@carfax.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/10/2017 03:25 PM, Hugo Mills wrote:
> On Thu, Aug 10, 2017 at 01:41:21PM -0400, Chris Mason wrote:
>> On 08/10/2017 04:30 AM, Eric Biggers wrote:
>>>
>>> Theses benchmarks are misleading because they compress the whole file as a
>>> single stream without resetting the dictionary, which isn't how data will
>>> typically be compressed in kernel mode.  With filesystem compression the data
>>> has to be divided into small chunks that can each be decompressed independently.
>>> That eliminates one of the primary advantages of Zstandard (support for large
>>> dictionary sizes).
>>
>> I did btrfs benchmarks of kernel trees and other normal data sets as
>> well.  The numbers were in line with what Nick is posting here.
>> zstd is a big win over both lzo and zlib from a btrfs point of view.
>>
>> It's true Nick's patches only support a single compression level in
>> btrfs, but that's because btrfs doesn't have a way to pass in the
>> compression ratio.  It could easily be a mount option, it was just
>> outside the scope of Nick's initial work.
> 
>     Could we please not add more mount options? I get that they're easy
> to implement, but it's a very blunt instrument. What we tend to see
> (with both nodatacow and compress) is people using the mount options,
> then asking for exceptions, discovering that they can't do that, and
> then falling back to doing it with attributes or btrfs properties.
> Could we just start with btrfs properties this time round, and cut out
> the mount option part of this cycle.
> 
>     In the long run, it'd be great to see most of the btrfs-specific
> mount options get deprecated and ultimately removed entirely, in
> favour of attributes/properties, where feasible.
> 

It's a good point, and as was commented later down I'd just do mount -o 
compress=zstd:3 or something.

But I do prefer properties in general for this.  My big point was just 
that next step is outside of Nick's scope.

-chris

