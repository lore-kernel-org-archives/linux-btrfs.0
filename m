Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:30765 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751875AbeDNVze (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Apr 2018 17:55:34 -0400
Date: Sun, 15 Apr 2018 07:55:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Vijay Chidambaram <vijay@cs.utexas.edu>
Cc: Jayashree Mohan <jayashree2912@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: Symlink not persisted even after fsync
Message-ID: <20180414215529.GG5572@dastard>
References: <CA+EzBbCbRsZ=2qkBYjGVZQAVmUz34ky8vDOB7HxqRCrgymzysQ@mail.gmail.com>
 <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
 <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com>
 <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
 <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com>
 <20180414012017.GF5572@dastard>
 <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 13, 2018 at 10:27:56PM -0500, Vijay Chidambaram wrote:
> Hi Dave,
> 
> Thanks for the reply.
> 
> I feel like we are not talking about the same thing here.
> 
> What we are asking is: if you perform
> 
> fsync(symlink)
> crash
> 
> can we expect it to see the symlink file in the parent directory after
> a crash given we didn't fsync the parent directory? Amir argues we
> can't expect it. Your first email seemed to argue we should expect it.

My first email comments on Amir's quoting of behaviours for files vs
directories on fsync, and then applying those caveats to symlinks.
It probably wasn't that clear I was mainly trying to point out that
symlinks are not files, so they have different ordering
requirements. i.e. that you have to look at ordering requirements of
the filesystems, not the fsync() specification to determine what the
fsync behviour is supposed to be.

My second email clarifies the ordering behaviour that is expected
with symlinks and the reason why you'll see different behaviour to
files w.r.t. fsync and parent directories.

> ext4 and xfs have this behavior, which Amir argues is an
> implementation side-effect, and not intended.
> 
> >> >>> 1. symlink (foo, bar.tmp)
> >> >>> 2. open bar.tmp
> >> >>> 3. fsync bar.tmp
> >> >>> 4. rename(bar.tmp, bar)
> >> >>> 5. fsync bar
> >> >>> ----crash here----
> 
> The second workload that Amir constructed just moves the symlink
> creation into a different transaction. In both workloads, we are
> creating or renaming new symlinks and calling fsync on them. In both
> cases we are not explicitly calling fsync on the parent directory.

Yes, I decided not to write all this "symlink behaviour is dependent
on initial conditions" stuff because, AFAIC, it is a pretty obvious
conclusion to draw from the ordering dependencies I described
between the symlink and the object it points at.

Script that demonstrates this is simple:

$ cat t.sh
#!/bin/bash

dev=/dev/vdb
mnt=/mnt/scratch
test_file=$mnt/foo

# 1. symlink (foo, bar.tmp)
# 2. open bar.tmp
# 3. fsync bar.tmp
# 4. rename(bar.tmp, bar)
# 5. fsync bar

umount $mnt
mount $dev $mnt

cd $mnt
rm -f foo bar.tmp bar
sync

# Don't fsync creation of foo, will see foo and bar.tmp after shutdown
touch foo
ln -s foo bar.tmp
xfs_io -c fsync bar.tmp
mv bar.tmp bar
xfs_io -c fsync bar
xfs_io -xc "shutdown" $mnt

cd ~
umount $mnt
mount $dev $mnt
cd $mnt
ls -l $mnt
rm -f foo bar.tmp bar
sync

# don't fsync foo or bar.tmp, will see foo and bar after shutdown
touch foo
xfs_io -c fsync foo

touch foo
ln -s foo bar.tmp
mv bar.tmp bar
xfs_io -c fsync bar
xfs_io -xc "shutdown" $mnt


cd ~
umount $mnt
mount $dev $mnt
cd $mnt
ls -l $mnt
rm -f foo bar.tmp bar
sync

# fsync creation of foo, will see only foo after shutdown
touch foo
xfs_io -c fsync foo

ln -s foo bar.tmp
xfs_io -c fsync bar.tmp
mv bar.tmp bar
xfs_io -c fsync bar
xfs_io -xc "shutdown" $mnt

cd ~
umount $mnt
mount $dev $mnt
cd $mnt
ls -l $mnt
$

And the output is:

$ sudo umount /mnt/scratch ; sudo mount /dev/vdb /mnt/scratch ; sudo ./t.sh ;
total 0
lrwxrwxrwx. 1 root root 3 Apr 14 09:52 bar.tmp -> foo
-rw-r--r--. 1 root root 0 Apr 14 09:52 foo
total 0
lrwxrwxrwx. 1 root root 3 Apr 14 09:52 bar -> foo
-rw-r--r--. 1 root root 0 Apr 14 09:52 foo
total 0
-rw-r--r--. 1 root root 0 Apr 14 09:52 foo
$

i.e. it depends on the state of the original file as to what is
captured by the fsync of that file through the symlink. i.e.
symlinks has no ordering dependency with the object resolved from
the path in the symlink.


> Note that we are not saying if we call fsync on symlink file, it
> should call fsync on the original file. We agree that should not be
> done as the symlink file and the original link are two distinct
> entities.

"symlink file" - there's no such thing. It's either a symlink or a
regular file and it cant be both. 

And, well, you can't fsync a symlink *inode*, anyway, because you
can't open it directly for IO operations.

> I believe in most journaling/copy-on-write file systems today, if you
> call fsync on a new file, the fsync will persist the directory entry
> of the new file in the parent directory (even though POSIX doesn't
> really require this).

Yes, that's the strict ordering dependency thing I talked about, and
it was something that btrfs got wrong for an awful long time.

> It seems reasonable to extend this persistence
> courtesy to symlinks (considering them just as normal files).

And no, that's not reasonable, because symlinks only contain a path
instead of a direct reference to any filesysetm object. i.e. it's an
indirect reference, and that can be clearly seen by the fact that
Symlinks are created and removed without referencing the object they
point to or caring whether it is even valid.

There is no way reliable ordering dependencies can be created for
indirect references, especially as symlinks can point to any type of
object (e.g. dir, blkdev, etc), it can point to something outside
the filesystem, and it can even point to something that doesn't
exist.

This also means that "fsync on a symlink" may, in fact, run a fsync
method of a completely different filesystem or subsystem. There is
no way this could possible trigger a directory fsync of the symlink
parent, because the object being fsync()d may not even know what a
filesystem is...

If you want a symlink to have ordering behaviour like a dirent
pointing to a regular file, then use hard links....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
