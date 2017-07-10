Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40225 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754606AbdGJRHF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 13:07:05 -0400
Date: Mon, 10 Jul 2017 19:05:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: jeffm@suse.com, linux-btrfs@vger.kernel.org, lufq.fnst@cn.fujitsu.com
Subject: Re: [PATCH v2 00/13] use rbtrees for preliminary backrefs
Message-ID: <20170710170551.GQ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170629035705.1589-1-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170629035705.1589-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 09:56:52PM -0600, Edmund Nadolski wrote:
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

I'm merging patches 1-7 now, as they're fairly independent, no need to
keep them separate. 8 needs an update and the rest seems to depend on
it. I'll keep it in the for-next testing and replace with updated
version when it arrives.
