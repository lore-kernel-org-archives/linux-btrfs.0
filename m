Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:30252 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbeHCGWN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2018 02:22:13 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id AFB7BAC0115
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 13:27:44 +0900 (JST)
Subject: Re: [PATCH] btrfs: qgroup: Remove qgroup item along with subvolume
 deletion
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1533263845.git.misono.tomohiro@jp.fujitsu.com>
 <eeaa9ab1-f6a5-9043-9b5e-cc9acf82ca47@jp.fujitsu.com>
 <e2d0d7fc-8603-7c47-4168-266be4d72edc@gmx.com>
 <20180803042331.GC2049@fnst.localdomain>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <7dba0e2e-44d5-8a46-6aa7-2e900f98f240@jp.fujitsu.com>
Date: Fri, 3 Aug 2018 13:27:38 +0900
MIME-Version: 1.0
In-Reply-To: <20180803042331.GC2049@fnst.localdomain>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/08/03 13:23, Lu Fengqi wrote:
> On Fri, Aug 03, 2018 at 12:17:26PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018年08月03日 12:08, Misono Tomohiro wrote:
>>> When qgroup is on, subvolume deletion does not remove qgroup items
>>> of the subvolume (qgroup info, limits, relation) from quota tree and
>>> they need to get removed manually by "btrfs qgroup destroy".
>>>
>>> Since level 0 qgroup cannot be used/inherited by any other subvolume,
>>> let's remove them automatically when subvolume is deleted.
>>>
>>> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>>> ---
>>>
>>> I don't see any reason to keep these items after subvolume deletion,
>>> but is there something I'm missing?
>>>
>>>  fs/btrfs/inode.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> index 3f51ddc18f98..4ec60a1b53a3 100644
>>> --- a/fs/btrfs/inode.c
>>> +++ b/fs/btrfs/inode.c
>>> @@ -4372,6 +4372,10 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
>>>  		}
>>>  	}
>>>  
>>> +	ret = btrfs_remove_qgroup(trans, dest->root_key.objectid);
>>
>> According to the caller, it only unlinks the subvolume without really
>> delete the whole subvolume.
>>
>> I'm wondering if we should call btrfs_remove_qgroup() only after we have
>> deleted the whole subvolume, e.g inside btrfs_drop_snapshot().
> 
> I agree with Qu's point, because the ongoing online undelete subvolume will
> be able to recover the subvolume which is intact ondisk, including the qgroup.
> 

Thanks to both of you, I'll update the patch.
Misono

