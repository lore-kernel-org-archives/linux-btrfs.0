Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:43802 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752177AbeDPFjO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 01:39:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAPaz=ELkYavvWYuMg=t+L_nSZ7fZ8CkaZr-qfGVN3QfydbOh7w@mail.gmail.com>
References: <CA+EzBbCbRsZ=2qkBYjGVZQAVmUz34ky8vDOB7HxqRCrgymzysQ@mail.gmail.com>
 <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
 <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com>
 <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
 <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com>
 <20180414012017.GF5572@dastard> <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
 <20180414215529.GG5572@dastard> <20180415011735.GB21830@thunk.org>
 <CAHWVdUXAyyeTGNXrtTTc+tUbA3t9TUjJPSF=M4Cetj4+d1w3eQ@mail.gmail.com>
 <20180415141338.GA22870@thunk.org> <CAPaz=ELkYavvWYuMg=t+L_nSZ7fZ8CkaZr-qfGVN3QfydbOh7w@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Apr 2018 08:39:12 +0300
Message-ID: <CAOQ4uxgmGV=vBpbrnbr1CdRYKks6qs=7s+305h8kY64==BvuiA@mail.gmail.com>
Subject: Re: Symlink not persisted even after fsync
To: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Jayashree Mohan <jayashree2912@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 16, 2018 at 3:10 AM, Vijay Chidambaram <vijay@cs.utexas.edu> wrote:
[...]
> Consider the following workload:
>
>  creat foo
>  link (foo, A/bar)
>  fsync(foo)
>  crash
>
> In this case, after the file system recovers, do we expect foo's link
> count to be 2 or 1? I would say 2, but POSIX is silent on this, so
> thought I would confirm. The tricky part here is we are not calling
> fsync() on directory A.
>
> In this case, its not a symlink; its a hard link, so I would say the
> link count for foo should be 2. But btrfs and F2FS show link count of
> 1 after a crash.
>

That sounds like a clear bug - nlink is metadata of inode foo, so
should be made persistent by fsync(foo).

For non-journaled fs you would need to fsync(A) to guarantee
seeing A/bar after crash, but for a journaled fs, if you didn't see
A/bar after crash and did see nlink 2 on foo then you would get
a filesystem inconsistency, so practically, fsync(foo) takes care
of persisting A/bar entry as well. But as you already understand,
these rules have not been formalized by a standard, instead, they
have been "formalized" by various fsck.* tools.

Allow me to suggest a different framing for CrashMonkey.
You seem to be engaging in discussions with the community
about whether X behavior is a bug or not and as you can see
the answer depends on the filesystem (and sometimes on the
developer). Instead, you could declare that CrashMonkey
is a "Certification tool" to certify filesystems to a certain
crash consistency behavior. Then you can discuss with the
community about specific models that CrashMonkey should
be testing. The model describes the implicit dependencies
and ordering guaranties between operations.
Dave has mentioned the "strictly ordered metadata" model.
I do not know of any formal definition of this model for filesystems,
but you can take a shot at starting one and encoding it into
CrashMonkey. This sounds like a great paper to me.

I don't know if Btrfs and f2fs will qualify as "strictly ordered
metadata" and I don't know if they would want to qualify.
Mind you a filesystem can be crash consistent without
following "strictly ordered metadata". In fact, in many cases
"strictly ordered metadata" imposes performance penalty by
coupling together unrelated metadata updates (e.g. create
A/a and create B/b), but it is also quite hard to decouple them
because future operation can create a dependency (e.g.
mv A/a B/b).

Thanks,
Amir.
