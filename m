Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from newman.cs.utexas.edu ([128.83.139.110]:40126 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751270AbeDQC5Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 22:57:25 -0400
MIME-Version: 1.0
Reply-To: vijay@cs.utexas.edu
In-Reply-To: <20180417000736.GI23861@dastard>
References: <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com>
 <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
 <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com>
 <20180414012017.GF5572@dastard> <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
 <20180414215529.GG5572@dastard> <20180415011735.GB21830@thunk.org>
 <CAHWVdUXAyyeTGNXrtTTc+tUbA3t9TUjJPSF=M4Cetj4+d1w3eQ@mail.gmail.com>
 <20180415141338.GA22870@thunk.org> <CAPaz=ELkYavvWYuMg=t+L_nSZ7fZ8CkaZr-qfGVN3QfydbOh7w@mail.gmail.com>
 <20180417000736.GI23861@dastard>
From: Vijay Chidambaram <vijay@cs.utexas.edu>
Date: Mon, 16 Apr 2018 21:56:36 -0500
Message-ID: <CAPaz=ELss9aV71StqYLzjRuHNpkQ=WmWWrcUwd2igydkjCrh9g@mail.gmail.com>
Subject: Re: Symlink not persisted even after fsync
To: Dave Chinner <david@fromorbit.com>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jayashree Mohan <jayashree2912@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 16, 2018 at 7:07 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Apr 15, 2018 at 07:10:52PM -0500, Vijay Chidambaram wrote:
>> Thanks! As I mentioned before, this is useful. I have a follow-up
>> question. Consider the following workload:
>>
>>  creat foo
>>  link (foo, A/bar)
>>  fsync(foo)
>>  crash
>>
>> In this case, after the file system recovers, do we expect foo's link
>> count to be 2 or 1?
>
> So, strictly ordered behaviour:
>
> create foo:
>         - creates dirent in inode B and new inode A in an atomic
>           transaction sequence #1
>
> link foo -> A/bar
>         - creates dirent in inode C and bumps inode A link count in
>           an atomic transaction seqeunce #2.
>
> fsync foo
>         - looks at inode A, sees it's "last modification" sequence
>           counter as #2
>         - flushes all transactions up to and including #2 to the
>           journal.
>
> See the dependency chain? Both the inodes and dirents in the create
> operation and the link operation are chained to the inode foo via
> the atomic transactions. Hence when we flush foo, we also flush the
> dependent changes because of the change atomicity requirements....
>
>> I would say 2,
>
> Correct, for strict ordering. But....
>
>> but POSIX is silent on this,
>
> Well, it's not silent, POSIX explicitly allows for fsync() to do
> nothing and report success. Hence we can't really look to POSIX to
> define how fsync() should behave.
>
>> so
>> thought I would confirm. The tricky part here is we are not calling
>> fsync() on directory A.
>
> Right. But directory A has a dependent change linked to foo. If we
> fsync() foo, we are persisting the link count change in that file,
> and hence all the other changes related to that link count change
> must also be flushed. Similarly, all the cahnges related to the
> creation on foo must be flushed, too.
>
>> In this case, its not a symlink; its a hard link, so I would say the
>> link count for foo should be 2.
>
> Right - that's the "reference counted object dependency" I refered
> to. i.e. it's a bi-direction atomic dependency - either we show both
> the new dirent and the link count change, or we show neither of
> them.  Hence fsync on one object implies that we are also persisting
> the related changes in the other object, too.
>
>> But btrfs and F2FS show link count of
>> 1 after a crash.
>
> That may be valid if the dirent A/bar does not exist after recovery,
> but it also means fsync() hasn't actually guaranteed inode changes
> made prior to the fsync to be persistent on disk. i.e. that's a
> violation of ordered metadata semantics and probably a bug.

Great, this matches our understanding perfectly. We have separately
posted to the btrfs mailing list to confirm it is a bug. Thanks!
