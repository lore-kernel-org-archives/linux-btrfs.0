Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34891 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878AbaHLTI6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 15:08:58 -0400
Message-ID: <53EA6641.4070003@fb.com>
Date: Tue, 12 Aug 2014 15:08:49 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 2/5] btrfs: qgroup: account shared subtrees during snapshot
 delete
References: <1405625944-4883-1-git-send-email-mfasheh@suse.de> <1405625944-4883-3-git-send-email-mfasheh@suse.de> <53EA5B67.7040109@fb.com> <20140812183216.GR2203@wotan.suse.de> <53EA5EA1.8090505@fb.com> <20140812190110.GS2203@wotan.suse.de>
In-Reply-To: <20140812190110.GS2203@wotan.suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/12/2014 03:01 PM, Mark Fasheh wrote:
> On Tue, Aug 12, 2014 at 02:36:17PM -0400, Chris Mason wrote:
>>
>>
>> On 08/12/2014 02:32 PM, Mark Fasheh wrote:
>>> On Tue, Aug 12, 2014 at 02:22:31PM -0400, Chris Mason wrote:
>>>>
>>>>
>>>> On 07/17/2014 03:39 PM, Mark Fasheh wrote:
>>>>> During its tree walk, btrfs_drop_snapshot() will skip any shared
>>>>> subtrees it encounters. This is incorrect when we have qgroups
>>>>> turned on as those subtrees need to have their contents
>>>>> accounted. In particular, the case we're concerned with is when
>>>>> removing our snapshot root leaves the subtree with only one root
>>>>> reference.
>>>>>
>>>>> In those cases we need to find the last remaining root and add
>>>>> each extent in the subtree to the corresponding qgroup exclusive
>>>>> counts.
>>>>>
>>>>> This patch implements the shared subtree walk and a new qgroup
>>>>> operation, BTRFS_QGROUP_OPER_SUB_SUBTREE. When an operation of
>>>>> this type is encountered during qgroup accounting, we search for
>>>>> any root references to that extent and in the case that we find
>>>>> only one reference left, we go ahead and do the math on it's
>>>>> exclusive counts.
>>>>>
>>>>> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
>>>>> Reviewed-by: Josef Bacik <jbacik@fb.com>
>>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>>> index 813537f..1aa4325 100644
>>>>> --- a/fs/btrfs/extent-tree.c
>>>>> +++ b/fs/btrfs/extent-tree.c
>>>>> @@ -8078,6 +8331,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>>>>>  	}
>>>>>  	root_dropped = true;
>>>>>  out_end_trans:
>>>>> +	ret = btrfs_delayed_qgroup_accounting(trans, root->fs_info);
>>>>                                                      ^^^^^^^^^^^
>>>>
>>>> CONFIG_DEBUG_PAGEALLOC noticed that root is already free at this point.
>>>>  I switched it to tree_root instead ;)
>>>
>>> Oh nice catch, thanks for pointing it out.
>>>
>>> Time to go update my suse patches.
>>
>> Grin, pretty sure it doesn't count as a catch if CONFIG_DEBUG_PAGEALLOC
>> finds it.
> 
> Fair enough, on my end I get to add CONFIG_DEBUG_PAGEALLOC to my testing :)

Best debugging feature ever!

> 
>> But it did make it through the balance test we were crashing
>> in before.  It's probably faster to hand edit the incremental in for the
>> suse patch, but here you go just in case:
> 
> Yeah we haven't hit anything internally and like I said we've been running
> with it for a while. It's probably hard to hit as I can promise that code
> has been executed more than a couple times by now.
> 
> The delete-items path is definitely broken so maybe you hit something from
> that?
> 

I had that one removed, so it was just the s/root/tree_root/ I needed.

> Btw, I should be sending a two-liner fix that can be extracted from the
> delete-items patch soon.

Great, thanks.

-chris
