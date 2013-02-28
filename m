Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:40687 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3B1ADD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 19:03:03 -0500
Received: by mail-da0-f45.google.com with SMTP id v40so556125dad.4
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 16:03:02 -0800 (PST)
Message-ID: <512E9EAC.9050700@gmail.com>
Date: Thu, 28 Feb 2013 08:02:52 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: xfstests <xfs@oss.sgi.com>, linux-btrfs@vger.kernel.org,
        list.btrfs@jan-o-sch.net
Subject: Re: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
References: <512DB284.1090806@gmail.com> <20130227230443.GB5551@dastard>
In-Reply-To: <20130227230443.GB5551@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013年02月28日 07:04, Dave Chinner wrote:
> On Wed, Feb 27, 2013 at 03:15:16PM +0800, Wang Sheng-Hui wrote:
>> Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by
>> -x option of filefrag, and will fail with
>> 	'FIBMAP: Invalid argument'
>> for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
>>      'FIEMAP failed with unsupported flags 2'
>> Remove the '-x' option.
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>
> I can see that this changes what gets dumped into the $seq.full
> file, but it seems to me that also changes the extent list returned
> to the checking functions. So either the test previously worked and
> now it fails with this change, or the test never worked and now it
> does, or perhaps something else?
>
> IOWs, I can't tell why you want to change this from the patch
> description, hence I don't know if the original behaviour was
> intentional or not.  Can you say describe what the overall effect of
> the change is in the commit description?

Hi Dave,

I run xfstests for btrfs against SLES11SP2, not upstream kernel.
In the seq.full, I can get the messages
	'FIEMAP failed with unsupported flags 2'

Then I found that the test will run 'filefrag -vx' on btrfs, and
'-v' will run FIEMAP_FLAG_XATTR, which is not supported by btrfs
yet, at least in 3.8 kernel.

Without the patch, I failed the testcase and got:
=============================================
276 8s ... - output mismatch (see 276.out.bad)
     --- 276.out	2013-02-25 19:08:58.000000000 -0600
     +++ 276.out.bad	2013-02-27 17:59:48.000000000 -0600
     @@ -1,4 +1,867 @@
      QA output created by 276
      *** test backref walking
     +FIBMAP: Invalid argument
     +FIBMAP: Invalid argument
     +FIBMAP: Invalid argument
     +FIBMAP: Invalid argument
     +FIBMAP: Invalid argument
      ...
      (Run 'diff -u 276.out 276.out.bad' to see the entire diff)
Ran: 276
Failures: 276
Failed 1 of 1 tests

In the 276.full, I got something like:
=============================================
# filefrag -vx /mnt/scratch/snap1/p0/d4/d21/d4a/f58
Filesystem type is: 9123683e
File size of /mnt/scratch/snap1/p0/d4/d21/d4a/f58 is 2125615 (33 blocks, blocksize 65536)
FIEMAP failed with unsupported flags 2


With the patch, I can pass the testcase:
=============================================
276 8s ... 7s
Ran: 276
Passed all 1 tests


>
> Cheers,
>
> Dave.
>

