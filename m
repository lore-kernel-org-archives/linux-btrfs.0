Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:62037 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3B1CGN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 21:06:13 -0500
Received: by mail-oa0-f41.google.com with SMTP id i10so2706840oag.14
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 18:06:13 -0800 (PST)
Message-ID: <512EBB84.3020301@gmail.com>
Date: Thu, 28 Feb 2013 10:05:56 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: xfstests <xfs@oss.sgi.com>, linux-btrfs@vger.kernel.org,
        list.btrfs@jan-o-sch.net, sandeen@redhat.com
Subject: Re: [PATCH] xfstests 276: fix error 'FIBMAP: Invalid argument'
References: <512DB284.1090806@gmail.com> <20130227230443.GB5551@dastard> <512E9EAC.9050700@gmail.com> <20130228002532.GJ5551@dastard>
In-Reply-To: <20130228002532.GJ5551@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013年02月28日 08:25, Dave Chinner wrote:
> On Thu, Feb 28, 2013 at 08:02:52AM +0800, Wang Sheng-Hui wrote:
>> On 2013年02月28日 07:04, Dave Chinner wrote:
>>> On Wed, Feb 27, 2013 at 03:15:16PM +0800, Wang Sheng-Hui wrote:
>>>> Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by
>>>> -x option of filefrag, and will fail with
>>>> 	'FIBMAP: Invalid argument'
>>>> for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
>>>>      'FIEMAP failed with unsupported flags 2'
>>>> Remove the '-x' option.
>>>>
>>>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>>>
>>> I can see that this changes what gets dumped into the $seq.full
>>> file, but it seems to me that also changes the extent list returned
>>> to the checking functions. So either the test previously worked and
>>> now it fails with this change, or the test never worked and now it
>>> does, or perhaps something else?
>>>
>>> IOWs, I can't tell why you want to change this from the patch
>>> description, hence I don't know if the original behaviour was
>>> intentional or not.  Can you say describe what the overall effect of
>>> the change is in the commit description?
>>
>> Hi Dave,
>>
>> I run xfstests for btrfs against SLES11SP2, not upstream kernel.
>> In the seq.full, I can get the messages
>> 	'FIEMAP failed with unsupported flags 2'
>>
>> Then I found that the test will run 'filefrag -vx' on btrfs, and
>> '-v' will run FIEMAP_FLAG_XATTR, which is not supported by btrfs
>> yet, at least in 3.8 kernel.
>
> Sure, I understand that. I'm not asking about how it fails - that
> much is obvious. What I am asking is:
>
> 	- did it ever work?
> 	- if it did, why did it start failing?
> 	- how long has it been broken for?
>
>> With the patch, I can pass the testcase:
>> =============================================
>> 276 8s ... 7s
>> Ran: 276
>> Passed all 1 tests
>
> Great, but why did it break in the first place? That's the
> information that needs to be in the commit message. Indeed, Eric has
> pointed out to us *exactly* the information that shoul dbe in the
> commit message. i.e. a description along the lines of:
>
> "Commit 05dadc0 ("Btrfs: add fiemap's flag check") added validity
> checks to the fiemap flags and hence invalid flags are now being
> rejected. Test 276 passes an invalid fiemap flag to btrfs, and so
> that test fails since this commit was added."
>
> That tells us exactly why the test failed, why the change is
> necessary, and how long the test has been broken for. Seen another
> way, it makes me wonder how often anyone runs xfstests on a btrfs
> dev tree or regression tests their own changes.
>
> Cheers,
>
> Dave.
>

Modify the commit message.
----------------------------------------------------------------

Per Eric, Commit 05dadc0 ("Btrfs: add fiemap's flag check") added
validity checks to the fiemap flags and hence invalid flags are now
being rejected. Test 276 passes an invalid fiemap flag to btrfs, and
so that test fails since this commit was added.

Btrfs doesn't support FIEMAP_FLAG_XATTR, which is enabled by -x option
of filefrag, and will fail with
	'FIBMAP: Invalid argument'
for 'filefrag -vx'. 'filefrag -vx' fails on btrfs with
     'FIEMAP failed with unsupported flags 2'
Remove the '-x' option.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  276 |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/276 b/276
index 082f943..f2b17c9 100755
--- a/276
+++ b/276
@@ -75,7 +75,7 @@ _filter_extents()

  _check_file_extents()
  {
-	cmd="filefrag -vx $1"
+	cmd="filefrag -v $1"
  	echo "# $cmd" >> $seq.full
  	out=`$cmd | _filter_extents`
  	if [ -z "$out" ]; then
-- 
1.7.10.4


