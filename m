Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35281 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752819AbdDRNCo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 09:02:44 -0400
Received: by mail-lf0-f52.google.com with SMTP id 75so80560860lfs.2
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 06:02:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Tue, 18 Apr 2017 15:02:42 +0200
Message-ID: <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
Subject: Re: Btrfs/SSD
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/17/17, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> Regarding BTRFS specifically:
> * Given my recently newfound understanding of what the 'ssd' mount
> option actually does, I'm inclined to recommend that people who are
> using high-end SSD's _NOT_ use it as it will heavily increase
> fragmentation and will likely have near zero impact on actual device
> lifetime (but may _hurt_ performance).  It will still probably help with
> mid and low-end SSD's.

I'm trying to have a proper understanding of what "fragmentation" really
means for an ssd and interrelation with wear-leveling.

Before continuing lets remember:
Pages cannot be erased individually, only whole blocks can be erased.
The size of a NAND-flash page size can vary, and most drive have pages
of size 2 KB, 4 KB, 8 KB or 16 KB. Most SSDs have blocks of 128 or 256
pages, which means that the size of a block can vary between 256 KB
and 4 MB.
codecapsule.com/.../coding-for-ssds-part-2-architecture-of-an-ssd-and-benchmarking/

Lets continue:
Since block sizes are between 256k-4MB, data smaller than this will
"probably" will not be fragmented in a reasonably empty and trimmed
drive. And for a brand new ssd we may speak of contiguous series
of blocks.

However, as drive is used more and more and as wear leveling kicking in
(ie. blocks are remapped) the meaning of "contiguous blocks" will erode.
So any file bigger than a block size will be written to blocks physically apart
no matter what their block addresses says. But my guess is that accessing
device blocks -contiguous or not- are constant time operations. So it would
not contribute performance issues. Right? Comments?

So your the feeling about fragmentation/performance is probably related
with if the file is spread into less or more blocks. If # of blocks used
is higher than necessary (ie. no empty blocks can be found. Instead
lots of partially empty blocks have to be used increasing the total
# of blocks involved) then we will notice performance loss.

Additionally if the filesystem will gonna try something to reduce
the fragmentation for the blocks, it should precisely know where
those blocks are located. Then how about ssd block informations?
Are they available and do filesystems use it?

Anyway if you can provide some more details about your experiences
on this we can probably have better view on the issue.


> * Files with NOCOW and filesystems with 'nodatacow' set will both hurt
> performance for BTRFS on SSD's, and appear to reduce the lifetime of the
> SSD.

This and other experinces tell us it is still possible to "forge some
blocks of ssd". How could this be possible if there is wear-leveling?

Two alternatives comes to mind:

- If there is no empty (trimmed) blocks left on the ssd, it will have no
chance other than forging the block. How about its reserve blocks?
Are they exhausted too? Or are they only used as bad block replacements?

- No proper wear-levelling is accually done by the drive.

Comments?
