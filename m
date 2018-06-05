Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35407 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbeFEA1L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2018 20:27:11 -0400
Received: by mail-oi0-f51.google.com with SMTP id e8-v6so469278oii.2
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2018 17:27:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f790eb48-480c-5798-8b75-847da22b8623@gmx.com>
References: <CA+X5Wn6yTE5+U16fXZZHFrAeybXUDrwjk3DdOJU+OG9qXgFPEw@mail.gmail.com>
 <f790eb48-480c-5798-8b75-847da22b8623@gmx.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Mon, 4 Jun 2018 20:27:10 -0400
Message-ID: <CA+X5Wn5H9643dWbw-YoQ_tLy7Az=EBNLrs1CnDZVv12yOOjrQQ@mail.gmail.com>
Subject: Re: Questions from aspiring btrfs mini-debugger/mini-developer
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 28, 2018 at 8:48 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> On 2018年05月28日 17:21, james harvey wrote:
>> #29, through btrfs-tree-debug, is:
>>
>>         item 49 key (71469 EXTENT_DATA 3768320) itemoff 13232 itemsize 53
>>                 generation 218 type 1 (regular)
>>                 extent data disk byte 2373160960 nr 8384512
>>                 extent data offset 3764224 nr 425984 ram 8384512
>>                 extent compression 0 (none)
>>
>> Its extents without a data offset (i.e. filefrag #30) look like:
>>
>>         item 50 key (71469 EXTENT_DATA 4194304) itemoff 13179 itemsize 53
>>                 generation 310 type 1 (regular)
>>                 extent data disk byte 2445152256 nr 49152
>>                 extent data offset 0 nr 131072 ram 131072
>>                 extent compression 2 (lzo)
>>
>> So, item 49 is saying there's 8,384,512 bytes on disk, but for this
>> file extent, only read starting 3,764,224 into the extent_data, and
>> only read 425,984 bytes?
>
> Yep, reading from on-disk logical address 2373160960 + 3764224, len 425984.
>
>>  This is a snapshotted file.  At first, I was
>> thinking this might mean most of this extent had changed, but 425,984
>> bytes in the "middle" were the same, so btrfs was re-using that
>> portion.  Is that's why data_offset is used?
>
> Yep.

Thanks for taking all the time to respond!  Been working through all
this (and some other things) since your response.  Few follow-up
questions.

Can a compressed COW file wind up with an offset, like this hypothetical output:

         item 50 key (71469 EXTENT_DATA 4194304) itemoff 13179 itemsize 53
                 generation 310 type 1 (regular)
                 extent data disk byte 2445152256 nr 49152
                 extent data offset 4096 nr 65536 ram 131072
                 extent compression 2 (lzo)

I checked my main volume, and don't see any with compression and an
offset.  So, I'm thinking it might not be allowed.

If it is allowed, things get a bit confusing.  Is the offset for
on-disk (compressed) data?  Would it be reading from on-disk logical
address 2445152256  + 4096, len 65536 of the compressed data?

Or, is the offset for in-memory (uncompressed) data?  If this is the case, un

But, with it being on the second line here (maybe that's just for line
length though), and being referred to as btrfs_file_extent_offset
rather than btrfs_file_extent_***disk****_offset, it makes me think
offset might always be an in memory (uncompressed) offset.

With checksums being on 4k blocks, in theory, it seems to me like
on-disk offsetting should be able to happen.


>> Am I right that preallocated means no data has actually been written
>> there?
>
> Yes, but space must be allocated for later possible write.
> That's why we call it pre-allocated.

Ahh, I was misunderstanding pre-allocated to mean before allocation.


>> Given an extent_buffer, btrfs_item, slot, and btrfs_file_extent_item,
>> if the extent type is BTRFS_FILE_EXTENT_INLINE, how would one get the
>> on-disk (so if compressed, in compressed format) data?
>
> Read from the leaf.
> Just as the name inline, the data directly recorded into the leaf, and
> there is no need to use disk_bytenr.
> In fact starting from the offset of where disk_bytenr should be, inlined
> data is recorded there directly.
>
>>  With
>> non-inline, non-prealloc extents, I'm using bytenr as location and
>> num_bytes as length, and code based off btrfs-map-logical, which winds
>> up using read_extent_data with a mirror number argument, which uses
>> btrfs_map_block() on that logical address and mirror and pread64() to
>> do the read.  For inline data, there's no logical address.

Sorry, my question wasn't clear.  Assuming its mirrored, I was
wondering how to get both copies of the metadata, which would give
both copies of the inline data, so the mirrored data could be
compared.  I've since realized that since it's in the metadata, the
metadata checksumming which (I think) can't be turned off will cover
it.  So, there's no need to examine these whatsoever in the context of
checking for mismatched mirrored data.  A NOCOW/NODATASUM flag on the
inode would be irrelevant.  Am I right here?

Does scrub cover inline data marked NOCOW/NODATASUM?
