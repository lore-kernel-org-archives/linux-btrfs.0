Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42296 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752228AbeDOBa3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Apr 2018 21:30:29 -0400
Date: Sat, 14 Apr 2018 21:30:15 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vijay Chidambaram <vijay@cs.utexas.edu>
Cc: Dave Chinner <david@fromorbit.com>,
        Jayashree Mohan <jayashree2912@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: Symlink not persisted even after fsync
Message-ID: <20180415013015.GC21830@thunk.org>
References: <CA+EzBbCbRsZ=2qkBYjGVZQAVmUz34ky8vDOB7HxqRCrgymzysQ@mail.gmail.com>
 <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
 <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com>
 <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
 <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com>
 <20180414012017.GF5572@dastard>
 <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
 <20180414215529.GG5572@dastard>
 <CAPaz=ELn5GNbw4z5e30Og1ExyRTFNxHhPM9K_qn-EKWQ_Y7jXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPaz=ELn5GNbw4z5e30Og1ExyRTFNxHhPM9K_qn-EKWQ_Y7jXQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 14, 2018 at 08:13:28PM -0500, Vijay Chidambaram wrote:
> 
> We are *not* saying an fsync on a symlink file has to result in any
> action on the original file. We understand the lack of ordering
> constraints here.

The problem is you're not being precise here.  The fsync(2) system
call operates on a file descriptor, not a file.  This is an important
distinction.

Suppose you have a symlink called "foo" which points to  "/tmp/bar/quux"

	fd = open("foo", O_CREAT|O_RDWR);

It will _fail_ if /tmp/bar does not exist:

% ls -l foo
0 lrwxrwxrwx 1 tytso tytso 13 Apr 14 21:21 foo -> /tmp/bar/quux
% echo test > foo
bash: foo: No such file or directory
% mkdir /tmp/bar
% echo test > foo
% ls -l /tmp/bar
total 4
4 -rw-r--r-- 1 tytso tytso 5 Apr 14 21:22 quux

When you open "foo", the restulting file descriptor is not associated
with the symlink.  The resulting file descriptor is the exact same
thing you would get if you had instead called:

	fd = open("/tmp/bar/quux", O_CREAT|O_RDWR);

Hence, when you call

       fsync(fd);

What you are calling fsync on is not the _symlink_, but the inode
which is named by /tmp/bar/quux.


Now, as I said in the e-mail I just sent, you _can_ do this:

	fd = open ("foo", O_PATH | O_NOFOLLOW);

And this *will* give you a file descriptor which is associated with
the symlink, and not the inode (if it exists) which the symlink points
at.  However, there is a very limited number of system calls can
operate on that file descriptor --- and read(2), write(2), and
fsync(2) are not among them.

> fsync(fd) -> succeeds
> 
> So perhaps fsync on "symlink" is unsupported behavior that varies from
> file system to file system? We saw ext4 and xfs had this behavior, so
> we assumed it to be the default.

fsync on "symlink" doesn't exist at all today.  You were mistaken as
to what you were doing; what you were fsync'ing was the inode that was
created as the result of:

	fd = open("symlink", O_CREAT|O_RDWR);

... if you were able to create file in the first place.  If "symlink"
points at /tmp/bar/quux, and /tmp/bar does not exist, the open will
fail.  Not because it was a symlink, but because the equivalent
open("/tmp/bar/quux", O_CREAT|O_RDWR) would have failed.

Regards,

						- Ted
