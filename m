Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35004 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab2IXPh2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 11:37:28 -0400
Date: Mon, 24 Sep 2012 17:37:16 +0200
From: David Sterba <dave@jikos.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: crash in read_extent_buffer+0xb7/0xfb
Message-ID: <20120924153716.GJ14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120920171747.GG26105@merlins.org>
 <20120921034652.GA871@merlins.org>
 <20120923161634.GA23057@merlins.org>
 <20120924130847.GD14582@twin.jikos.cz>
 <20120924144103.GM23057@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120924144103.GM23057@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 07:41:03AM -0700, Marc MERLIN wrote:
> It's possible, I have crappy drives that were cheap that I'm using for tests
> and copies.

Yeah, that makes a good use of crappy disks :)

> Considering that I was doing a huge copy to a brtfs filesystem (source was
> ext4) and that I was using crappy drives in a 5 drives configuration
> with no redundancy since there is no raid5 yet, it's very possible.

Well, in your case raid1 might not be enough to protect the data.

>    0:   b7 6d                   mov    $0x6d,%bh
>    2:   db b6 6d db b6 6d       (bad)  0x6db6db6d(%rsi)
>    8:   49 bd 00 00 00 00 00    movabs $0xffff880000000000,%r13
>    f:   88 ff ff 
>   12:   49 c1 e0 03             shl    $0x3,%r8
>   16:   eb 43                   jmp    0x5b
>   18:   48 8b 8b 50 01 00 00    mov    0x150(%rbx),%rcx
>   1f:   4c 89 d0                mov    %r10,%rax
>   22:   48 89 d7                mov    %rdx,%rdi
>   25:   4c 29 f8                sub    %r15,%rax
>   28:   4c 39 e0                cmp    %r12,%rax
>   2b:*  4a 8b 0c 01             mov    (%rcx,%r8,1),%rcx     <-- trapping instruction

ffff8800405ba2c8 + 007ffffffd4ebdc8 = 1007f88003daa6090 and overflows 64bit

I'm afraid this does not tell much of the story. The last function that
is not a struct helper was leaf_space_used(), via push_leaf_right,
split_leaf() from btrfs_search_slot -- all sanity chcecks I see are past
any of those calls, so it's probably corrupted on-disk.

The call stack is unfortunatelly deep and going backwards in assembly to
track where R11 could get set is tedious.

Did you see any other messages in the log? If you could recreate the
filesystem and workload, doing a fsck occasionally may narrow down the
surface for analysis. Otherwise I'm out of ideas now.


david
