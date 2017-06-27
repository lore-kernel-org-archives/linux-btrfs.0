Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57443 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751693AbdF0RHM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 13:07:12 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 547F5AB09
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 17:07:11 +0000 (UTC)
Date: Tue, 27 Jun 2017 19:06:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/13] use rbtrees for preliminary backrefs
Message-ID: <20170627170602.GA2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170620160653.19907-1-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170620160653.19907-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 20, 2017 at 10:06:40AM -0600, Edmund Nadolski wrote:
> This patch series attempts to improve the performance of backref
> searches by changing the prelim_refs implementation to use
> rbtrees instead of lists.  This also aims to reduce the soft
> lockup occurences that can result when a backref search consumes
> too much cpu time.
> 
> Test runs of btrfs/130 show an improvement in the overall
> run time of the test (shown below in seconds) as a function of
> the number of extents:
> 
>     nr_extents:    256    512    640    1024     2048
>     ------------+-------+-----+-------+-------+------
>      unpatched:     20    186    375    2204    40419
>        patched:     12     93    203    1060    22007

About 50% improvement is really good.

> (Note, the current default value for nr_extents in btrfs/130 is
> 4096, which takes a very long time to complete.)
> 
> Edmund Nadolski (6):
>   btrfs: btrfs_check_shared should manage its own transaction
>   btrfs: remove ref_tree implementation from backref.c
>   btrfs: convert prelimary reference tracking to use rbtrees
>   btrfs: add cond_resched() calls when resolving backrefs
>   btrfs: allow backref search checks for shared extents
>   btrfs: clean up extraneous computations in add_delayed_refs
> 
> Jeff Mahoney (7):
>   btrfs: struct-funcs, constify readers
>   btrfs: constify tracepoint arguments
>   btrfs: backref, constify some arguments
>   btrfs: backref, add unode_aux_to_inode_list helper
>   btrfs: backref, cleanup __ namespace abuse
>   btrfs: add a node counter to each of the rbtrees
>   btrfs: backref, add tracepoints for prelim_ref insertion and merging

Some of the patches are preparatory or cleanups that can be applied
independently, but for further patchset revisions please keep them all
so you don't need to depend on the current development patche queue.
I'll get to merging them soon and will let you know.

Per Jeff's comment under patch 8/13, I will not add thse patches to
for-next yet, please address the issues and resend.
