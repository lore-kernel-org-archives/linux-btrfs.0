From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix delayed insertion reservations V2
Date: Sat, 5 Nov 2011 07:46:35 -0400
Message-ID: <20111105114635.GB4253@shiny>
References: <20111104211853.GB13434@dhcp231-156.rdu.redhat.com>
 <20111105004756.GA4253@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111105004756.GA4253@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 04, 2011 at 08:47:56PM -0400, Chris Mason wrote:
> On Fri, Nov 04, 2011 at 05:18:54PM -0400, Josef Bacik wrote:
> > V1->V2: I stupidly thought I could get away with some flushing if we needed
> > space but I was wrong, we could deadlock, so add a btrfs_add_bytes_noflush
> > variant that will not do any flushing and will just return ENOSPC which will let
> > us fallback and do our full flushing.
> >  fs/btrfs/ctree.h         |    3 +++
> >  fs/btrfs/delayed-inode.c |   36 ++++++++++++++++++++++++++++--------
> >  fs/btrfs/extent-tree.c   |   18 ++++++++++++++++++
> >  3 files changed, 49 insertions(+), 8 deletions(-)
> 
> This helps but it I've got a bunch of these in the log now:
> 
> btrfs_dirty_inode: 205 callbacks suppressed
> btrfs: fail to dirty  inode 1294 error -28
> btrfs: fail to dirty  inode 1208 error -28
> btrfs: fail to dirty  inode 714 error -28
> btrfs: fail to dirty  inode 1772 error -28
> btrfs: fail to dirty  inode 1389 error -28
> btrfs: fail to dirty  inode 770 error -28
> btrfs: fail to dirty  inode 345 error -28
> btrfs: fail to dirty  inode 1533 error -28
> btrfs: fail to dirty  inode 624 error -28
> btrfs: fail to dirty  inode 1085 error -28

I should add this only seems to happen during xfstest 083.

-chris

