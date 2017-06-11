Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:34077 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751725AbdFKIA6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Jun 2017 04:00:58 -0400
Received: by mail-wr0-f173.google.com with SMTP id g76so67438551wrd.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Jun 2017 01:00:57 -0700 (PDT)
Subject: Re: Questions about how BtrFS works.
To: Hy Che <cvghy116@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAE0+S6OjKesXZ65q5tVK7Y_Ydk7Q4Z8geEoQusr=7LVJHdUJGQ@mail.gmail.com>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <0c43d71a-75b3-6f52-d89a-3dd7d1abace9@gmail.com>
Date: Sun, 11 Jun 2017 11:00:55 +0300
MIME-Version: 1.0
In-Reply-To: <CAE0+S6OjKesXZ65q5tVK7Y_Ydk7Q4Z8geEoQusr=7LVJHdUJGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.06.2017 17:37, Hy Che wrote:
> Hello everyone,
> My name is Hy (ugen on freenode), I am a student attending GSoC for
> Haiku[1]. Because I have a project that support write features for
> BtrFS[2], there are some questions, since the documents on wiki are
> not enough so I have to ask here.
> 
> 1. Where can I find to read a complete btree manipulations in detail
> (split, insert, etc) for BtrFS except the code base ?  I need to get
> the idea first.

Have you read this paper: https://dl.acm.org/authorize?N80838
The original idea came by Ohad Rodeh while he was at IBM. 

I believe this was the initial paper: https://dl.acm.org/authorize?N80839


> 
> 2. About the reference,  " ...with a refcount associated to each tree
> node but stored in an ad-hoc free map structure ... " - wikipedia.
> What is a free map structure, and where does it stored ?

I believe you are looking for this : 
https://btrfs.wiki.kernel.org/index.php/Btrfs_design#Reference_Counted_Extents


http://www.spinics.net/lists/linux-btrfs/msg33415.html

> 
> 3. How BtrFS allocate block and extent when cow-ed ? As I tested after
> making a new file, the root tree root, extent root and csum root move
> forward 65536 bytes, the fs root move 49152 bytes and the data extent
> is allocated next to the previous one. Where those numbers come from ?
> Is data extent is cow-ed ? I see it doesn't because extent-item still
> contains the old offset.

You'd have to read the code, have you taken a look at : __btrfs_cow_block()


> 
> 4. How BtrFS handle transactions ?
> Correctly me if I'm wrong, the transaction collect all requests in 30
> seconds and then write back to disk. The transid increments when new
> request appeared and genid is asigned to this one.

I don't think there is anything written per-se. You'd again have to resort to reading the 
code 

> 
> 5. Why there is unused space (100 bytes) at the end of each node ?

> 6. How does BtrFS calculate checksum ?

It uses a 32bit CRC. The actual function which is used to calc
the csum is csum_tree_block you can check its callers and internals to 
in which code paths the crc is used. But in general all it does is call btrfs_csum_data
on the extent buffer which holds the particular block. 

> 
> 
> [1]: About Haiku: www.haiku-os.org
> [2]: My project info on GSoC:
> https://summerofcode.withgoogle.com/projects/4749427110576128
> 
> Thanks,
> Hy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
