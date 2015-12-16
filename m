Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48297 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846AbbLPAkb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 19:40:31 -0500
Subject: Re: Will "btrfs check --repair" fix the mounting problem?
To: Ivan Sizov <sivan606@gmail.com>
References: <566b0cff.pXiyzYE4dYIOt31+%sivan606@gmail.com>
 <CAJCQCtTLrGin24rFGdvYV-JcegEgGEE7qK3gAYSd8K_SXFeu=g@mail.gmail.com>
 <566E2934.1090207@cn.fujitsu.com>
 <CAMG9ccy_Du3WOm_yAak_L8UnuiBCcf=1f4ybGzTUxC5iFJfaiQ@mail.gmail.com>
 <566F7007.4040503@cn.fujitsu.com>
 <CAMG9ccy_LKZeGRtPqffpXM8YD4NmDwAxyfr5iPz37j0+OjL4wg@mail.gmail.com>
CC: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5670B2F5.2010201@cn.fujitsu.com>
Date: Wed, 16 Dec 2015 08:40:21 +0800
MIME-Version: 1.0
In-Reply-To: <CAMG9ccy_LKZeGRtPqffpXM8YD4NmDwAxyfr5iPz37j0+OjL4wg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Ivan Sizov wrote on 2015/12/15 09:34 +0000:
> 2015-12-15 1:42 GMT+00:00 Qu Wenruo <quwenruo@cn.fujitsu.com>:
>> You'll see output like the following:
>> Well block 29491200(gen: 5 level: 0) seems good, and it matches superblock
>> Well block 29376512(gen: 4 level: 0) seems good, but generation/level
>> doesn't match, want gen: 5 level: 0
>>
>> The match one is not what you're looking for.
>> Try the one whose generation is a little smaller than match one.
>>
>> Then use btrfsck to test if it's OK:
>> $ btrfsck -r <BYTENR> /dev/sda1
>>
>> Try 2~5 times with bytenr whose generation is near the match one.
>> If you're in good luck, you will find one doesn't crash btrfsck.
>>
>> And if that doesn't produce much error, then you can try btrfsck --repair -r
>> <BYTENR> to fix it and try mount.
>
> I've found a root that doesn't produce backtrace. But extent/chunk
> allocation errors was found:
>
> $ sudo btrfsck --tree-root 535461888 /dev/sda1
> parent transid verify failed on 535461888 wanted 21154 found 21150
> parent transid verify failed on 535461888 wanted 21154 found 21150
> Ignoring transid failure
> checking extents
> parent transid verify failed on 459292672 wanted 21148 found 21153
> parent transid verify failed on 459292672 wanted 21148 found 21153

Transid failure is OK.

> Ignoring transid failure
> bad block 459292672
> Errors found in extent allocation tree or chunk allocation
> parent transid verify failed on 459292672 wanted 21148 found 21153
>
> Should I ignore those errors and run btrfsck --repair? Or
> --init-extent-tree is needed?
>
Did it btrfsck has other complain?
And how is the generation difference between the one you're using and 
the one in superblock?

If the generation difference is larger than 1, I'd recommend not to run 
'--repair' nor '--init-extent-tree'

If the difference is only 1, and btrfsck doesn't report problems other 
than transid error, I'd like to try --repair or --init-extent-tree.

But there is *NO* guarantee and it may still make case worse.

Thanks,
Qu


