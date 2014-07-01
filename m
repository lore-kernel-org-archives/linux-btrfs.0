Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50083 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605AbaGAOac (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 10:30:32 -0400
Message-ID: <53B2C5FA.1090808@fb.com>
Date: Tue, 1 Jul 2014 10:30:18 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: build failure with mason/for-linus tree
References: <53B24A86.1050802@jp.fujitsu.com>
In-Reply-To: <53B24A86.1050802@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/2014 01:43 AM, Satoru Takeuchi wrote:
> Hi Chris,
> 
> FYI, today I failed to build mason/for-linus tree as follows.
> 

You were building for 3.15?

> ===============================================================================
> ...
> /home/sat/src/linux-2.6/fs/btrfs/transaction.c: In function 'record_root_in_trans':
> /home/sat/src/linux-2.6/fs/btrfs/transaction.c:293:3: error: implicit declaration of function 'smp_mb__before_atomic' [-Werror=implicit-function-declaration]
>    smp_mb__before_atomic();
>    ^
> /home/sat/src/linux-2.6/fs/btrfs/transaction.c: In function 'commit_fs_roots':
> /home/sat/src/linux-2.6/fs/btrfs/transaction.c:1065:4: error: implicit declaration of function 'smp_mb__after_atomic' [-Werror=implicit-function-declaration]
>     smp_mb__after_atomic();
>     ^
> cc1: some warnings being treated as errors
> ...
> ===============================================================================
> 
> It can be solved by cherry-picking febdbfe.
> 
> ===
> commit febdbfe8a91ce0d11939d4940b592eb0dba8d663
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Thu Feb 6 18:16:07 2014 +0100
> 
>     arch: Prepare for smp_mb__{before,after}_atomic()
>     
>     Since the smp_mb__{before,after}*() ops are fundamentally dependent on
>     how an arch can implement atomics it doesn't make sense to have 3
>     variants of them. They must all be the same.

Yes, or revert:

commit c7548af69d9ef71512eb52d8009521eba3e768fd
Author: Chris Mason <clm@fb.com>
Date:   Tue Jun 10 13:06:56 2014 -0700

    Btrfs: convert smp_mb__{before,after}_clear_bit

    The new call is smp_mb__{before,after}_atomic.  The __ gives us extra
    protection from the atomic rays.

    Signed-off-by: Chris Mason <clm@fb.com>

Which is only needed on 3.16+

I should have put this one into a 3.16 only branch, it was a mistake on
my end.

-chris
