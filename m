Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932371AbdDEKUS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Apr 2017 06:20:18 -0400
Date: Wed, 5 Apr 2017 18:20:16 +0800
From: Eryu Guan <eguan@redhat.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>, hch@lst.de
Subject: Re: [PATCH] generic: test for number of bytes used by files after
 buffered writes
Message-ID: <20170405102016.GX22845@eguan.usersys.redhat.com>
References: <1491272615-3795-1-git-send-email-fdmanana@kernel.org>
 <20170405094600.GW22845@eguan.usersys.redhat.com>
 <CAL3q7H4PN51XpGJc+EsHN+oaRT=fMnWxfe+Z1RH2G0+a8NgZcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4PN51XpGJc+EsHN+oaRT=fMnWxfe+Z1RH2G0+a8NgZcg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 05, 2017 at 11:13:56AM +0100, Filipe Manana wrote:
> On Wed, Apr 5, 2017 at 10:46 AM, Eryu Guan <eguan@redhat.com> wrote:
> > On Tue, Apr 04, 2017 at 03:23:35AM +0100, fdmanana@kernel.org wrote:
> >> From: Filipe Manana <fdmanana@suse.com>
> >>
> >> Test that a filesystem's implementation of the stat(2) system call
> >> reports correct values for the number of blocks allocated for a file
> >> when there are delayed allocations.
> >>
> >> This test is motivated by a bug in btrfs which is fixed by the following
> >> path for the linux kernel:
> >>
> >>  "Btrfs: fix reported number of inode blocks"
> >>
> >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
...
> >
> >> +_require_xfs_io_command "falloc"
> >
> > This has some problems with the "-k" flag. NFSv4.2 supports fallocate(2)
> > but not KEEP_SIZE flag, so test fails with NFSv4.2 mount.
> >
> >      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> >     +fallocate: Operation not supported
> >      wrote 65536/65536 bytes at offset 0
> >
> > We met the same issue before with generic/071.
> > http://www.spinics.net/lists/fstests/msg03527.html
> >
> > So I have two options now, one is the method proposed by Eric in above
> > thread, run falloc command with $param.
> >
> > common/rc::_require_xfs_io_command
> > -               testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
> > +               testio=`$XFS_IO_PROG -F -f -c "falloc $param 0 1m" $testfile 2>&1`
> >
> > tests/generic/422:
> > -_require_xfs_io_command "falloc"
> > +_require_xfs_io_command "falloc" "-k"
> >
> >
> > The other is requiring "falloc -k" in the test:
> >
> > common/rc::_require_xfs_io_command
> > -       "falloc" )
> > -               testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
> > +       falloc* )
> > +               testio=`$XFS_IO_PROG -F -f -c "$command 0 1m" $testfile 2>&1`
> >
> > tests/generic/422:
> > -_require_xfs_io_command "falloc"
> > +_require_xfs_io_command "falloc -k"
> >
> > I slightly prefer the second way, as it doesn't change the default
> > behavior and makes falloc a special-case.
> > (_require_xfs_io_command "<cmd>" "<param>" behaves the same as other
> > commands).
> 
> Ok, do you prefer the changes to common/rc in a separate patch or can
> they be folded in v2 for this test?

A separate patch would be good, as it fixes a separate & long standing
issue. Thanks!

Eryu
