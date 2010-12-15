From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC PATCH 2/5 v3] Btrfs: avoid transaction stuff when btrfs
	is readonly
Date: Wed, 15 Dec 2010 11:05:51 -0500
Message-ID: <20101215160550.GB2603@localhost.localdomain>
References: <4CF8A74F.2010306@cn.fujitsu.com> <AANLkTikgAj1sFPr==ruot50Bq3oJ_v0ZG8Wy_QLdL+aG@mail.gmail.com> <4D08866E.6080501@cn.fujitsu.com> <1292428972-sup-3194@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: liubo <liubo2009@cn.fujitsu.com>,
	"Yan, Zheng" <zheng.z.yan@linux.intel.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	"Yan, Zheng" <zheng.yan@oracle.com>,
	Wenyi Liu <qingshenlwy@gmail.com>,
	Mike Fedyk <mfedyk@mikefedyk.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292428972-sup-3194@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 15, 2010 at 11:03:46AM -0500, Chris Mason wrote:
> Excerpts from liubo's message of 2010-12-15 04:12:14 -0500:
> > On 12/15/2010 04:45 PM, Yan, Zheng wrote:
> > > On Fri, Dec 3, 2010 at 4:16 PM, liubo <liubo2009@cn.fujitsu.com> wrote:
> > >> When the filesystem is readonly, avoid transaction stuff by checking MS_RDONLY
> > >> at start transaction time.
> > >>
> > >> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> > >> ---
> > >>  fs/btrfs/transaction.c |    3 +++
> > >>  1 files changed, 3 insertions(+), 0 deletions(-)
> > >>
> > >> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > >> index 1fffbc0..14a597d 100644
> > >> --- a/fs/btrfs/transaction.c
> > >> +++ b/fs/btrfs/transaction.c
> > >> @@ -181,6 +181,9 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
> > >>        struct btrfs_trans_handle *h;
> > >>        struct btrfs_transaction *cur_trans;
> > >>        int ret;
> > >> +
> > >> +       if (root->fs_info->sb->s_flags & MS_RDONLY)
> > >> +               return ERR_PTR(-EROFS);
> > >>  again:
> > >>        h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
> > >>        if (!h)
> > > 
> > > There are cases that we need to start transaction when MS_RDONLY flag is set.
> > > For example, remount FS into read-only mode and log replay.
> > 
> > However, is it weird to make changes to disk as fs is in readonly state?
> > IMO, btrfs needs to limit the use of these "disk-change while readonly" cases,
> > as it is not what readonly means.
> 
> reiserfs and ext3 at least have always done this.  Log replay is
> required even when the FS is readonly.
>

Just make sure the underlying disk isn't read only, we had problems with this on
ext3 a bit ago.  Thanks,

Josef 
