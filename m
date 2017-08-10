Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:33566 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753017AbdHJTzE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 15:55:04 -0400
Subject: Re: [PATCH v5 2/5] lib: Add zstd modules
To: Hugo Mills <hugo@carfax.org.uk>, Chris Mason <clm@fb.com>,
        Eric Biggers <ebiggers3@gmail.com>, Nick Terrell <terrelln@fb.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, kernel-team@fb.com,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023553.3200875-3-terrelln@fb.com>
 <20170810083017.GA10462@zzz.localdomain>
 <0ceeccb4-1a0f-cacb-dd2b-2913e1cf73ab@fb.com>
 <20170810192506.GF7140@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <aaaede17-3493-d527-5d9b-cd105865ca24@gmail.com>
Date: Thu, 10 Aug 2017 15:54:59 -0400
MIME-Version: 1.0
In-Reply-To: <20170810192506.GF7140@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-10 15:25, Hugo Mills wrote:
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
AFAIUI, the intent is to extend the compression type specification for 
both the mount options and the property, not to add a new mount option. 
I think we all agree that `mount -o compress=zstd3` is a lot better than 
`mount -o compress=zstd,compresslevel=3`.
> 
>     In the long run, it'd be great to see most of the btrfs-specific
> mount options get deprecated and ultimately removed entirely, in
> favour of attributes/properties, where feasible.
Are properties set on the root subvolume inherited properly?  Because 
unless they are, we can't get the same semantics.

Two other counter arguments on completely removing BTRFS-specific mount 
options:
1. It's a lot easier and a lot more clearly defined to change things 
that affect global behavior of the FS by a remount than having to 
iterate everything in the FS to update properties.  If I'm disabling 
autodefrag, I'd much rather just `mount -o remount,noautodefrag` than 
`find / -xdev -exec btrfs property set \{\} autodefrag false`, as the 
first will take effect for everything simultaneously and run 
exponentially quicker.
2. There are some things that don't make sense as per-object settings or 
are otherwise nonsensical on objects.  Many, but not all, of the BTRFS 
specific mount options fall into this category IMO, with the notable 
exception of compress[-force], [no]autodefrag, [no]datacow, and 
[no]datasum.  Some other options do make sense as properties of the 
filesystem (commit, flushoncommit, {inode,space}_cache, max_inline, 
metadata_ratio, [no]ssd, and [no]treelog are such options), but many are 
one-off options that affect behavior on mount (like skip_balance, 
clear_cache, nologreplay, norecovery, usebbackuproot, and subvol).
