Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:49566 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab3C3LrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Mar 2013 07:47:17 -0400
Received: by mail-pb0-f50.google.com with SMTP id jt11so560982pbb.37
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Mar 2013 04:47:16 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: cleanup to remove reduplicate code in iterate_extent_inode()
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <5156B985.8060506@gmx.net>
Date: Sat, 30 Mar 2013 19:47:09 +0800
Cc: linux-btrfs@vger.kernel.org, list.btrfs@jan-o-sch.net,
        wangsl-fnst@cn.fujitsu.com
Message-Id: <4F1E76BA-E722-42CA-9BC1-F211753A80D2@gmail.com>
References: <1364564554-1848-1-git-send-email-wangshilong1991@gmail.com> <5156B985.8060506@gmx.net>
To: Arne Jansen <sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello,

> On 03/29/13 14:42, Wang Shilong wrote:
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> 
>> Just remove the unnecessary check and assignment.
>> 
>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> ---
>> fs/btrfs/backref.c | 3 +--
>> 1 file changed, 1 insertion(+), 2 deletions(-)
>> 
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index 3ca413bb..e102b48 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -1499,7 +1499,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
>> 		if (ret)
>> 			break;
>> 		ULIST_ITER_INIT(&root_uiter);
>> -		while (!ret && (root_node = ulist_next(roots, &root_uiter))) {
>> +		while ((root_node = ulist_next(roots, &root_uiter))) {
> 
> It doesn't look unnecessary at all to me. ret is set in the loop and
> only checked in the while condition.

Yeah, you are right..
> 
>> 			pr_debug("root %llu references leaf %llu, data list "
>> 				 "%#llx\n", root_node->val, ref_node->val,
>> 				 (long long)ref_node->aux);
>> @@ -1510,7 +1510,6 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
>> 						iterate, ctx);
>> 		}
>> 		ulist_free(roots);
>> -		roots = NULL;
> 
> roots gets freed again later on. If you don't set it to NULL, it will
> result in a double free.

If we are in the loop, 'roots' will be reallocated again, if relocation in the find_all_roots()
fails,  'roots' has been dealt in the find_all_roots(), and we have breaked out the loop.

I don't know where a double may happen? Am i missing something?

Thanks,
Wang

> 
> -Arne
> 
>> 	}
>> 
>> 	free_leaf_list(refs);
>> 
> 

