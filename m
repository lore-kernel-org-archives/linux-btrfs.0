Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:33448 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425821AbdDVQpR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Apr 2017 12:45:17 -0400
Received: by mail-yw0-f172.google.com with SMTP id 203so60931893ywe.0
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Apr 2017 09:45:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com>
References: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 22 Apr 2017 10:45:15 -0600
Message-ID: <CAJCQCtS1GGZ1dAzc5kdk8nrj=k7nRbW5F53f+byGmgPXYMrBug@mail.gmail.com>
Subject: Re: Experiences with metadata balance/convert
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 21, 2017 at 4:26 AM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:

>
> == Thinking out of the box ==
>
> Technically, converting from DUP to single could also mean:
> * Flipping one bit in the block group type flags to 0 for each block
> group item
> * Flipping one bit in the chunk type flags and removing 1 stripe struct
> for each metadata chunk item
> * Removing the
> * Anything else?

This is in the realm of efficient file system pruning as a means of
fixing it. And the existing code is not pruning. It's clearly doing a
lot of complex balance computations first, second, and third, before
it even gets to the convert to single chunk task. Such a prune would
need to write out new chunk and dev trees, and then whatever nodes end
up pointing to those, maybe it's just the super blocks.

> How feasible would it be to write btrfs-progs style conversion to do this?

I can pretty much say it's not just a bit flip change because at the
very least you've got new CRCs to write for any changed node.

But looking at the chunk tree with btrfs-debug-tree -t 3 between
single and dup file systems:


    item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 15945 itemsize 80
        length 1073741824 owner 2 stripe_len 65536 type METADATA
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 1 sub_stripes 1
            stripe 0 devid 1 offset 20971520
            dev_uuid 6cd61505-9d47-4521-b980-95e9f20de920

    item 69 key (FIRST_CHUNK_TREE CHUNK_ITEM 298730913792) itemoff
10569 itemsize 112
        length 536870912 owner 2 stripe_len 65536 type METADATA|DUP
        io_align 65536 io_width 65536 sector_size 4096
        num_stripes 2 sub_stripes 1
            stripe 0 devid 1 offset 32250003456
            dev_uuid 1ee7f7aa-701d-42b7-b37f-b3356c277e7d
            stripe 1 devid 1 offset 32786874368
            dev_uuid 1ee7f7aa-701d-42b7-b37f-b3356c277e7d

Whatever on-disk item makes this DUP needs to be removed/changed, and
then it's an open question whether it's sufficient to leave the stripe
1 metadata alone and expect that it'll just be ignored, or if it has
to be zero'd, or if the itemsize has to change to literally end it
after the stripe 0 dev_uuid; ie. in the above example if item 70 needs
to be moved up two lines (of course on disk the encoding of this
information is just a dozen or so bytes not lines).

And then for the dev tree, you can see the above item 69 is pointing
to these two items, and they point to item 69. So I'd expect their
nodes need rewritten.

    item 32 key (1 DEV_EXTENT 32250003456) itemoff 14707 itemsize 48
        dev extent chunk_tree 3
        chunk_objectid 256 chunk_offset 298730913792 length 536870912
        chunk_tree_uuid 2928d93e-c031-464a-b475-e200cf61abac
    item 33 key (1 DEV_EXTENT 32786874368) itemoff 14659 itemsize 48
        dev extent chunk_tree 3
        chunk_objectid 256 chunk_offset 298730913792 length 536870912
        chunk_tree_uuid 2928d93e-c031-464a-b475-e200cf61abac


Anyway, after moving all of this stuff around, you still have to
compute a node CRC. So the whole 16KiB node has to be rewritten.

The proper way to do this in Btrfs terms would be to COW all of the
changed chunk tree nodes elsewhere, all the unneeded items are
removed. New CRCs. And then once that succeeds and is committed to
stable media, new supers written to point to the new chunk and dev
trees which in turn now only point to one of the already written
copies of metadata chunks, without writing out new chunks. Also, if
I'm not mistaken the chunk tree is actually in system chunk. So
there's this neat thing where you want the metadata chunk profile to
be single, described by a tree that itself could be single or dup. The
user space tools today consider "metadata" to include metadata and
system chunks. So converting one converts the other. But in ancient
times the user space code and probably still lurking in todays kernel
code, there's a distinction.

Anyway, yeah it'd be a ton faster. On your file system this is 10MiB
of writes to write out new dev tree and chunk trees that prune out the
unneeded extra copy. Just stop referencing the extra copy.

Basically right now it's doing a balance first, then convert. There's
no efficiency option to just convert via a prune only.

-- 
Chris Murphy
