Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47348 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932635AbcKGR7w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 12:59:52 -0500
Date: Mon, 7 Nov 2016 18:59:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, rgoldwyn@suse.com, rgoldwyn@suse.de
Subject: Re: [PATCH 0/4] Qgroup comment enhance and balance fix
Message-ID: <20161107175948.GU12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161018013129.23331-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161018013129.23331-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 18, 2016 at 09:31:25AM +0800, Qu Wenruo wrote:
> The patchset does the following things:
> 1) Enhance comment for qgroup, rename 2 functions
>    Explain the how qgroup works, so new developers won't waste too much
>    time digging into the boring codes.
> 
>    The qgroup work flow is split into 3 main phrases:
>    Reverse, Trace, Account.
>    And rename functions like btrfs_qgroup_insert_dirty_extent_record()
>    to btrfs_qgroup_trace_extent(), to follow the "Trace" phrase.
> 
>    Other function name already follows such schema before.
> 
> 2) Move account_shared_subtree() and account_leaf_items() to qgroup.c
>    Such functions are only used by qgroup, so move them to qgroup.c and
>    rename them to follow "trace" schema.
> 
> 3) Fix the long standing qgroup balance corruption
>    Commit 62b99540a1d91e4 doesn't fix the problem completely.
>    It can only handle case that merge_reloc_roots() are all done in one
>    transaction.
> 
>    If transaction commits during merge_reloc_roots(), the data extents
>    will leak again.
> 
>    The tree fix is to info qgroup to trace both subtree(tree reloc tree
>    and destination fs tree), at replace_path() time.
>    Inside  replace_path(), there is one transaction start and end, so we
>    must make qgroup to trace both subtrees.
> 
>    Thanks for previous work, now we can easily trace subtree, so the fix
>    is quite simple now.
> 
>    And the cause also makes it easier to create pinpoint test case for
>    this bug.
> 
> Qu Wenruo (4):
>   btrfs: qgroup: Add comments explaining how btrfs qgroup works
>   btrfs: qgroup: Rename functions to make it follow
>     reserve,trace,account steps
>   btrfs: Expoert and move leaf/subtree qgroup helpers to qgroup.c
>   btrfs: qgroup: Fix qgroup data leaking by using subtree tracing

Added to next queue.
