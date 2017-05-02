Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34229 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750962AbdEBO2Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 10:28:24 -0400
Date: Tue, 2 May 2017 16:28:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: check: Fix memory leak in
 check_chunks_and_extents
Message-ID: <20170502142817.GH23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170502031725.10312-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170502031725.10312-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 02, 2017 at 11:17:25AM +0800, Qu Wenruo wrote:
> fsck/003-shift-offsets makes valgrinds complaining about memory leaks.
> ==5910==
> ==5910== HEAP SUMMARY:
> ==5910==     in use at exit: 1,112 bytes in 11 blocks
> ==5910==   total heap usage: 161 allocs, 150 frees, 164,800 bytes allocated
> ==5910==
> ==5910== 216 (72 direct, 144 indirect) bytes in 1 blocks are definitely lost in loss record 3 of 5
> ==5910==    at 0x4C2AF1F: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==5910==    by 0x4815A3: add_root_item_to_list (cmds-check.c:9683)
> ==5910==    by 0x481CE2: check_chunks_and_extents (cmds-check.c:9886)
> ==5910==    by 0x48888B: cmd_check (cmds-check.c:12977)
> ==5910==    by 0x40A8C5: main (btrfs.c:246)
> ==5910==
> 
> The check_chunks_and_extents() memory leaks are caused by not freeing
> added root items of normal_trees and dropping_trees.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
