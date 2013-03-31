Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:62403 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3CaKlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Mar 2013 06:41:18 -0400
Received: by mail-da0-f49.google.com with SMTP id t11so714121daj.22
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Mar 2013 03:41:17 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: cleanup to remove reduplicate code in iterate_extent_inode()
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <5156EC34.2090805@gmx.net>
Date: Sun, 31 Mar 2013 18:40:43 +0800
Cc: Arne Jansen <sensille@gmx.net>,
        "list.btrfs@jan-o-sch.net Schmidt" <list.btrfs@jan-o-sch.net>,
        "wangsl-fnst@cn.fujitsu.com Shilong" <wangsl-fnst@cn.fujitsu.com>
Message-Id: <F913DB64-B76C-4C28-93DB-8EDB3DDE2FDF@gmail.com>
References: <1364564554-1848-1-git-send-email-wangshilong1991@gmail.com> <5156B985.8060506@gmx.net> <C94A0D89-18E9-447B-A08E-2D0A4E3CAD18@gmail.com> <5156EC34.2090805@gmx.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just ignore this patch, i have merge the correct modification
of this patch to the [patch V2] fix double free in the iterate_extent_inodes().
  
Thanks,
Wang
> On 03/30/13 12:55, Wang Shilong wrote:
>> <snip>
>> 
>>> On 03/29/13 14:42, Wang Shilong wrote:
>>>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>>> 
>>>> Just remove the unnecessary check and assignment.
>>>> 
>>>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>>>> ---
>>>> fs/btrfs/backref.c | 3 +--
>>>> 1 file changed, 1 insertion(+), 2 deletions(-)
>>>> 
>>>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>>>> index 3ca413bb..e102b48 100644
>>>> --- a/fs/btrfs/backref.c
>>>> +++ b/fs/btrfs/backref.c
>>>> @@ -1499,7 +1499,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
>>>> 		if (ret)
>>>> 			break;
>>>> 		ULIST_ITER_INIT(&root_uiter);
>>>> -		while (!ret && (root_node = ulist_next(roots, &root_uiter))) {
>>>> +		while ((root_node = ulist_next(roots, &root_uiter))) {
>>> 
>>> It doesn't look unnecessary at all to me. ret is set in the loop and
>>> only checked in the while condition.
>>> 
>>>> 			pr_debug("root %llu references leaf %llu, data list "
>>>> 				 "%#llx\n", root_node->val, ref_node->val,
>>>> 				 (long long)ref_node->aux);
>>>> @@ -1510,7 +1510,6 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
>>>> 						iterate, ctx);
>>>> 		}
>>>> 		ulist_free(roots);
>>>> -		roots = NULL;
>>> 
>>> roots gets freed again later on. If you don't set it to NULL, it will
>>> result in a double free.
>> 
>> Maybe you mean this?
>> 
>> http://marc.info/?l=linux-btrfs&m=136456233929528&w=2
>> ulist_free() here is unnecessary and may cause a double free¡­
>> So we don't need to set it to NULL again..
> 
> Yeah, I haven't seen your other patch.
> 
>> 
>> 
>> 
>>> 
>>> -Arne
>>> 
>>>> 	}
>>>> 
>>>> 	free_leaf_list(refs);
>>>> 
>>> 
>> 
> 

