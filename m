Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33792 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbbGMJ1K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 05:27:10 -0400
Received: by iebmu5 with SMTP id mu5so230301170ieb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2015 02:27:09 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <D9085F65B8B44087B5F6144AC9356BBB@alyakaslap>
References: <D9085F65B8B44087B5F6144AC9356BBB@alyakaslap>
Date: Mon, 13 Jul 2015 10:27:09 +0100
Message-ID: <CAL3q7H6Escicg5PWCd4gw_88TXTEWznqBKRGES0f0gzTU-=HeQ@mail.gmail.com>
Subject: Re: question about should_cow_block() and BTRFS_HEADER_FLAG_WRITTEN
From: Filipe David Manana <fdmanana@gmail.com>
To: Alex Lyakas <alex@zadarastorage.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 12, 2015 at 6:15 PM, Alex Lyakas <alex@zadarastorage.com> wrote:
> Greetings,
> Looking at the code of should_cow_block(), I see:
>
> if (btrfs_header_generation(buf) == trans->transid &&
>    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN) &&
> ...
> So if the extent buffer has been written to disk, and now is changed again
> in the same transaction, we insist on COW'ing it. Can anybody explain why
> COW is needed in this case? The transaction has not committed yet, so what
> is the danger of rewriting to the same location on disk? My understanding
> was that a tree block needs to be COW'ed at most once in the same
> transaction. But I see that this is not the case.

That logic is there, as far as I can see, for at least 2 obvious reasons:

1) fsync/log trees. All extent buffers (tree blocks) of a log tree
have the same transaction id/generation, and you can have multiple
fsyncs (log transaction commits) per transaction so you need to ensure
consistency. If we skipped the COWing in the example below, you would
get an inconsistent log tree at log replay time when the fs is
mounted:

transaction N start

   fsync inode A start
   creates tree block X
   flush X to disk
   write a new superblock
   fsync inode A end

   fsync inode B start
   skip COW of X because its generation == current transaction id and
modify it in place
   flush X to disk

========== crash ===========

   write a new superblock
   fsync inode B end

transaction N commit

2) The flag BTRFS_HEADER_FLAG_WRITTEN is set not when the block is
written to disk but instead when we trigger writeback for it. So while
the writeback is ongoing we want to make sure the block's content
isn't concurrently modified (we don't keep the eb write locked to
allow concurrent reads during the writeback).

All tree blocks that don't belong to a log tree are normally written
only when at the end of a transaction commit. But often, due to memory
pressure for e.g., the VM can call the writepages() callback of the
btree inode to force dirty tree blocks to be written to disk before
the transaction commit.

>
> I am asking because I am doing some profiling of btrfs metadata work under
> heavy loads, and I see that sometimes btrfs COW's almost twice more tree
> blocks than the total metadata size.
>
> Thanks,
> Alex.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
