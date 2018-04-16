Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from newman.cs.utexas.edu ([128.83.139.110]:38617 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbeDPPSg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 11:18:36 -0400
MIME-Version: 1.0
Reply-To: vijay@cs.utexas.edu
In-Reply-To: <CAOQ4uxgmGV=vBpbrnbr1CdRYKks6qs=7s+305h8kY64==BvuiA@mail.gmail.com>
References: <CA+EzBbCbRsZ=2qkBYjGVZQAVmUz34ky8vDOB7HxqRCrgymzysQ@mail.gmail.com>
 <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
 <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com>
 <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
 <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com>
 <20180414012017.GF5572@dastard> <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
 <20180414215529.GG5572@dastard> <20180415011735.GB21830@thunk.org>
 <CAHWVdUXAyyeTGNXrtTTc+tUbA3t9TUjJPSF=M4Cetj4+d1w3eQ@mail.gmail.com>
 <20180415141338.GA22870@thunk.org> <CAPaz=ELkYavvWYuMg=t+L_nSZ7fZ8CkaZr-qfGVN3QfydbOh7w@mail.gmail.com>
 <CAOQ4uxgmGV=vBpbrnbr1CdRYKks6qs=7s+305h8kY64==BvuiA@mail.gmail.com>
From: Vijay Chidambaram <vijay@cs.utexas.edu>
Date: Mon, 16 Apr 2018 10:17:49 -0500
Message-ID: <CAPaz=E+Z505Te46gnpO9xaF5tE9j5x9HK-ztFnRpiHfGo+yzfQ@mail.gmail.com>
Subject: Re: Symlink not persisted even after fsync
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Jayashree Mohan <jayashree2912@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 16, 2018 at 12:39 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Apr 16, 2018 at 3:10 AM, Vijay Chidambaram <vijay@cs.utexas.edu> wrote:
> [...]
>> Consider the following workload:
>>
>>  creat foo
>>  link (foo, A/bar)
>>  fsync(foo)
>>  crash
>>
>> In this case, after the file system recovers, do we expect foo's link
>> count to be 2 or 1? I would say 2, but POSIX is silent on this, so
>> thought I would confirm. The tricky part here is we are not calling
>> fsync() on directory A.
>>
>> In this case, its not a symlink; its a hard link, so I would say the
>> link count for foo should be 2. But btrfs and F2FS show link count of
>> 1 after a crash.
>>
>
> That sounds like a clear bug - nlink is metadata of inode foo, so
> should be made persistent by fsync(foo).

This is what we think as well. We have posted this as a separate
thread to confirm this with other btrfs developers.

> For non-journaled fs you would need to fsync(A) to guarantee
> seeing A/bar after crash, but for a journaled fs, if you didn't see
> A/bar after crash and did see nlink 2 on foo then you would get
> a filesystem inconsistency, so practically, fsync(foo) takes care
> of persisting A/bar entry as well. But as you already understand,
> these rules have not been formalized by a standard, instead, they
> have been "formalized" by various fsck.* tools.

I don't think fsck tools are very useful here: fsck could return the
file system to an empty state, and that would still be consistent.
fsck makes no guarantees about data loss. I think fsck is allow to
truncate files, remove directory entries etc. which could lead to data
loss.

But I agree the guarantees haven't been formalized.

> Allow me to suggest a different framing for CrashMonkey.
> You seem to be engaging in discussions with the community
> about whether X behavior is a bug or not and as you can see
> the answer depends on the filesystem (and sometimes on the
> developer). Instead, you could declare that CrashMonkey
> is a "Certification tool" to certify filesystems to a certain
> crash consistency behavior. Then you can discuss with the
> community about specific models that CrashMonkey should
> be testing. The model describes the implicit dependencies
> and ordering guaranties between operations.
> Dave has mentioned the "strictly ordered metadata" model.
> I do not know of any formal definition of this model for filesystems,
> but you can take a shot at starting one and encoding it into
> CrashMonkey. This sounds like a great paper to me.

This is a great idea! We will be submitting the basic CrashMonkey
paper soon, so I don't know if we have enough time to do this.
Currently, we just explicitly say this behavior is supported by ext4,
but not btrfs, etc. So the bugs are file-system specific. But we would
definitely consider doing this in the future.

Btw, such models are what we introduced in the ALICE paper that Ted
had mentioned before. We called them "Abstract Persistence Models",
but it was essentially the same idea.

> I don't know if Btrfs and f2fs will qualify as "strictly ordered
> metadata" and I don't know if they would want to qualify.
> Mind you a filesystem can be crash consistent without
> following "strictly ordered metadata". In fact, in many cases
> "strictly ordered metadata" imposes performance penalty by
> coupling together unrelated metadata updates (e.g. create
> A/a and create B/b), but it is also quite hard to decouple them
> because future operation can create a dependency (e.g.
> mv A/a B/b).

I agree that total ordering might lead to performance loss. I'm not
advocating for btrfs/F2FS to be totally ordered; I merely want them to
be clear about what guarantees they do provide.
