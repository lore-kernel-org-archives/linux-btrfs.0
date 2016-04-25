Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5685 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752255AbcDYA5F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Apr 2016 20:57:05 -0400
Subject: Re: [PATCH v4] btrfs: qgroup: Fix qgroup accounting when creating
 snapshot
To: Josef Bacik <jbacik@fb.com>, Mark Fasheh <mfasheh@suse.de>
References: <1460711302-2478-1-git-send-email-quwenruo@cn.fujitsu.com>
 <571A697B.6050502@fb.com> <20160422182148.GZ2187@wotan.suse.de>
 <571A6C3F.1010704@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <fdmanana@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <2ab669a3-33cf-e4a8-f8c6-02962f778cb3@cn.fujitsu.com>
Date: Mon, 25 Apr 2016 08:56:58 +0800
MIME-Version: 1.0
In-Reply-To: <571A6C3F.1010704@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Josef Bacik wrote on 2016/04/22 14:23 -0400:
> On 04/22/2016 02:21 PM, Mark Fasheh wrote:
>> On Fri, Apr 22, 2016 at 02:12:11PM -0400, Josef Bacik wrote:
>>> On 04/15/2016 05:08 AM, Qu Wenruo wrote:
>>>> +    /*
>>>> +     * Force parent root to be updated, as we recorded it before so
>>>> its
>>>> +     * last_trans == cur_transid.
>>>> +     * Or it won't be committed again onto disk after later
>>>> +     * insert_dir_item()
>>>> +     */
>>>> +    if (!ret)
>>>> +        record_root_in_trans(trans, parent, 1);
>>>> +    return ret;
>>>> +}
>>>
>>> NACK, holy shit we aren't adding a special transaction commit only
>>> for qgroup snapshots.  Figure out a different way.  Thanks,
>>
>> Yeah I saw that. To be fair, we run a whole lot of the transaction stuff
>> multiple times (at least from my reading) so I'm really unclear on
>> what the
>> performance impact is.
>>
>> Do you have any suggestion though? We've been banging our heads
>> against this
>> for a while now and as slow as this patch might be, it actually works
>> where
>> nothing else has so far.
>
> I'm less concerned about committing another transaction and more
> concerned about the fact that it is an special variant of the
> transaction commit.  If this goes wrong, or at some point in the future
> we fail to update it along with btrfs_transaction_commit we suddenly are
> corrupting metadata.  If we have to commit a transaction then call
> btrfs_commit_transaction(), don't open code a stripped down version,
> here be dragons.  Thanks,
>
> Josef
>
>
>
Yes, I also don't like the dirty hack.

Although the problem is, we have no other good choice.

If we can call commit_transaction() that's the best case, but the 
problem is, in create_pending_snapshots(), we are already inside 
commit_transaction().

Or commit_transaction() can be called inside commit_transaction()?

Thanks,
Qu


