Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35056 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756751AbeDZQ2h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 12:28:37 -0400
From: Chris Mason <clm@fb.com>
To: Jayashree Mohan <jayashree2912@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Subject: Re: Inconsistent behavior of fsync in btrfs
Date: Thu, 26 Apr 2018 10:28:22 -0600
Message-ID: <34B2B717-B12D-44F4-B0D0-E3D606BBEFA6@fb.com>
In-Reply-To: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24 Apr 2018, at 20:35, Jayashree Mohan wrote:

> Hi,
>
> While investigating crash consistency bugs on btrfs, we came across
> workloads that demonstrate inconsistent behavior of fsync.
>
> Consider the following workload where fsync on the directory did not 
> persist it.

> Only file B/foo gets persisted, and both A/foo and C/foo are missing.
>
> This seems like inconsistent behavior as only the first fsync persists
> the file, while all others don't seem to. Do you agree if this is
> indeed incorrect and needs fixing?
>
> All the above tests pass on ext4 and xfs.
>
> Please let us know what you feel about such inconsistency.
>

The btrfs fsync log is more fine grained than xfs/ext, but fsync(any 
file) should be enough to persist that file in its current directory.

I'll get these reproduced and see if we can nail down why we're not 
logging the location properly.

-chris
