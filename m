Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30867 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965467AbaFSXRa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 19:17:30 -0400
Message-ID: <53A36F85.60607@fb.com>
Date: Thu, 19 Jun 2014 16:17:25 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: btrfs: qgroup: account shared subtrees during snapshot delete
References: <1403214567-3137-1-git-send-email-mfasheh@suse.de> <1403214567-3137-3-git-send-email-mfasheh@suse.de> <53A36348.4010106@fb.com> <20140619231626.GQ5484@wotan.suse.de>
In-Reply-To: <20140619231626.GQ5484@wotan.suse.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/19/2014 04:16 PM, Mark Fasheh wrote:
> Thanks for the review Josef, I will implement everything you mentioned. I
> have one question below though:
>
> On Thu, Jun 19, 2014 at 03:25:12PM -0700, Josef Bacik wrote:
>> On 06/19/2014 02:49 PM, Mark Fasheh wrote:
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 46f39bf..672d2a4 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -7472,6 +7703,9 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>>>
>>>    	if (wc->stage == DROP_REFERENCE) {
>>>    		if (wc->refs[level - 1] > 1) {
>>> +			account_shared_subtree(trans, root, next, generation,
>>> +					       level - 1);
>>> +
>>
>> We don't pay attention to the return value, we should probably abort the
>> transaction if there is a problem.
>
> Abort or log an error and continue? I ask because technically we could
> continue with the subvolume drop but obviously qgroup state will need to be
> fixed via a future rescan. I guess the question is which is more 'friendly'
> to the user.

I'd be ok with log an error and tell the user to rescan.  Thanks,

Josef
