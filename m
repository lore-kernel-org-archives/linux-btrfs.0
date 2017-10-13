Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751693AbdJNQsg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Oct 2017 12:48:36 -0400
Date: Fri, 13 Oct 2017 19:28:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/21] My current btrfs patch queue
Message-ID: <20171013172856.GE3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 03:43:44PM -0400, Josef Bacik wrote:
> This is my current set of outstanding patches.  A lot of these had reviews and
> I've incorporated the feedback.  They have been pretty thorougly tested and are
> pretty solid.
> 
> [PATCH 01/21] Btrfs: rework outstanding_extents
> [PATCH 02/21] btrfs: add tracepoints for outstanding extents mods
> [PATCH 03/21] btrfs: make the delalloc block rsv per inode

Left out for the main patch pile, as there's still ongoing review.

> [PATCH 04/21] btrfs: add ref-verify mount option
> [PATCH 05/21] btrfs: pass root to various extent ref mod functions
> [PATCH 06/21] Btrfs: add a extent ref verify tool
> [PATCH 07/21] Btrfs: only check delayed ref usage in
> [PATCH 08/21] btrfs: add a helper to return a head ref
> [PATCH 09/21] btrfs: move extent_op cleanup to a helper
> [PATCH 10/21] btrfs: breakout empty head cleanup to a helper
> [PATCH 11/21] btrfs: move ref_mod modification into the if (ref)
> [PATCH 12/21] btrfs: move all ref head cleanup to the helper function
> [PATCH 13/21] btrfs: remove delayed_ref_node from ref_head
> [PATCH 14/21] btrfs: remove type argument from comp_tree_refs

Added to misc-next.

> [PATCH 15/21] btrfs: switch args for comp_*_refs
> [PATCH 16/21] btrfs: add a comp_refs() helper
> [PATCH 17/21] btrfs: track refs in a rb_tree instead of a list

15 has needs some clarification and the other two depend on it, so
they're not merged yet.

> [PATCH 18/21] btrfs: fix send ioctl on 32bit with 64bit kernel

Merged outside of this queue earlier.

> [PATCH 19/21] btrfs: don't call btrfs_start_delalloc_roots in
> [PATCH 20/21] btrfs: move btrfs_truncate_block out of trans handle

Not enough brain power to review them today.

> [PATCH 21/21] btrfs: add assertions for releasing trans handle

Added.

Feel free to send updates, as new patches. I'll reorder the for-next
branch so the unmerged patches are still there in a separate branch and
will update them as needed.
