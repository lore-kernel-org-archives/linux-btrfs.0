Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from newman.cs.utexas.edu ([128.83.139.110]:59287 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeDND2q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Apr 2018 23:28:46 -0400
MIME-Version: 1.0
Reply-To: vijay@cs.utexas.edu
In-Reply-To: <20180414012017.GF5572@dastard>
References: <CA+EzBbCbRsZ=2qkBYjGVZQAVmUz34ky8vDOB7HxqRCrgymzysQ@mail.gmail.com>
 <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
 <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com>
 <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
 <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com> <20180414012017.GF5572@dastard>
From: Vijay Chidambaram <vijay@cs.utexas.edu>
Date: Fri, 13 Apr 2018 22:27:56 -0500
Message-ID: <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
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

Thanks for the reply.

I feel like we are not talking about the same thing here.

What we are asking is: if you perform

fsync(symlink)
crash

can we expect it to see the symlink file in the parent directory after
a crash given we didn't fsync the parent directory? Amir argues we
can't expect it. Your first email seemed to argue we should expect it.
ext4 and xfs have this behavior, which Amir argues is an
implementation side-effect, and not intended.

>> >>> 1. symlink (foo, bar.tmp)
>> >>> 2. open bar.tmp
>> >>> 3. fsync bar.tmp
>> >>> 4. rename(bar.tmp, bar)
>> >>> 5. fsync bar
>> >>> ----crash here----

The second workload that Amir constructed just moves the symlink
creation into a different transaction. In both workloads, we are
creating or renaming new symlinks and calling fsync on them. In both
cases we are not explicitly calling fsync on the parent directory.

Note that we are not saying if we call fsync on symlink file, it
should call fsync on the original file. We agree that should not be
done as the symlink file and the original link are two distinct
entities.

I believe in most journaling/copy-on-write file systems today, if you
call fsync on a new file, the fsync will persist the directory entry
of the new file in the parent directory (even though POSIX doesn't
really require this). It seems reasonable to extend this persistence
courtesy to symlinks (considering them just as normal files).

Thoughts from other btrfs developers?

Thanks,
Vijay Chidambaram
http://www.cs.utexas.edu/~vijay/

On Fri, Apr 13, 2018 at 8:20 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Apr 13, 2018 at 09:39:27AM -0500, Jayashree Mohan wrote:
>> Hey Dave,
>>
>> Thanks for clarifying the crash recovery semantics of strictly
>> metadata ordered filesystems. We had a follow-up question in this
>> case.
>>
>> On Fri, Apr 13, 2018 at 8:16 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> > On Fri, Apr 13, 2018 at 3:54 PM, Vijay Chidambaram <vijay@cs.utexas.edu> wrote:
>> >> Hi Amir,
>> >>
>> >> Thanks for the reply!
>> >>
>> >> On Fri, Apr 13, 2018 at 12:52 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> >>>
>> >>> Not a bug.
>> >>>
>> >>> From man 2 fsync:
>> >>>
>> >>> "Calling  fsync() does not necessarily ensure that the entry in the
>> >>>  directory containing the file has also reached disk.  For that an
>> >>>  explicit fsync() on a file descriptor for the directory is also needed."
>> >>
>> >>
>> >> Are we understanding this right:
>> >>
>> >> ext4 and xfs fsync the parent directory if a sym link file is fsync-ed. But
>> >> btrfs does not. Is this what we are seeing?
>> >
>> > Nope.
>> >
>> > You are seeing an unintentional fsync of parent, because both
>> > parent update and symlink update are metadata updates that are
>> > tracked by the same transaction.
>> >
>> > fsync of symlink forces the current transaction to the journal,
>> > pulling in the parent update with it.
>> >
>> >
>> >>
>> >> I agree that fsync of a file does not mean fsync of its directory entry, but
>> >> it seems odd to do it for regular files and not for sym links. We do not see
>> >> this behavior if we use a regular file instead of a sym link file.
>> >>
>> >
>> > fsync of regular file behaves differently than fsync of non regular file.
>> > I suggest this read:
>> > https://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-length-file-problem/
>> >
>> >>>
>> >>> There is a reason why this behavior is not being reproduces in
>> >>> ext4/xfs, but you should be able to reproduce a similar issue
>> >>> like this:
>> >>>
>> >>>

>> >>
>>
>> Going by your argument that all previous transactions that referenced
>> the file being fsync-ed needs to be committed, should we expect xfs
>> (and ext4) to persist file bar in this case?
>
> No, that's not what I'm implying. I'm implying that there is
> specific ordering dependencies that govern this behaviour, and
> assuming that what the fsync man page says about files applies to
> symlinks is not a valid assumption because files and symlinks are
> not equivalent objects.
>
> In these cases, you first have to ask "what are we actually running
> fsync on?"
>
> The fsync is being performed on the inode the symlink points to, not
> the symlink. You can't directly open a symlink to fsync the symlink.
>
> Then you have to ask "what is the dependency chain between the
> parent directory, the symlink and the file it points to?"
>
> the short answer is that symlinks have no direct relationship to the
> object they point to. i.e. symlinks contain a path, not a reference
> to a specific filesystem object.
>
> IOWs, symlinks are really a directory construct, not a file.
> However, there is no ordering dependency between a symlink and what
> it points to. symlinks contain a path which needs to be resolved to
> find out what it points to, and that may not even exist. Files have
> no reference to symlinks that point at them, so there's no way we
> can create an ordering dependency between file updates and any
> symlink that points to them.
>
> Directories, OTOH, contain a pointer to a reference counted object
> (an inode) in their dirents. hence if you add/remove directory
> dirents that point to an inode, you also have to modify the inode
> link counts as it records how many directory entries point at it.
> That's a bi-directional atomic modification ordering dependency
> between directories and inodes they point at.
>
> So when we look at symlinks, the parent directory has a ordering
> dependency with the symlink inode, not whatever is found by
> resolving the path in the symlink data. IOWs, there is no ordering
> relationship between the symlink's parent directory and whatever the
> symlink points at. i.e. it's a one-way relationship, and so there is
> no reverse ordering dependency that requires fsync() on the file to
> force synchronisation of a symlink it knows nothing about.
>
> i.e. the ordering dependency that exists with symlinks is between
> the symlink and it's parent directory, not whatever the symlink
> points to. Hence fsyncing whatever the symlink points to does not
> guarantee that the symlink is made stable because the symlink is not
> part of the dependency chain of the object being fsync()d....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
