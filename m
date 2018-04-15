Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from newman.cs.utexas.edu ([128.83.139.110]:54609 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbeDOBOQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Apr 2018 21:14:16 -0400
MIME-Version: 1.0
Reply-To: vijay@cs.utexas.edu
In-Reply-To: <20180414215529.GG5572@dastard>
References: <CA+EzBbCbRsZ=2qkBYjGVZQAVmUz34ky8vDOB7HxqRCrgymzysQ@mail.gmail.com>
 <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
 <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com>
 <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
 <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com>
 <20180414012017.GF5572@dastard> <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
 <20180414215529.GG5572@dastard>
From: Vijay Chidambaram <vijay@cs.utexas.edu>
Date: Sat, 14 Apr 2018 20:13:28 -0500
Message-ID: <CAPaz=ELn5GNbw4z5e30Og1ExyRTFNxHhPM9K_qn-EKWQ_Y7jXQ@mail.gmail.com>
Subject: Re: Symlink not persisted even after fsync
To: Dave Chinner <david@fromorbit.com>
Cc: Jayashree Mohan <jayashree2912@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave,

Thank you for your detailed reply.

I think we still have a misunderstanding. Bear with me, much of this
may seem obvious to you, but not to us and future readers of this
mailing list :)

We are *not* saying an fsync on a symlink file has to result in any
action on the original file. We understand the lack of ordering
constraints here.

Consider the following:

/p/t/testdir> touch orig
/p/t/testdir> ln -s orig symlink

/p/t/testdir> ls -l
total 8
-rw-r--r--  1 vijay  wheel  0 Apr 14 19:31 orig
lrwxr-xr-x  1 vijay  wheel  4 Apr 14 19:31 symlink -> orig

Here, there is a directory entry in testdir for symlink.

If we fsync symlink, is that directory entry persisted or not? That is
what we want to know. Regardless of whether symlink is a regular file
or an original file, it has a directory entry. We are saying *nothing*
about orig in this example.

If you fsync the symlink file ("symlink" in the example), does it
persist the directory entry for "symlink" also? Whatever relationship
exists between "testdir" and "orig", that relationship also exists
between "symlink" and "testdir".

>From your emails, I believe the answer is "no". The answer seems to be
"yes" for regular files, although this seems like an implementation
side-effect on file systems like btrfs (its not a guarantee btrfs
seeks to provide).

Regarding how we are able to fsync "symlink":

open(symlink) -> fails

but

fd = open(symlink, O_CREAT|O_RDWR) -> succeeds (even if symlink already exists)
fsync(fd) -> succeeds

So perhaps fsync on "symlink" is unsupported behavior that varies from
file system to file system? We saw ext4 and xfs had this behavior, so
we assumed it to be the default.

Thanks,
Vijay Chidambaram
http://www.cs.utexas.edu/~vijay/
