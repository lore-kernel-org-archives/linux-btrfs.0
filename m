Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:34749 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752172AbdFOP0k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 11:26:40 -0400
Received: by mail-ot0-f170.google.com with SMTP id r67so12110513ota.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 08:26:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a16b1de8-0022-9445-3fcd-a85ed70a5441@cn.fujitsu.com>
References: <CAE0+S6OjKesXZ65q5tVK7Y_Ydk7Q4Z8geEoQusr=7LVJHdUJGQ@mail.gmail.com>
 <0c43d71a-75b3-6f52-d89a-3dd7d1abace9@gmail.com> <CAE0+S6OApx32JiJEwveHdZ7ukCSOVBuKdCNiwsXTQ4_QuXsfzQ@mail.gmail.com>
 <CAE0+S6MHf-DCqif1P6N4jJDXnsOC8OaVnaY-12XO4LvNGKYoCg@mail.gmail.com> <a16b1de8-0022-9445-3fcd-a85ed70a5441@cn.fujitsu.com>
From: Hy Che <cvghy116@gmail.com>
Date: Thu, 15 Jun 2017 22:25:58 +0700
Message-ID: <CAE0+S6O5Gz_QAn9VfsshM67oj6F9Tc7RCCjxSo3LZ8ZGKYuVTw@mail.gmail.com>
Subject: Re: Fwd: Questions about how BtrFS works.
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Jun 14, 2017 at 8:46 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> That's why I recommend to start with btrfs on-disk data, which is static and
> you don't ever need to read much code.
> And we have more or less good enough doc for it:
> https://btrfs.wiki.kernel.org/index.php/Btree_Items
>
> Furthermore, AFAIK btrfs has the best tool to show how btrfs metadata and
> data is located on disk.
> (much better than Xfs and ext tools, and you can make it better easily)
>
> Not only which space is used (if you understand extent tree) but also what's
> inside each btrfs tree block.
yes, btrfs-show-super and btrfs-debug-tree help me most while learning
about btrfs.

> So my recommended study plan is:
> 1) Understand btrfs on-disk data
> 1.1) chunk tree and dev-extent tree
>      The very basic btrfs logical <-> device address mapping.
>      As almost all btrfs address space is logical space, without knowing
>      how to map it device, you can't go further
> 1.2) fs and subvolume tree
>      Understand how btrfs arrange its files and dirs.
> 1.3) root tree
>      Understand how btrfs arrange its subvolumes and other trees
> 1.4) extent tree
>      One of the most complicated tree, and quite a lot of items are not
>      easy to produce.
> 1.5) other trees
>      Not as common as above essential trees.
>
> 2) Try doing contribution to btrfs-progs
>    Just plain C codes without too much new facilities, and is a quite
>    small subset of kernel code.
>    It's small and (more or less) easy to read, and is mostly focused on
>    btrfs tree operations (for offline tools like fsck)
>
> 3) Understanding kernel code
>    That's quite a hard work, not only you need to understand some new
>    stuff bond to fs, like page cache, kernel memory management, block
>    layer API.
>    It will take you a long long time to just understand btrfs part.
>    But with a solid understand of btrfs btree operation, you could start
>    by checking how btrfs kernel modules manipulate its btree.
>
>
> You should first understand some basic info despite above btrfs ondisk data,
> like btrfs_path, btrfs_root and extent_buffer.
> They are the basic elements to manipulate btrfs btree.
>
> Then btrfs_search_slot() in *btrfs-progs* is your best starting point.
> The reason why you should start from btrfs-progs is:
> 1) It doesn't need to care about extra functions in kernel
>    A lot of on-line function like balance or scrub can affect btrfs
>    btree operation.
>    While in btrfs-progs we don't need to worry about that.
>
> 2) No need to worry about lock
>
> 3) Number of lines
>    And size-wise, ctree.c in btrfs-progs is less than 3000 lines while
>    in kernel it's near 6000 lines.
>
> So I recommend you to start from btrfs_search_slot() with cow=0 and
> ins_len=0 case.
> Then with cow=1 and ins_len=0 case.
> Finally with cow=1 ins_len=1 case.
>
> With that, you would have a basic idea how btrfs btree is manipulated, other
> related functions will be quite easy to understand, like
> btrfs_insert_empty_items().
Thanks for the guidelines, I will start reading btrfs_progs code first
and it is very easy to read as you said :)

