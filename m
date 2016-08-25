Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35421 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753968AbcHYXFJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 19:05:09 -0400
Received: by mail-oi0-f51.google.com with SMTP id 4so88435018oih.2
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 16:04:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <392b5e39596611f0ec15501dbf300c0e@durkon.lan>
References: <efe09b37f04cbc7754f6c6d84c9070f0@durkon.lan> <CAJCQCtRuQvgTj-jj=k8Ehsnq0uEkbbzJJwRR6T16H+R4d6SeTw@mail.gmail.com>
 <392b5e39596611f0ec15501dbf300c0e@durkon.lan>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 25 Aug 2016 17:04:23 -0600
Message-ID: <CAJCQCtR=pjcCWYqpA=X5RG8RmpJ7Sk=hR-34obXyKjLw=JJcgg@mail.gmail.com>
Subject: Re: Switch raid mode without rebalance?
To: Gert Menke <gert@menke.ac>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 25, 2016 at 4:33 PM, Gert Menke <gert@menke.ac> wrote:

>> Such a switch doesn't exist, there's no way to define what files,
>> directories, or subvolumes, have what profiles.
>
> Well it kind of does - a running balance process seems to have just that
> effect, it's just not persistent (and has the side effect of, well,
> balancing the existing data).

No, it's not a file, directory or subvolume specific command. It
applies to a whole volume.


>>> How does btrfs
>>> find out which raid mode to use when writing new data?
>>
>>
>> That's kindof an interesting question. If you were to do 'btrfs
>> balance start -dconvert=single -mconvert=raid1' and very soon after
>> that do 'btrfs balance cancel' you'll end up with one or a few new
>> chunks with those profiles. When data is allocated to those chunks,
>> they will have those profile characteristics. When data is allocated
>> to old chunks that are still raid0, it will be raid0. The thing is,
>> you can't really tell or control what data will be placed in what
>> chunk. So it's plausible that some new data goes in old raid0 chunk,
>> and some old data goes in new single/raid1 chunks.
>
>
> I'm not quite familiar with the concept of a chunk here.

Chunk is the same thing as a block group. And it's a collection of
extents. Basically all addresses used by Btrfs internally are logical
addresses, they don't map to sectors or devices. It's the chunk tree
which lists the chunks, that does the mapping from logical address to
device and sector. A file will have one logical address in Btrfs, but
that logical address can be looked up and return multiple devices and
sectors for where the file is physically located. So the raid stuff
happens at the chunk stripe level.



> Are chunks allocated for new data, or is the unallocated space divided into
> chunks, too?

Allocation happens on demand. Empty chunks are supposed to
automatically be deallocated, depending on the kernel version.


> In the former case, when creating a new chunk, does btrfs just look into a
> random already existing chunk and copy the raid mode from there?

The profile is a function of a chunk. On a two device raid0 Btrfs
volume, you'd see something like this for the chunk tree:

chunk tree
leaf 20987904 items 5 free space 15626 generation 5 owner 3
fs uuid 44d6f5e9-6be0-4472-9357-02bf1b1c3d99
chunk uuid 183d3ff9-377d-4afe-8621-d8bafdf06cf9
item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
dev item devid 1 total_bytes 10737418240 bytes used 2155872256
dev uuid d8ecbb0b-5b8d-49f7-a33e-2e3f1dc8d240
item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16087 itemsize 98
dev item devid 2 total_bytes 10737418240 bytes used 2155872256
dev uuid d170bfba-8f7c-4154-8997-4d1117aeee32
item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 15975 itemsize 112
chunk length 8388608 owner 2 stripe_len 65536
type SYSTEM|RAID1 num_stripes 2
stripe 0 devid 2 offset 1048576
dev uuid: d170bfba-8f7c-4154-8997-4d1117aeee32
stripe 1 devid 1 offset 20971520
dev uuid: d8ecbb0b-5b8d-49f7-a33e-2e3f1dc8d240
item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 29360128) itemoff 15863 itemsize 112
chunk length 1073741824 owner 2 stripe_len 65536
type METADATA|RAID1 num_stripes 2
stripe 0 devid 2 offset 9437184
dev uuid: d170bfba-8f7c-4154-8997-4d1117aeee32
stripe 1 devid 1 offset 29360128
dev uuid: d8ecbb0b-5b8d-49f7-a33e-2e3f1dc8d240
item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 1103101952) itemoff 15751 itemsize 112
chunk length 2147483648 owner 2 stripe_len 65536
type DATA|RAID0 num_stripes 2
stripe 0 devid 2 offset 1083179008
dev uuid: d170bfba-8f7c-4154-8997-4d1117aeee32
stripe 1 devid 1 offset 1103101952
dev uuid: d8ecbb0b-5b8d-49f7-a33e-2e3f1dc8d240


Here you can see there are three chunks, system, metadata, data.
System and metadata chunks have profile raid1, you can see they have
two stripes each (stripe 0 and stripe 1) which are mirrors on two
different devices. And data chunk is profile raid0, also two stripes
which are alternating stripe elements of 64KiB each across the two
devices.

If I add another file, I'll get another data chunk allocated, and
it'll be added to the chunk tree as item 5, and it'll have its own
physical  offset on each device.

item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 3250585600) itemoff 15639 itemsize 112
chunk length 2147483648 owner 2 stripe_len 65536
type DATA|RAID0 num_stripes 2
stripe 0 devid 2 offset 2156920832
dev uuid: d170bfba-8f7c-4154-8997-4d1117aeee32
stripe 1 devid 1 offset 2176843776
dev uuid: d8ecbb0b-5b8d-49f7-a33e-2e3f1dc8d240

That chunk is just a collection of data extents.

So the point now is, in order to change the profile of a chunk, it has
to be completely rewritten.

> In the latter case, could you (in theory) change the raid mode of all empty
> chunks only?

Nope. In theory, there are no empty chunks.

To do what you want is planned, with no work picked up yet as far as I
know. It'd probably involve some work to associate something like an
xattr to let the allocator know which profile the user wants for the
data, and then to allocate it to the proper existing chunk or create a
new chunk with that profile as needed.


-- 
Chris Murphy
