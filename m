Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37385 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbbK1KfG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 05:35:06 -0500
Received: by igcto18 with SMTP id to18so42846639igc.0
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 02:35:05 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <pan$74d49$6dea473f$1e446cbc$abd9cb3c@cox.net>
References: <1448642305-26199-1-git-send-email-fdmanana@kernel.org>
	<pan$74d49$6dea473f$1e446cbc$abd9cb3c@cox.net>
Date: Sat, 28 Nov 2015 10:35:05 +0000
Message-ID: <CAL3q7H6xvPfCk2bYRJqJr94_GGUwRkJoEB=A2hb85DKNErqd4A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix unprotected list move from unused_bgs to
 deleted_bgs list
From: Filipe Manana <fdmanana@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 28, 2015 at 7:34 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> fdmanana posted on Fri, 27 Nov 2015 16:38:25 +0000 as excerpted:
>
>> As of my previous change titled "Btrfs: fix scrub preventing unused
>> block groups from being deleted", the following warning at
>> extent-tree.c:btrfs_delete_unused_bgs() can be hit when we mount the a
>> filesysten with "-o discard":

Hi Duncan,

>
> This set of questions doesn't have anything directly to do with your
> patch, but it does have to do with unused blockgroup deletion, which of
> course your patch does too.

If it's unrelated to the patch please keep this in a separate thread
(which ironically I'm not doing it now as this client doesn't seem to
allow me to).

>
> When does unused blockgroup deletion occur?  Is there a waiting period
> after a new block group is created before it's deleted?  (I'd suppose so,
> so there's no race between creation in ordered to actually use it, and
> immediate deletion before it can be used.)  How long?

There's no guarantee about when. It can be as soon as the block group
becomes empty/unused or it might happen some time after the current
transaction is committed. The cleaner kthread is awaken at transaction
commit time, then does several stuff like deleting snapshots and
unused block groups and then it sleeps if it has nothing more to do. A
block group might become empty/unused while the cleaner kthread is
active or when its inactive (in the former case the deletion can
happen immediately while in the later case the block group deletion
happens sometime after the current transaction is committed).

>
> I suppose you've seen the discussion on defrag apparently not having as

Nop, I haven't. I don't always have the time to read through long
threads with a lot of theories and speculation.

> many uncongested data chunks to work with now, as they're all deleted,
> making it less effective since the available blocks of free space are
> likely to be much smaller now, whereas previously it could very
> frequently find whole gigs free to use at a time.

I don't get that. Defrag is basically marking as dirty a range of
consecutive pages that have physical (on disk) extents that aren't
contiguous - you can think of it as almost like rewriting the same
data in a file region from userspace (try that, create a fragmented
file, then read its content and write that same content again to the
file and call 'sync', the file will now have less extents unless you
were low on free space).

When writeback happens (in a response to fsync, sync or periodically
triggered by the kernel for several reasons) the allocator is called
to find space to write the data to - it tries its best to find
contiguous space (preferably a single extent, otherwise multiple) -
this is the same mechanism regardless of the pages becoming dirty due
to regular writes from user space or pages becoming dirty from a
defrag operation. If the allocator can't find space, it tries to
allocate new block groups/chunks - having a block group deletion
forcing later the allocator to allocate a new block group is no
different from forcing it to allocate a new one because all current
ones are full.

> First of all, I've not
> seen a direct confirmation from a dev on that theory yet, tho IIRC Hugo
> said it made sense, so that'd be useful.  Second, how trivial/major is
> patching defrag to be rather greeder with chunk allocation, when it can't
> find existing free space blocks of sufficient size?  Is that going to
> have to wait for the eventual defrag rewrite to enable reflink/snapshot
> awareness again?

Snapshot aware defrag has some extra stuff I didn't mention above, but
I'm not describing it here (I would have to go and read its
implementation before that) as it's been disabled for almost 2 years
now (with the disable patch backported to stable).

>
> And while waiting for that, is my suggested but as yet untested
> workaround of doing a bunch of 1 GiB file truncates to force data chunk
> allocation, syncing, then either deleting them (if the wait before empty-
> chunk deletion will allow time for the defrag to claim them), or
> truncating them to say 3.9 KiB (just under a single 4 KiB block) to keep
> the chunks claimed while freeing most of them (if the wait before empty-
> chunk deletion is too short to allow defrag to claim entirely empty
> chunks), followed by another sync, before the defrag, likely to work?  If
> not, is there some other way to force data chunk allocation and/or
> temporarily suspend empty-data-chunk deletion to give defrag some
> uncongested free space to work with?
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
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
