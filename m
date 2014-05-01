Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29243 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225AbaEAPRY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 May 2014 11:17:24 -0400
Message-ID: <5362659D.3030003@fb.com>
Date: Thu, 1 May 2014 11:17:49 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Jan Kasiak <j.kasiak@gmail.com>, <bo.li.liu@oracle.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs checksum
References: <CAD15GZfSy0QWzpNQ2X2_3jUMBMV-WN4obAsnHH=Ea9xt-BEA7w@mail.gmail.com>
In-Reply-To: <CAD15GZfSy0QWzpNQ2X2_3jUMBMV-WN4obAsnHH=Ea9xt-BEA7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/01/2014 12:16 AM, Jan Kasiak wrote:
> Is there a design/technical reason behind btrfs using checksums
> separately per block, versus checksumming into a merkle tree?

We're using crc32c, which isn't suitable for detecting malicious data in 
general.  The goal was just to find blocks that were not correctly 
returned by the storage.  But, more below:

>
> Where I'm coming from: there's a Linux kernel device mapper module
> called dm-verity, which let's you verify the contents of a block
> device using a merkle tree (at mount time you provide the root hash).
> For my project, I'm modifying the module to enable write support, but
> in order to maintain consistency in the event of a power failure, I
> have to do the equivalent of data journaling to a circular log (so I
> end up writing data twice).
>
> Where I'm going with this: I've been looking into what improvements
> could be made if this were implemented at the filesystem level, and
> btrfs looks like a good candidate. But it already has a checksumming
> scheme, which is incompatible with a merkle tree, and would be
> redundant if a merkle tree would be implemented as well. (zfs has a
> merkle tree, but from what I can tell, it doesn't expose the root hash
> to the user)
>
> What the example use case is: you want to detect malicious data
> tampering across the entire file system, so at mount time you provide
> the merkle tree root hash. You get back an updated version of the root
> hash when you unmount, which you store in a secure place until the
> next time you mount the filesystem. You can detect if anyone modifies
> your data in between mounts, and also if they modify the underlying
> storage while the filesystem is mounted.

We're actively looking into schemes to detect malicious changes to the 
FS data.  A merkle tree could actually work fairly well.  The part I was 
missing the last time I thought about this was the data blocks.

I was thinking that we'd have to include the checksum of the data blocks 
in the combined crc of the leaves in the filesystem tree.

But if we keep the crc tree (using stronger crcs instead), we can just 
do the merkle on the crc tree and the regular metadata blocks separately.

I think the biggest problem is that we wouldn't be allowed to write a 
tree node until all of its children had been crc'd.  We've avoided these 
kinds of write ordering rules in the past because they tend to make 
things very difficult under memory pressure.

-chris
