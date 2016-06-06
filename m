Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19966 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751806AbcFFCQo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 22:16:44 -0400
Subject: Re: [PATCH v2] btrfs: fix check_shared for fiemap ioctl
To: Josef Bacik <jbacik@fb.com>
References: <1464760085-12078-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <3b5ed9c3-7ffd-4bcf-5992-e11b7f6463a5@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Message-ID: <99fff2f0-3015-b25a-ac1a-a7c22b2918ae@cn.fujitsu.com>
Date: Mon, 6 Jun 2016 10:16:33 +0800
MIME-Version: 1.0
In-Reply-To: <3b5ed9c3-7ffd-4bcf-5992-e11b7f6463a5@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At 06/03/2016 10:02 PM, Josef Bacik wrote:
> On 06/01/2016 01:48 AM, Lu Fengqi wrote:
>> Only in the case of different root_id or different object_id,
>> check_shared
>> identified extent as the shared. However, If a extent was referred by
>> different offset of same file, it should also be identified as shared.
>> In addition, check_shared's loop scale is at least  n^3, so if a extent
>> has too many references,  even causes soft hang up.
>>
>> First, add all delayed_ref to the ref_tree and calculate the unqiue_refs,
>> if the unique_refs is greater than one, return BACKREF_FOUND_SHARED.
>> Then individually add the  on-disk reference(inline/keyed) to the
>> ref_tree
>> and calculate the unique_refs of the ref_tree to check if the unique_refs
>> is greater than one.Because once there are two references to return
>> SHARED, so the time complexity is close to the constant.
>>
>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>
> This is a lot of work for just wanting to know if something is shared.
> Instead lets adjust this slightly.  Instead of passing down a
> root_objectid/inum and noticing this and returned shared, add a new way
> to iterate refs.  Currently we go gather all the refs and then do the
> iterate dance, which is what takes so long.  So instead add another
> helper that calls the provided function every time it has a match, and
> then we can pass in whatever context we want, and we return when
> something matches.  This way we don't have all this extra accounting,
> and we're no longer passing root_objectid/inum around and testing for
> some magic scenario.  Thanks,
>
> Josef
>
>
>

With this patch, we can quickly find extent that has more than one 
reference(delayed, inline and keyed) and return SHARED immediately. 
However, for indirect refs, we have to continue to resolve indirect refs 
to their parent bytenr, and check if this parent bytenr is shared. So, 
the original function is necessary. The original refs list reduces the 
efficiency of search, so maybe we can use rb_tree to replace it for 
optimize the original function in the furture. And, we just want to 
solve the problem of check_shared now.

-- 
Thanks,
Lu


