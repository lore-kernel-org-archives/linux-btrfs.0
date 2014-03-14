Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57696 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbaCNOgN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 10:36:13 -0400
Message-ID: <532313D5.5080702@fb.com>
Date: Fri, 14 Mar 2014 10:36:05 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: fsck: disable --init-extent-tree option
 when using snapshots
References: <1394447961-27981-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <CAP9B-Qm8p5zPBDpvEwwOHGUxpRqHkBCsNGk21+8qaoYkhx44zA@mail.gmail.com> <531DDF4E.3090600@fb.com> <531E657A.2000803@cn.fujitsu.com> <9BB6AEEF-1B52-449E-BB89-B3619EE968EB@gmail.com>
In-Reply-To: <9BB6AEEF-1B52-449E-BB89-B3619EE968EB@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/14/2014 09:36 AM, Wang Shilong wrote:
> Hi Josef,
> 
> Just ping this again.
> 
> Did you have any good ideas to rebuild extent tree if broken
> filesystem is filled with snapshots.?
> 
> I was working on this recently, i was blocked that i can not verify
> if an extent is *FULL BACKREF* mode or not. As a *FULL BACKREF*
> extent's refs can be 1 and more than 1..
> 
> I am willing to test  codes or have a try if you could give me some
> advice etc.
> 

Full backrefs aren't too hard.  Basically all you have to do is walk
down the fs tree and keep track of btrfs_header_owner(eb) for
everything we walk into.  If btrfs_header_owner(eb) == root->objectid
for the tree we are walking down then we need a ye olde normal backref
for this block.  If btrfs_header_owner(eb) != root->objectid we _may_
need a full backref, it depends on who owns the parent block.  The
following may be incomplete, I'm kind of sick

1) We walk down the original tree, every eb we encounter has
btrfs_header_owner(eb) == root->objectid.  We add normal references
for this root (BTRFS_TREE_BLOCK_REF_KEY) for this root.  World peace
is achieved.

2) We walk down the snapshotted tree.  Say we didn't change anything
at all, it was just a clean snapshot and then boom.  So the
btrfs_header_owner(root->node) == root->objectid, so normal backref.
We walk down to the next level, where btrfs_header_owner(eb) !=
root->objectid, but the level above did, so we add normal refs for all
of these blocks.  We go down the next level, now our
btrfs_header_owner(parent) != root->objectid and
btrfs_header_owner(eb) != root->objectid.  This is where we need to
now go back and see if btrfs_header_owner(eb) currently has a ref on
eb.  If it does we are done, move on to the next block in this same
level, we don't have to go further down.

3) Harder case, we snapshotted and then changed things in the original
root.  Do the same thing as in step 2, but now we get down to
btrfs_header_level(eb) != root->objectid && btrfs_header_level(parent)
!= root->objectid.  We lookup the references we have for eb and notice
that btrfs_header_owner(eb) no longer refers to eb.  So now we must
set FULL_BACKREF on this extent reference and add a
SHARED_BLOCK_REF_KEY for this eb using the parent->start as the
offset.  And we need to keep walking down and doing the same thing
until we either hit level 0 or btrfs_header_owner(eb) has a ref on the
block.

4) Not really a whole special case, just something to keep in mind, if
btrfs_header_owner(parent) == root->objectid but
btrfs_header_owner(eb) != root->objectid that means we have a normal
TREE_BLOCK_REF on eb, it's only when the parent doesn't match our
current root that it's a problem.


Does that make sense?  Thanks,

Josef
