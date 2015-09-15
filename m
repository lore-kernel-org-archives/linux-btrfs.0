Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13442 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754576AbbIOP4n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 11:56:43 -0400
Subject: Re: [PATCH V2] Btrfs: keep dropped roots in cache until transaction
 commit
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        <linux-btrfs@vger.kernel.org>
References: <1442326024-2536-1-git-send-email-jbacik@fb.com>
 <55F83E34.3090900@googlemail.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <55F83FB7.8010801@fb.com>
Date: Tue, 15 Sep 2015 11:56:39 -0400
MIME-Version: 1.0
In-Reply-To: <55F83E34.3090900@googlemail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2015 11:50 AM, Holger Hoffstätte wrote:
> On 09/15/15 16:07, Josef Bacik wrote:
>> When dropping a snapshot we need to account for the qgroup changes.  If we drop
>> the snapshot in all one go then the backref code will fail to find blocks from
>> the snapshot we dropped since it won't be able to find the root in the fs root
>> cache.  This can lead to us failing to find refs from other roots that pointed
>> at blocks in the now deleted root.  To handle this we need to not remove the fs
>> roots from the cache until after we process the qgroup operations.  Do this by
>> adding dropped roots to a list on the transaction, and letting the transaction
>> remove the roots at the same time it drops the commit roots.  This will keep all
>> of the backref searching code in sync properly, and fixes a problem Mark was
>> seeing with snapshot delete and qgroups.  Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>> V1->V2:
>> -clear the trans tag when we are finished dropping the subvol so we don't try to
>>    update the root during commit.
>
> This V2 does indeed seem to fix the issues I reported with snapshot deletion &
> concurrent sync. I've now created/filled/deleted countless snapshots while issuing
> sync(s) in parallel, and the problem that I saw fairly frequently with V1 no longer
> seems to occur here. Therefore:
>
> Tested-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
>
> Thanks for the quick fix, Josef!
>

Great thanks,

Josef

