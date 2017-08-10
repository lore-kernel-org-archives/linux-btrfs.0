Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:32961 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdHJO5F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 10:57:05 -0400
Subject: Re: [PATCH v5 2/5] lib: Add zstd modules
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: Eric Biggers <ebiggers3@gmail.com>, Nick Terrell <terrelln@fb.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, kernel-team@fb.com,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023553.3200875-3-terrelln@fb.com>
 <20170810083017.GA10462@zzz.localdomain>
 <ba64934b-0170-1718-fc1e-0acb462abb20@gmail.com>
Message-ID: <671b5ffb-0a8b-4e70-e3ac-9754cea54829@gmail.com>
Date: Thu, 10 Aug 2017 10:57:01 -0400
MIME-Version: 1.0
In-Reply-To: <ba64934b-0170-1718-fc1e-0acb462abb20@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-10 07:32, Austin S. Hemmelgarn wrote:
> On 2017-08-10 04:30, Eric Biggers wrote:
>> On Wed, Aug 09, 2017 at 07:35:53PM -0700, Nick Terrell wrote:
>>>
>>> It can compress at speeds approaching lz4, and quality approaching lzma.
>>
>> Well, for a very loose definition of "approaching", and certainly not 
>> at the
>> same time.  I doubt there's a use case for using the highest 
>> compression levels
>> in kernel mode --- especially the ones using zstd_opt.h.
> Large data-sets with WORM access patterns and infrequent writes 
> immediately come to mind as a use case for the highest compression level.
> 
> As a more specific example, the company I work for has a very large 
> amount of documentation, and we keep all old versions.  This is all 
> stored on a file server which is currently using BTRFS.  Once a document 
> is written, it's almost never rewritten, so write performance only 
> matters for the first write.  However, they're read back pretty 
> frequently, so we need good read performance.  As of right now, the 
> system is set to use LZO compression by default, and then when a new 
> document is added, the previous version of that document gets 
> re-compressed using zlib compression, which actually results in pretty 
> significant space savings most of the time.  I would absolutely love to 
> use zstd compression with this system with the highest compression 
> level, because most people don't care how long it takes to write the 
> file out, but they do care how long it takes to read a file (even if 
> it's an older version).
Also didn't think to mention this, but I could see the max level being 
very popular for use with SquashFS root filesystems used in LiveCD's. 
Currently, they have to decide between read performance and image size, 
while zstd would provide both.
