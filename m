Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:59668 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698Ab2EUKoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 May 2012 06:44:12 -0400
Message-ID: <4FBA1C7B.8000308@jan-o-sch.net>
Date: Mon, 21 May 2012 12:44:11 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Newbie questions on some of btrfs code...
References: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>
In-Reply-To: <CAHf9xvbp=FQwY1Pn9FDaMPdGqe-G4aSMeBK8kUAq-5Kry0YaTA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On Fri, May 18, 2012 at 13:21 (+0200), Alex Lyakas wrote:
> Some general questions on the ctree code.
> 
> # I saw that slot==0 is special. My understanding is that btrfs
> maintains the property that the parent of each node/leaf has a key
> pointing to that node/leaf, which must be equal to the key in the
> slot==0 of this node/leaf. That's what fixup_low_keys() tries to
> maintain. Is this correct?

Yes. I'm not 100% sure if the key in the parent node must match exactly
the first key of the child node. It is probably allowed that it's less
or equal than the first key. It is guaranteed to be larger than the
largest of the previous (left) node, though.

And yes, that's what fixup_low_keys is correcting.

> # If my understanding in the previous bullet is correct: Is that the
> reason that in btrfs_prev_leaf() it is assumed that if there is a
> lesser key, btrfs_search_slot() will never bring us to the slot==0 of
> the current leaf?

It's quite straight: We look for a key smaller than the first (slot 0)
of the current leaf. If we find the current leaf again (because
btrfs_search_slot returns the place where such a key would have be
inserted), then there's no previous leaf. No preconditions or
assumptions on nodes in levels needed.

> # btrfs_search_slot(): how can it happen that b becomes NULL, and we
> exit the while loop? (and set ret=1)

Good question, probably a leftover. b can't be NULL in the beginning,
because there's always a root node and a commit_root. b
setup_nodes_for_search only sets b NULL when it returns EAGAIN. And the
regular loop exit is in the "if (level == 0)" path.

> # btrfs_insert_empty_items(): if nr>1, then an array of keys is
> expected to be passed. But btrfs_search_slot() is searching only for
> the first key. What happens if the first key does not exist (as
> expected), but the next key in the array exists?

The reason here is that key ordering == insertion order. That function
only has two callers: once from log replay (where either all the items
from the log will exist in the leaf or none) and once from inode.c,
inserting INODE_ITEM and INODE_REF, which never come without the other.
But you are right, there seems to be no safety net in this function, a
comment might be useful.

-Jan
