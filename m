Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60896 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933082AbcFMBTr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 21:19:47 -0400
Subject: Re: [PATCH v3] btrfs: fix check_shared for fiemap ioctl
To: <dsterba@suse.cz>, Mark Fasheh <mfasheh@suse.de>
References: <1465362783-27078-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160608155300.GX7633@wotan.suse.de> <20160609091528.GG3905@twin.jikos.cz>
CC: <linux-btrfs@vger.kernel.org>
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Message-ID: <4dfc9696-e8e7-636e-42d7-525f443c4eb4@cn.fujitsu.com>
Date: Mon, 13 Jun 2016 09:19:33 +0800
MIME-Version: 1.0
In-Reply-To: <20160609091528.GG3905@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At 06/09/2016 05:15 PM, David Sterba wrote:
> On Wed, Jun 08, 2016 at 08:53:00AM -0700, Mark Fasheh wrote:
>> On Wed, Jun 08, 2016 at 01:13:03PM +0800, Lu Fengqi wrote:
>>> Only in the case of different root_id or different object_id, check_shared
>>> identified extent as the shared. However, If a extent was referred by
>>> different offset of same file, it should also be identified as shared.
>>> In addition, check_shared's loop scale is at least  n^3, so if a extent
>>> has too many references,  even causes soft hang up.
>>>
>>> First, add all delayed_ref to the ref_tree and calculate the unqiue_refs,
>>> if the unique_refs is greater than one, return BACKREF_FOUND_SHARED.
>>> Then individually add the  on-disk reference(inline/keyed) to the ref_tree
>>> and calculate the unique_refs of the ref_tree to check if the unique_refs
>>> is greater than one.Because once there are two references to return
>>> SHARED, so the time complexity is close to the constant.
>>>
>>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>> ---
>>> The caller is fiemap that called from an ioctl. Because it isn't on a
>>> writeout path, so we temporarily use GFP_KERNEL in ref_root_alloc() and
>>> ref_tree_add(). If we use ref_tree replace the existing backref structure
>>> later, we can consider whether to use GFP_NOFS again.
>>
>> NACK.
>>
>> You don't need to be on a writeout path to deadlock, you simply need to be
>> holding locks that the writeout path takes when you allocate. If the
>> allocator does writeout to free memory then you deadlock. Fiemap is locking
>> down extents which may also get locked down when you allocate within those
>> locks. See my e-mail here for details,
>>
>> http://www.spinics.net/lists/linux-btrfs/msg55789.html
>
> There seems to be a code path that leads to a deadlock scenario, it
> depends on the extent state of the file under fiemap. If there's a
> delalloc range in the middle of the file, fiemap locks the whole range,
> asks for memory that could trigger writeout, the delalloc range would
> need to be written and requests locking the dealloc range again. There's
> no direct locking but rather waiting for the extent LOCKED bit unset.
>
> So, use GFP_NOFS now, though I still hope we can find a way to avoid
> rb-tree and allocations alltogether.
>
>

OK, until we find a way to avoid rb-tree and allocations alltogether, I 
will use GFP_NOFS.
-- 
Thanks,
Lu


