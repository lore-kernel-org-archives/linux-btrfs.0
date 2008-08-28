From: jim owens <jowens@hp.com>
Subject: Re: Btrfs conf call
Date: Thu, 28 Aug 2008 13:44:38 -0400
Message-ID: <48B6E406.6010906@hp.com>
References: <1219843318.4477.89.camel@think.oraclecorp.com> <f058a9c30808280614p74763300g21a1102676b81dd6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30808280614p74763300g21a1102676b81dd6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Call summary:

Chris has been rewriting fsync to improve performance
    - 10X better multi-threaded scaling for regular files
    - directory fsync performance has not been addressed

Ric noted that Josef's fine-granularity timer work
in the main line could boost btrfs fsync performance.

Eric has seen single stream write performance drop
after v.15, his runs indicate allocator-induced stalls.

Josef is working on allocator fix round 3... round 2 had
regressions in some benchmarks.  Chris proposed he try a
design midway between the round 1 and round 2 code.

Eric noted build problems with older kernels (2.16.18 ?)
because of the btrfs NFS patch... needs volunteer to fix.

Eric and Chris discussed testing using some of the xfs
tests without using the complete harness suite.

More plumber's conference discussion, Chris's btrfs talk
will be fairly high level (as expected given where we are).
Attendance is expected to be good on all days including
the last day (so if I go, I won't leave early).  How to
set up the filesystem BOF is pending plumber's site update.
