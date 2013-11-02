Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55474 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3KBRLf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 13:11:35 -0400
Date: Sat, 2 Nov 2013 10:11:29 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Kelley Nielsen <kelleynnn@gmail.com>
Cc: linux-btrfs@vger.kernel.org, opw-kernel@googlegroups.com
Subject: Re: [OPW kernel] [PATCH 3/3] btrfs_find_item expanded to include
 find_orphan_item functionality
Message-ID: <20131102171129.GO15704@leaf>
References: <cover.1383289182.git.kelleynnn@gmail.com>
 <b004d650091cd74e2482057dd70d3dfa1eed1583.1383289182.git.kelleynnn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b004d650091cd74e2482057dd70d3dfa1eed1583.1383289182.git.kelleynnn@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 01, 2013 at 12:00:32AM -0700, Kelley Nielsen wrote:
> This is the third step in bootstrapping the btrfs_find_item interface.
> The function find_orphan_item, in orphan.c, is similar to the two
> functions already replaced by the new interface. It uses two parameters,
> which are already present in the interface, and is nearly identical to
> the function brought in in the previous patch.
> 
> The two calls to find_orphan_item have been replaced by calls to
> btrfs_find_item, with the defined object id and type that was used
> internally by find_orphan_item, a null path, and a null key. A test for
> a null path has been added to btrfs_find_item, and if it passes, a path
> is allocated and freed. Finally, find_orphan_item has been removed.

Again, use imperative voice, not passive voice.  Your commit message
should instruct the kernel to improve. :)

Replace the two calls to find_orphan_item ...

> Signed-off-by: Kelley Nielsen <kelleynnn@gmail.com>
> Suggested-by: Zach Brown <zab@redhat.com>

One issue below.

>  fs/btrfs/ctree.c    | 18 +++++++++++++++---
>  fs/btrfs/disk-io.c  |  3 ++-
>  fs/btrfs/orphan.c   | 20 --------------------
>  fs/btrfs/tree-log.c |  3 ++-
>  4 files changed, 19 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 498b19d..83a5418 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2465,7 +2465,8 @@ static int key_search(struct extent_buffer *b, struct btrfs_key *key,
>  /* Proposed generic search function, meant to take the place of the
>  * various small search helper functions throughout the code and standardize
>  * the search interface. Right now, it only replaces the former __inode_info
> -* in backref.c, and the former btrfs_find_root_ref in root-tree.c.
> +* in backref.c, the former btrfs_find_root_ref in root-tree.c, and the
> +* former btrfs_find_orphan_item in orphan.c.

Hmmm.  I'd expected this comment to have disappeared by the end of the
patch series, once all the cases were handled.

- Josh Triplett
