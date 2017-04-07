Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38644 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755381AbdDGJpt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Apr 2017 05:45:49 -0400
Date: Fri, 7 Apr 2017 17:45:46 +0800
From: Eryu Guan <eguan@redhat.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/3] common/rc: test that xfs_io's falloc command
 supports specific flags
Message-ID: <20170407094546.GU22845@eguan.usersys.redhat.com>
References: <1491287671-23097-1-git-send-email-fdmanana@kernel.org>
 <20170407085117.GS22845@eguan.usersys.redhat.com>
 <CAL3q7H7SN5stPdFDD87kUBtLhJkA2E5dHJ+Cf0m601WeyA9H+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7SN5stPdFDD87kUBtLhJkA2E5dHJ+Cf0m601WeyA9H+A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 07, 2017 at 10:13:09AM +0100, Filipe Manana wrote:
> On Fri, Apr 7, 2017 at 9:51 AM, Eryu Guan <eguan@redhat.com> wrote:
> > On Tue, Apr 04, 2017 at 07:34:29AM +0100, fdmanana@kernel.org wrote:
> >> From: Filipe Manana <fdmanana@suse.com>
> >>
> >> For example NFS 4.2 supports fallocate but it does not support its
> >> KEEP_SIZE flag, so we want to skip tests that use fallocate with that
> >> flag on filesystems that don't support it.
> >>
> >> Suggested-by: Eryu Guan <eguan@redhat.com>
> >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >> ---
> >>  common/rc | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/common/rc b/common/rc
> >> index e1ab2c6..3d0f089 100644
> >> --- a/common/rc
> >> +++ b/common/rc
> >> @@ -2021,8 +2021,8 @@ _require_xfs_io_command()
> >>       "chproj")
> >>               testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
> >>               ;;
> >> -     "falloc" )
> >> -             testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
> >> +     "falloc*" )
> >> +             testio=`$XFS_IO_PROG -F -f -c "$command 0 1m" $testfile 2>&1`
> >
> > Sorry, I was wrong about this. It would break the subsequent
> > $XFS_IO_PROG -c "help $command" | grep ... command if another $param is
> > specified.
> 
> Yeah I had noticed that because the following won't cause the return anymore:
> 
> test -z "$param" && return
> 
> > Seems adding $param to falloc command is the right way, as
> > what Darrick did to fiemap in his new test.
> >
> > -               testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
> > +               testio=`$XFS_IO_PROG -F -f -c "falloc $param 0 1m" $testfile 2>&1`
> 
> But in that case grepping the help output, at the very end of the
> function, will fail for falloc since its help output fails to match
> the grep pattern (as highlighted in the thread you pointed before).
> So that grep pattern would have to change as well.

This should be fixed by xfsprogs commit 0c2ed80a3590 ("xfs_io: provide
long-format help for falloc"). But I agreed searching the help message
again for it would be redundant. But perhaps that needs wider review and
doesn't belong to this patch. I'll try to do that in my cleanup patch
for _require_xfs_io_command().

Thanks,
Eryu

> 
> >
> > Do you mind me updating these three patches accordingly? Or can you send
> > out new version if you like?
> 
> Sure, fell free to update it as you feel it's the best way.
> 
> Thanks!
> 
> >
> > Thanks! And sorry again!
> >
> > Eryu
> >
> > P.S. I'm thinking of converting all the case switches (except the
> > default one) in _require_xfs_io_command() to actually run the $command
> > with $param, and doing other cleanups, but that won't block this patch
> > and I can do it in another patch.
> >
> >>               ;;
> >>       "fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare")
> >>               testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
> >> --
> >> 2.7.0.rc3
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe fstests" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
