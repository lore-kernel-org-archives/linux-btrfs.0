Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39332 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933213AbeD0P1K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 11:27:10 -0400
From: Chris Mason <clm@fb.com>
To: Jayashree Mohan <jayashree2912@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Filipe Manana <fdmanana@kernel.org>
Subject: Re: Inconsistent behavior of fsync in btrfs
Date: Fri, 27 Apr 2018 09:26:46 -0600
Message-ID: <7478A00B-2693-4E8A-BD0B-2D81C406170F@fb.com>
In-Reply-To: <CA+EzBbBaZjcdHi4O4W8LZ2JvpYhN_hFGvktaeFYRfSygW3sK7A@mail.gmail.com>
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
 <34B2B717-B12D-44F4-B0D0-E3D606BBEFA6@fb.com>
 <CA+EzBbBaZjcdHi4O4W8LZ2JvpYhN_hFGvktaeFYRfSygW3sK7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 26 Apr 2018, at 18:59, Jayashree Mohan wrote:

> Hi Chris,
>
> Thanks for the response. We are using a tool we developed called
> CrashMonkey[1] to run crash consistency tests and generate the bug
> reports above. We'd be happy to guide you through setting up
> CrashMonkey and getting these bugs reproduced. However, if you want to
> be able to reproduce them with your current setup (xfstest +
> dm-flakey), I have the workload scripts attached to the end of the
> mail which might make your task simpler.
>
> Interestingly we seem to have found another bug that breaks rename
> atomicity and results in a previously fsynced file missing.
>
> Workload:
> 1. mkdir A
> 2. creat A/bar (*)
> 3. fsync A/bar
> 4. mkdir B
> 5. creat B/bar
> 6. rename B/bar A/bar
> 7. creat A/foo
> 8. fsync A/foo
> 9. fsync A

The original workloads have been easy to reproduce/fix so far.  I want 
to make sure my patches aren't slowing things down and I'll send them 
out ~Monday.

This one looks similar but I'll double check the rename handling and 
make sure I've got all the cases.

-chris
