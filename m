Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42278 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751902AbeDOBRr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Apr 2018 21:17:47 -0400
Date: Sat, 14 Apr 2018 21:17:35 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Vijay Chidambaram <vijay@cs.utexas.edu>,
        Jayashree Mohan <jayashree2912@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: Symlink not persisted even after fsync
Message-ID: <20180415011735.GB21830@thunk.org>
References: <CA+EzBbCbRsZ=2qkBYjGVZQAVmUz34ky8vDOB7HxqRCrgymzysQ@mail.gmail.com>
 <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
 <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com>
 <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
 <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com>
 <20180414012017.GF5572@dastard>
 <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
 <20180414215529.GG5572@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180414215529.GG5572@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The only thing I would add to Dave's comments is that a lot of these
formal semantics are de facto, and not de jure.  If you take a look at
POSIX or the Single Unix Specification, they are remarkably silent
about how fsync works.

In fact POSIX/SUS doesn't even define "fsync on a directory".  In the
original POSIX, the O_DIRECTORY flag does not exist and the directory
stream object returned opendir(2) does not have to be implemented using
a file descriptor[1]t

[1] http://pubs.opengroup.org/onlinepubs/9699919799/functions/opendir.html

In SUSv7, between adding openat(2) and fchdir(2), etc., the standards
body has backed itself into more-or-less admittihng that on all
implementations that matter directory fd's really do exist.  But if
you take a look at what is stated about fsync(2), it only talks about
what it does in relation to _files_, and not directories, or anything else[2]

[2] http://pubs.opengroup.org/onlinepubs/969991t9799/functions/fsync.html

Furthermore, "strictly ordered metadata recovery semantics" is not
something which is formally in any kind of standards document.
Filesystem developers knows what it means, and it gets encoded as
things like test in xfstests.  But at the same time, we need to be
careful not to invent stricter "guarantees" than what is required by
the standards and the generally agreed-upon norms by file system
developers.

Otherwise we can have academics inventing guarantees, such as Pillai,
et.al[3] and justifying this because they find applications have
better crash semantics with these new guarantees --- and instead of
saying that the applications are buggy, instead the paper proposes
that perhaps file systems should provide thos extra guarantees.

[3]  https://www.usenix.org/system/files/conference/osdi14/osdi14-paper-pillai.pdf

The problem with this is providing those extra guarantees may very
often imposing performance tradeoffs; and while I'm not saying that
the only thing file system authors should feel obliged to provide is
the bare minimum specified by POSIX (which doesn't require strictly
ordered metadata semantics), at the same time --- let's not go crazy.
There are cost-benefit decisions that need to be made.

So in the case of symlinks, the first thing I would ask is *why* do
application writers really want formal crash semantics for symlinks?
Is it a reasonable thing for them to want it?  And is it a good thing
for them to want, given that portable code should work on more than
just one file system, and certainly on more than one operating system
--- and there are no guarantees that all POSIX-compliant operating
systems will even *have* symlinks.  So in my opinion the best thing to
do is to assume that they exist for system administrator convenience,
and they aren't things which applications should be trying to use in
use cases where they need some kind of transactional semantics.

> And, well, you can't fsync a symlink *inode*, anyway, because you
> can't open it directly for IO operations.

Well.... you can get a fd on a symlink using O_PATH | O_NOFOLLOW.  It
doesn't work today, but one could imagine a future kernel extension
which adds to the system calls that can use a fd-on-a-symlink beyond
fchownat(2), fstatat(2), freadlinkat(2), et. al., and allowing
fsync(2) to work.  (It would require VFS and file-system level
changes.)

But the first question to ask is *why*?  Is it worth the extra hair
and complexity?

Especially given that if the file system has ordered metadata
semantics after a crash, there are other ways that an application can
request the same semantics.

					- Ted