>>
>>>
>>>
>>>>
>>>> 4. How BtrFS handle transactions ?
>>>> Correctly me if I'm wrong, the transaction collect all requests in 30
>>>> seconds and then write back to disk. The transid increments when new
>>>> request appeared and genid is asigned to this one.
>>>
>>>
>>> I don't think there is anything written per-se. You'd again have to
>>> resort to reading the
>>> code
>>
>>
>> I need a rough idea before reading code because it would be taking lots of
>> time.
>
>
> Indeed, transaction in btrfs is without much explain.
>
> But digging in btrfs-progs would provide you an overall view of it, but the
> behavior is still quite different from kernel.
> (BTW, 30 sec is just the commit interval which can be tuned by mount option)
>
> I'm not completely familiar with btrfs transaction, so I can be wrong and
> any comment is welcomed.
> Below is my understanding:
>
>
> A transaction is the time window in which we could modify btrfs metadata
> (tree blocks).
>
> Each transaction (not trans handler, as we can share one transaction with
> different trans handler) will increase the generation, all modified metadata
> inside the same transaction will have the same generation.
>
> And after a transaction is committed, all the on-disk tree blocks should be
> in a consistent stat.
>
> The life cycle of a transaction would be:
>                             \|/
> btrfs_commit_transaction()  ---    <- previous trans is committed
>                                       and finished
>
>                            gen: X
> btrfs_start_transaction()   ---    <- new transaction is started
> |- get trans handler A      /|\       as no running trans
> |- modify some tree blocks   |
>                              |
> btrfs_start_transaction()    |     <- Another progress start a trans
> |- get trans handler B       |        which will join current running
>                              |        trans
>                              |
> btrfs_start_transaction()    |     <- join current running trans
> |- get trans handler C       |
>                              |
> btrfs_commit_transaction() C |     <- whatever the reason, the handler
>                              |        holder want to finish transaction
>                              |        and make sure all meta is written
>                              |        to disk.
>                              |        But current trans is still used by
>                              |        other, it will wait.
>                              |
> btrfs_end_transaction() B    |     <- trans handler B get released
>                              |
> btrfs_end_transaction() A    |     <- trans handler A get released
>                              |
>                              |     <- all other user of current trans
>                              |        released it, we can commit the
>                              |        trans.
> btrfs_commit_transaction() C |     <- Trans X finished
> finished                    \|/
>                             ---
>
>                            Gen: X+1
> btrfs_start_transaction()   ---    <- new trans is started
>                             /|\
>                              |
>
> Quite a lot of effort is spent in kernel to handle the concurrency and
> reduce the critical region.
> So it's quite complicated in kernel, not so easy as I described above.
>
> But the overall concept should be more or less the same.
>
>
> In btrfs-progs, we can just forget that mess, as there is only
> btrfs_start_transaction() and btrfs_commit_transaction().
> No concurrency no mess.
>
>>>> 6. How does BtrFS calculate checksum ?
>>>
>>>
>>> It uses a 32bit CRC. The actual function which is used to calc
>>> the csum is csum_tree_block you can check its callers and internals to
>>> in which code paths the crc is used. But in general all it does is call
>>> btrfs_csum_data
>>> on the extent buffer which holds the particular block.
>
>
> It depends.
>
> For tree block (metadata), csum is calculated by CRC32ing the whole
> leaf/node except the first 32 bytes (which is reserved for csum).
> And restore the csum into the first 4 bytes of csum field of the header.
> (Header structure is shared between node, leaf and superblock)
>
> Check disk-io.c of btrfs-progs for csum_tree_block().
> In less than 500 lines you would get the complete answer from the CRC32
> initial seed to how we verify a tree block.
>
> For data, csum is calculated in sectorsize (only page size is supported
> yet), and only CRC32 is supported.
> Calculated CRC32 is stored into csum tree, which is designed for storing
> csums only.
>
> So data csum will not interfere how data is organized.
>
> Check check_extent_csums() in cmds-check.c of btrfs-progs to see how csums
> is organized in csum tree.
> (I would recommend to check my csum.c of btrfs-progs, but that patchset is
> not merged yet)
>
> Thanks,
> Qu
>
Thanks for well explain!, I wil see more info in the codebase.

One quick question. Is ctree is a variant of btree that used in btrfs
or something ?

Thanks,
Hy
