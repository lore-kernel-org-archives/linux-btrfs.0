Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:43763 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab2H1Ry3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Aug 2012 13:54:29 -0400
Date: Tue, 28 Aug 2012 13:54:26 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: improve fsync by filtering extents that we
 want
Message-ID: <20120828175426.GB2177@localhost.localdomain>
References: <1346086340-14776-1-git-send-email-bo.li.liu@oracle.com>
 <1346086340-14776-2-git-send-email-bo.li.liu@oracle.com>
 <20120827171240.GC4048@localhost.localdomain>
 <503C0F2A.9040308@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <503C0F2A.9040308@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 27, 2012 at 06:22:02PM -0600, Liu Bo wrote:
> On 08/28/2012 01:12 AM, Josef Bacik wrote:
> > On Mon, Aug 27, 2012 at 10:52:20AM -0600, Liu Bo wrote:
> >> This is based on Josef's "Btrfs: turbo charge fsync".
> >>
> >> The above Josef's patch performs very good in random sync write test,
> >> because we won't have too much extents to merge.
> >>
> >> However, it does not performs good on the test:
> >> dd if=/dev/zero of=foobar bs=4k count=12500 oflag=sync
> >>
> >> The reason is when we do sequencial sync write, we need to merge the
> >> current extent just with the previous one, so that we can get accumulated
> >> extents to log:
> >>
> >> A(4k) --> AA(8k) --> AAA(12k) --> AAAA(16k) ...
> >>
> >> So we'll have to flush more and more checksum into log tree, which is the
> >> bottleneck according to my tests.
> >>
> >> But we can avoid this by telling fsync the real extents that are needed
> >> to be logged.
> >>
> >> With this, I did the above dd sync write test (size=50m),
> >>
> >>          w/o (orig)   w/ (josef's)   w/ (this)
> >> SATA      104KB/s       109KB/s       121KB/s
> >> ramdisk   1.5MB/s       1.5MB/s       10.7MB/s (613%)
> >>
> >> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> >> ---
> >>  fs/btrfs/extent_map.c |   20 ++++++++++++++++++++
> >>  fs/btrfs/extent_map.h |    2 ++
> >>  fs/btrfs/inode.c      |    1 +
> >>  fs/btrfs/tree-log.c   |    6 +++---
> >>  4 files changed, 26 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> >> index 1fe82cf..ac606f0 100644
> >> --- a/fs/btrfs/extent_map.c
> >> +++ b/fs/btrfs/extent_map.c
> >> @@ -203,6 +203,8 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
> >>  			em->block_start = merge->block_start;
> >>  			merge->in_tree = 0;
> >>  			if (merge->generation > em->generation) {
> >> +				em->mod_start = em->start;
> >> +				em->mod_len = em->len;
> > 
> > Shouldn't this be
> > 
> > em->mod_start = merge->start;
> > em->mod_len += merge_len;
> > 
> 
> They just do the same thing.
> 
> There is already a 
> em->start = merge->start;
> em->len += merge_len
> 
> >>  				em->generation = merge->generation;
> >>  				list_move(&em->list, &tree->modified_extents);
> >>  			}
> >> @@ -222,6 +224,7 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
> >>  		rb_erase(&merge->rb_node, &tree->map);
> >>  		merge->in_tree = 0;
> >>  		if (merge->generation > em->generation) {
> >> +			em->mod_len = em->len;
> > 
> > And this should be em->mod_len += em->len?
> > 
> 
> No, em->len has already contained the merge's len.
>

Duh right sorry.  Thanks,

Josef
