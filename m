Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1111 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbcDVSYL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 14:24:11 -0400
Subject: Re: [PATCH v4] btrfs: qgroup: Fix qgroup accounting when creating
 snapshot
To: Mark Fasheh <mfasheh@suse.de>
References: <1460711302-2478-1-git-send-email-quwenruo@cn.fujitsu.com>
 <571A697B.6050502@fb.com> <20160422182148.GZ2187@wotan.suse.de>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>,
        <fdmanana@suse.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <571A6C3F.1010704@fb.com>
Date: Fri, 22 Apr 2016 14:23:59 -0400
MIME-Version: 1.0
In-Reply-To: <20160422182148.GZ2187@wotan.suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/22/2016 02:21 PM, Mark Fasheh wrote:
> On Fri, Apr 22, 2016 at 02:12:11PM -0400, Josef Bacik wrote:
>> On 04/15/2016 05:08 AM, Qu Wenruo wrote:
>>> +	/*
>>> +	 * Force parent root to be updated, as we recorded it before so its
>>> +	 * last_trans == cur_transid.
>>> +	 * Or it won't be committed again onto disk after later
>>> +	 * insert_dir_item()
>>> +	 */
>>> +	if (!ret)
>>> +		record_root_in_trans(trans, parent, 1);
>>> +	return ret;
>>> +}
>>
>> NACK, holy shit we aren't adding a special transaction commit only
>> for qgroup snapshots.  Figure out a different way.  Thanks,
>
> Yeah I saw that. To be fair, we run a whole lot of the transaction stuff
> multiple times (at least from my reading) so I'm really unclear on what the
> performance impact is.
>
> Do you have any suggestion though? We've been banging our heads against this
> for a while now and as slow as this patch might be, it actually works where
> nothing else has so far.

I'm less concerned about committing another transaction and more 
concerned about the fact that it is an special variant of the 
transaction commit.  If this goes wrong, or at some point in the future 
we fail to update it along with btrfs_transaction_commit we suddenly are 
corrupting metadata.  If we have to commit a transaction then call 
btrfs_commit_transaction(), don't open code a stripped down version, 
here be dragons.  Thanks,

Josef

