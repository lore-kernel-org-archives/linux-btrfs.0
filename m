From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.35
Date: Fri, 11 Jun 2010 16:28:33 -0400
Message-ID: <20100611202833.GG3018@think>
References: <20100611193731.GA3018@think>
 <AANLkTim6K6x3trUJLSUpoqsCWEpWuhxyN1zVRDUXH3BQ@mail.gmail.com>
 <20100611194812.GD3018@think>
 <AANLkTilRCWlM5ZklGOb26Xj9XAmBdY1S702WyQGuaK_l@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTilRCWlM5ZklGOb26Xj9XAmBdY1S702WyQGuaK_l@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 11, 2010 at 01:00:02PM -0700, Linus Torvalds wrote:
> On Fri, Jun 11, 2010 at 12:48 PM, Chris Mason <chris.mason@oracle.com> wrote:
> >
> > The others all fix oopsen or big problems, and I think fixing warnings
> > helps avoid false negatives as others look for real problems?
> >
> > I'm happy to rebase out the 3 non-criticals.
> 
> There seems to be more than three non-criticals. There's the warning
> fixes, the "unused variables" thing, the "memdup_user()" thing, a
> couple of unnecessary NULL checks removed etc. On the whole, I do not
> get the feeling that the pull request was actively trying to be
> minimal, and that's what I really want to see.

The for-linus branch (note the change in branch name) has everything
that doesn't fix a bug removed.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

I'll update the master branch to reflect any pulls you do.

Dan Carpenter (9) commits (+19/-8):
    Btrfs: handle error returns from btrfs_lookup_dir_item() (+2/-0)
    Btrfs: btrfs_read_fs_root_no_name() returns ERR_PTRs (+4/-0)
    Btrfs: unwind after btrfs_start_transaction() errors (+1/-1)
    Btrfs: The file argument for fsync() is never null (+1/-1)
    Btrfs: handle ERR_PTR from posix_acl_from_xattr() (+2/-0)
    Btrfs: btrfs_lookup_dir_item() can return ERR_PTR (+1/-1)
    Btrfs: uninitialized data is check_path_shared() (+1/-1)
    Btrfs: handle kzalloc() failure in open_ctree() (+5/-2)
    Btrfs: btrfs_iget() returns ERR_PTR (+2/-2)

Zheng Yan (2) commits (+6/-4):
    Btrfs: Fix BUG_ON for fs converted from extN (+2/-1)
    Btrfs: Fix null dereference in relocation.c (+4/-3)

Shi Weihua (2) commits (+6/-0):
    Btrfs: prohibit a operation of changing acl's mask when noacl mount option used (+3/-0)
    Btrfs: should add a permission check for setfacl (+3/-0)

Miao Xie (2) commits (+9/-1):
    Btrfs: fix loop device on top of btrfs (+1/-0)
    Btrfs: fix remap_file_pages error (+8/-1)

Sage Weil (1) commits (+0/-3):
    Btrfs: avoid BUG when dropping root and reference in same transaction

Josef Bacik (1) commits (+1/-1):
    Btrfs: fix fallocate regression

Total: (17) commits (+41/-17)
 fs/btrfs/acl.c         |    8 ++++++++
 fs/btrfs/disk-io.c     |   11 +++++++++--
 fs/btrfs/extent-tree.c |    3 ++-
 fs/btrfs/file.c        |   12 ++++++++++--
 fs/btrfs/inode.c       |    4 ++--
 fs/btrfs/ioctl.c       |    4 ++--
 fs/btrfs/relocation.c  |    7 ++++---
 fs/btrfs/root-tree.c   |    3 ---
 fs/btrfs/super.c       |    6 ++++--
 9 files changed, 41 insertions(+), 17 deletions(-)
