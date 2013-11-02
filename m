Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54023 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3KBRCK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 13:02:10 -0400
Date: Sat, 2 Nov 2013 10:02:05 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Kelley Nielsen <kelleynnn@gmail.com>
Cc: linux-btrfs@vger.kernel.org, opw-kernel@googlegroups.com
Subject: Re: [OPW kernel] [PATCH 0/3] bootstrapping btrfs_find_item_interface
Message-ID: <20131102170204.GK15704@leaf>
References: <cover.1383287959.git.kelleynnn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1383287959.git.kelleynnn@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 31, 2013 at 11:52:45PM -0700, Kelley Nielsen wrote:
> There are many btrfs functions that manually search the tree for an
> item. They all reimplement the same mechanism and differ in the
> conditions that they use to find the item. It has been proposed that a
> new core interface, btrfs_find_item, be created to take the place of 

s/It has been proposed that ... be created/Zach Brown proposed creating .../
, judging by the Suggested-by in the patches.

> these functions, and standardize the search functionality.
> 
> This patchset takes the first steps toward the implementation of this
> core interface. The first patch creates a starting point for the
> interface by moving one of the search functions, __inode_item, to
> ctree.c and renaming it with the core function name. The next two
> patches eliminate one similar helper function each by replacing their
> callers with calls to the new core function, and modifying the new core
> function to ensure it fulfills the purpose of the function being
> replaced.
> 
> Kelley Nielsen (3):
>   Bootstrap generic btrfs_find_item interface
>   btrfs_find_item expanded to include find_root_ref funcionality
>   btrfs_find_item expanded to include find_orphan_item functionality
> 
>  fs/btrfs/backref.c   | 40 ++++----------------------------------
>  fs/btrfs/ctree.c     | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/ctree.h     |  2 ++
>  fs/btrfs/disk-io.c   |  3 ++-
>  fs/btrfs/inode.c     |  6 +++---
>  fs/btrfs/orphan.c    | 20 -------------------
>  fs/btrfs/root-tree.c | 15 --------------
>  fs/btrfs/tree-log.c  |  3 ++-
>  8 files changed, 68 insertions(+), 76 deletions(-)
> 
> -- 
> 1.8.1.2
> 
> -- 
> You received this message because you are subscribed to the Google Groups "opw-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to opw-kernel+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/groups/opt_out.
