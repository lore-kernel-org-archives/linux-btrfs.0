Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48961 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934865AbdDFO32 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Apr 2017 10:29:28 -0400
Date: Thu, 6 Apr 2017 16:28:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/3] common/rc: test that xfs_io's falloc command
 supports specific flags
Message-ID: <20170406142842.GO4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1491287671-23097-1-git-send-email-fdmanana@kernel.org>
 <20170406141805.GL22845@eguan.usersys.redhat.com>
 <CAL3q7H6F+vyh5DrNsa9ZWS2dTOnVF+9CG2h=MBojmsyjnfMy7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6F+vyh5DrNsa9ZWS2dTOnVF+9CG2h=MBojmsyjnfMy7w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 06, 2017 at 03:20:43PM +0100, Filipe Manana wrote:
> On Thu, Apr 6, 2017 at 3:18 PM, Eryu Guan <eguan@redhat.com> wrote:
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
> >
> > This doesn't work as expected with quotes. I can remove the quotes at
> > commit time though.
> 
> Hum, it did work for me, strange.

Quoted globs don't work the same way as unquoted inside case, this

#!/bin/sh
i=abc
case $i in
	abc*) echo notquoted;;
	"abc*") echo quoted;;
esac
---

will return 'notquoted'
