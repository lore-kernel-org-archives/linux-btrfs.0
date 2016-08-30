Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751530AbcH3OmL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 10:42:11 -0400
Date: Tue, 30 Aug 2016 16:40:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Lukas Lueg <lukas.lueg@gmail.com>
Subject: Re: [PATCH 0/5] Fuzzer test fix
Message-ID: <20160830144050.GH16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 30, 2016 at 03:22:12PM +0800, Qu Wenruo wrote:
> Cc: Lukas Lueg <lukas.lueg@gmail.com>
> 
> Thanks for the fuzz test from Lukas, quite a lot of bugs are exposed.
> 
> The full fixes can be fetched from my github:
> https://github.com/adam900710/btrfs-progs/tree/fuzz_fix_160830
> 
> The branch has go through fuzz and mkfs tests.
> 
> For full low-memory mode checker, I'll push it to David first, so for
> low-memory mode fuzzer test, it will need some time.
> 
> Test cases uses the same image submitted by Lukas.
> Although all these root causes are pinned, it still need quite a lot of
> work to make corrupt-block able to create minimal image.

That's not necessary to create a minimal image, but the extended
functionality of corrupt-block would help us to extend the testing.

> So I choose to directly use his images as test cases.
> 
> And special notes for the BUG_ON fix:
> The fix just fixes a small corner, while tons of BUG_ON()/abort() are
> still here and there.
> We need quite a lot of boring work to handle them later.

Yeah yeah, that's been neglected for a very long time. The kernel has
the abort_transaction infrastructure, the userspace hasn't been updated
in the same way. Long way to go, but every removed bug_on counts.

> While the good news is, new low memory mode(at least for extent and
> chunk tree check part) is quite safe against such things.
> I can't wait to see how the full low-memory mode works under fuzzer
> tests.
> 
> 
> Lukas Lueg (2):
>   btrfs-progs: fuzz-test: Add test case for invalid drop level
>   btrfs-progs: fuzz-test: Add test case for unaligned extent item
> 
> Qu Wenruo (3):
>   btrfs-progs: fsck: Check drop level before walking through fs tree
>   btrfs-progs: fsck: Check bytenr alignment for extent item
>   btrfs-progs: fsck: Avoid abort and BUG_ON in add_tree_backref

All applied, thanks.
