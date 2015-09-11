Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35823 "EHLO
	m0041696.ppops.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752114AbbIKPoj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 11:44:39 -0400
Subject: Re: [PATCH] Btrfs: keep dropped roots in cache until transaciton
 commit
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-team@fb.com>, <mfasheh@suse.de>
References: <1441916850-19021-1-git-send-email-jbacik@fb.com>
 <55F22D8D.6090406@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <55F2F6C8.60307@fb.com>
Date: Fri, 11 Sep 2015 11:44:08 -0400
MIME-Version: 1.0
In-Reply-To: <55F22D8D.6090406@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/10/2015 09:25 PM, Qu Wenruo wrote:
>
>
> Josef Bacik wrote on 2015/09/10 16:27 -0400:
>> When dropping a snapshot we need to account for the qgroup changes.
>> If we drop
>> the snapshot in all one go then the backref code will fail to find
>> blocks from
>> the snapshot we dropped since it won't be able to find the root in the
>> fs root
>> cache.  This can lead to us failing to find refs from other roots that
>> pointed
>> at blocks in the now deleted root.  To handle this we need to not
>> remove the fs
>> roots from the cache until after we process the qgroup operations.  Do
>> this by
>> adding dropped roots to a list on the transaction, and letting the
>> transaction
>> remove the roots at the same time it drops the commit roots.  This
>> will keep all
>> of the backref searching code in sync properly, and fixes a problem
>> Mark was
>> seeing with snapshot delete and qgroups.  Thanks,Btrfs: keep dropped
>> roots in
>> cache until transaciton commit
>>
>> When dropping a snapshot we need to account for the qgroup changes.
>> If we drop
>> the snapshot in all one go then the backref code will fail to find
>> blocks from
>> the snapshot we dropped since it won't be able to find the root in the
>> fs root
>> cache.  This can lead to us failing to find refs from other roots that
>> pointed
>> at blocks in the now deleted root.  To handle this we need to not
>> remove the fs
>> roots from the cache until after we process the qgroup operations.  Do
>> this by
>> adding dropped roots to a list on the transaction, and letting the
>> transaction
>> remove the roots at the same time it drops the commit roots.  This
>> will keep all
>> of the backref searching code in sync properly, and fixes a problem
>> Mark was
>> seeing with snapshot delete and qgroups.  Thanks,
>
> Mark will definitely be happy with this patch, as quite a good basis for
> snapshot deletion.
>
> BTW, the commit message seems to be repeating itself.
>

Argh I usually notice when that happens, there's some weird vim key 
combo that I accidently hit pretty regularly that duplicates everything 
I just typed.  Thanks,

Josef

