Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47415 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754043AbcHAPYK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Aug 2016 11:24:10 -0400
Subject: Re: A lot warnings in dmesg while running thunderbird
To: Dave Chinner <david@fromorbit.com>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <ab5cc111-7ed7-3209-7411-6c656892d4a3@fb.com>
 <CAEJqkgiWOnyk8AzROc-tGTqKiDJkCt364tgFT5P-2Sa+XwjeMA@mail.gmail.com>
 <b84d72ce-3221-1f0d-7f63-ae02fe0d776b@fb.com>
 <47ff1ea1-d4a9-55d9-f65d-60e94be93146@gmail.com>
 <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
 <20160725003630.GT16044@dastard>
CC: Gabriel C <nix.or.die@gmail.com>, <linux-btrfs@vger.kernel.org>,
        <quwenruo@cn.fujitsu.com>
From: Chris Mason <clm@fb.com>
Message-ID: <4c995d9b-4bf5-368c-ac2e-531ee9f4bf18@fb.com>
Date: Mon, 1 Aug 2016 11:23:25 -0400
MIME-Version: 1.0
In-Reply-To: <20160725003630.GT16044@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/24/2016 08:36 PM, Dave Chinner wrote:
> On Fri, Jul 08, 2016 at 12:02:35PM -0400, Chris Mason wrote:
>> Can you please run the attached test program:
>>
>> gcc -o short-write short-write.c -lpthread
>> ./short-write some-new-file-on-btrfs
>
> Hi Chris, this seems like a useful thing to be testing on a regular
> basis - can you turn this into an xfstests regression test and
> submit it?
>

[ vacation backlog delay apologies ]

Hi Dave,

The test is just a thread constantly madvising away the memory being 
used for IO.  It would be interesting to add a --evil option to either 
xfs_io or fsx so the evil is compounded across all of the existing xfstests.

-chris
