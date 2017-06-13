Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:33567 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752211AbdFMRaY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 13:30:24 -0400
Received: by mail-ot0-f181.google.com with SMTP id k4so93088186otd.0
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Jun 2017 10:30:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE0+S6OApx32JiJEwveHdZ7ukCSOVBuKdCNiwsXTQ4_QuXsfzQ@mail.gmail.com>
References: <CAE0+S6OjKesXZ65q5tVK7Y_Ydk7Q4Z8geEoQusr=7LVJHdUJGQ@mail.gmail.com>
 <0c43d71a-75b3-6f52-d89a-3dd7d1abace9@gmail.com> <CAE0+S6OApx32JiJEwveHdZ7ukCSOVBuKdCNiwsXTQ4_QuXsfzQ@mail.gmail.com>
From: Hy Che <cvghy116@gmail.com>
Date: Wed, 14 Jun 2017 00:29:41 +0700
Message-ID: <CAE0+S6MHf-DCqif1P6N4jJDXnsOC8OaVnaY-12XO4LvNGKYoCg@mail.gmail.com>
Subject: Fwd: Questions about how BtrFS works.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---------- Forwarded message ----------
From: Hy Che <cvghy116@gmail.com>
Date: Sun, Jun 11, 2017 at 10:45 PM
Subject: Re: Questions about how BtrFS works.
To: Nikolay Borisov <n.borisov.lkml@gmail.com>

Sorry for sending privately, I did't know clicked on 'Replay' is not
sent to the mailing list.
Some additional info.
4. It's not that I'm lazy reading code, I just don't know where to start.

5. I understand why it is now, the 100 bytes is header size, and the
offset only counted at the end of the header.

On Sun, Jun 11, 2017 at 3:00 PM, Nikolay Borisov
<n.borisov.lkml@gmail.com> wrote:
>
>
>
> On 10.06.2017 17:37, Hy Che wrote:
> > Hello everyone,
> > My name is Hy (ugen on freenode), I am a student attending GSoC for
> > Haiku[1]. Because I have a project that support write features for
> > BtrFS[2], there are some questions, since the documents on wiki are
> > not enough so I have to ask here.
> >
> > 1. Where can I find to read a complete btree manipulations in detail
> > (split, insert, etc) for BtrFS except the code base ?  I need to get
> > the idea first.
>
> Have you read this paper: https://dl.acm.org/authorize?N80838
> The original idea came by Ohad Rodeh while he was at IBM.
>
> I believe this was the initial paper: https://dl.acm.org/authorize?N80839

Have read both of them before, but I need more details.
There is a useful stuff here on
https://www.spinics.net/lists/linux-btrfs/msg05421.html
Is it work the same in current version ?

>
> > 2. About the reference,  " ...with a refcount associated to each tree
> > node but stored in an ad-hoc free map structure ... " - wikipedia.
> > What is a free map structure, and where does it stored ?
>
> I believe you are looking for this :
> https://btrfs.wiki.kernel.org/index.php/Btrfs_design#Reference_Counted_Extents
>
>
> http://www.spinics.net/lists/linux-btrfs/msg33415.html

Thanks, exactly what I want.

>
> >
> > 3. How BtrFS allocate block and extent when cow-ed ? As I tested after
> > making a new file, the root tree root, extent root and csum root move
> > forward 65536 bytes, the fs root move 49152 bytes and the data extent
> > is allocated next to the previous one. Where those numbers come from ?
> > Is data extent is cow-ed ? I see it doesn't because extent-item still
> > contains the old offset.
>
> You'd have to read the code, have you taken a look at : __btrfs_cow_block()

I have take a look, but it is kinda long and complex. If i traced
correcly, It would take to
find_free_extent(http://elixir.free-electrons.com/linux/latest/source/fs/btrfs/extent-tree.c#L7408),
where the infomation need is key "ins", and I don't know how it is
changed in which case.

>
>
> >
> > 4. How BtrFS handle transactions ?
> > Correctly me if I'm wrong, the transaction collect all requests in 30
> > seconds and then write back to disk. The transid increments when new
> > request appeared and genid is asigned to this one.
>
> I don't think there is anything written per-se. You'd again have to resort to reading the
> code

I need a rough idea before reading code because it would be taking lots of time.

>
> >
> > 5. Why there is unused space (100 bytes) at the end of each node ?
>
> > 6. How does BtrFS calculate checksum ?
>
> It uses a 32bit CRC. The actual function which is used to calc
> the csum is csum_tree_block you can check its callers and internals to
> in which code paths the crc is used. But in general all it does is call btrfs_csum_data
> on the extent buffer which holds the particular block.
>
Thanks
Hy
