Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58255 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbaGAXmg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 19:42:36 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 828243EE1DD
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 08:42:34 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 85C2FAC03EA
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 08:42:33 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 25E321DB8040
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 08:42:33 +0900 (JST)
Message-ID: <53B34742.9020108@jp.fujitsu.com>
Date: Wed, 2 Jul 2014 08:41:54 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: build failure with mason/for-linus tree
References: <53B24A86.1050802@jp.fujitsu.com> <53B2C5FA.1090808@fb.com>
In-Reply-To: <53B2C5FA.1090808@fb.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

(2014/07/01 23:30), Chris Mason wrote:
> On 07/01/2014 01:43 AM, Satoru Takeuchi wrote:
>> Hi Chris,
>>
>> FYI, today I failed to build mason/for-linus tree as follows.
>>
> 
> You were building for 3.15?

I just run the following command to confirm whether the latest
for-linux tree can build or not.

$ git checkout -b mason-for-linus mason/for-linus
$ make

Then that error happens and It's just FYI.

Thanks,
Satoru

> 
>> ===============================================================================
>> ...
>> /home/sat/src/linux-2.6/fs/btrfs/transaction.c: In function 'record_root_in_trans':
>> /home/sat/src/linux-2.6/fs/btrfs/transaction.c:293:3: error: implicit declaration of function 'smp_mb__before_atomic' [-Werror=implicit-function-declaration]
>>     smp_mb__before_atomic();
>>     ^
>> /home/sat/src/linux-2.6/fs/btrfs/transaction.c: In function 'commit_fs_roots':
>> /home/sat/src/linux-2.6/fs/btrfs/transaction.c:1065:4: error: implicit declaration of function 'smp_mb__after_atomic' [-Werror=implicit-function-declaration]
>>      smp_mb__after_atomic();
>>      ^
>> cc1: some warnings being treated as errors
>> ...
>> ===============================================================================
>>
>> It can be solved by cherry-picking febdbfe.
>>
>> ===
>> commit febdbfe8a91ce0d11939d4940b592eb0dba8d663
>> Author: Peter Zijlstra <peterz@infradead.org>
>> Date:   Thu Feb 6 18:16:07 2014 +0100
>>
>>      arch: Prepare for smp_mb__{before,after}_atomic()
>>      
>>      Since the smp_mb__{before,after}*() ops are fundamentally dependent on
>>      how an arch can implement atomics it doesn't make sense to have 3
>>      variants of them. They must all be the same.
> 
> Yes, or revert:
> 
> commit c7548af69d9ef71512eb52d8009521eba3e768fd
> Author: Chris Mason <clm@fb.com>
> Date:   Tue Jun 10 13:06:56 2014 -0700
> 
>      Btrfs: convert smp_mb__{before,after}_clear_bit
> 
>      The new call is smp_mb__{before,after}_atomic.  The __ gives us extra
>      protection from the atomic rays.
> 
>      Signed-off-by: Chris Mason <clm@fb.com>
> 
> Which is only needed on 3.16+
> 
> I should have put this one into a 3.16 only branch, it was a mistake on
> my end.
> 
> -chris
> 

