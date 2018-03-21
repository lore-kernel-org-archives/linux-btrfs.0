Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41645 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751411AbeCUHjA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 03:39:00 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 84802ABD0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 07:38:59 +0000 (UTC)
Subject: Re: [PATCH] btrfs: Remove obsolete function declaration
To: Qu Wenruo <wqu@suse.com>, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <1521615821-17703-1-git-send-email-nborisov@suse.com>
 <ad566699-9a26-e439-0e5d-4e9b1bdf06a5@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7c18da97-bd2f-792a-dc1f-a151a9de008e@suse.com>
Date: Wed, 21 Mar 2018 09:38:58 +0200
MIME-Version: 1.0
In-Reply-To: <ad566699-9a26-e439-0e5d-4e9b1bdf06a5@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.03.2018 09:16, Qu Wenruo wrote:
> 
> 
> On 2018年03月21日 15:03, Nikolay Borisov wrote:
>> This function was removed in 24bc2843edd5 ("btrfs:
>> Refactor __get_raid_index() to btrfs_bg_flags_to_raid_index()") what
>> remains is a defunct declaration. Remove it.
> 
> Nice find, thanks for get this.
> 
> 
> But strangely, I just fetched David's repo, but didn't find that commit
> hash anywhere.
> 
> I'm fetching from git.kernel.org repo, or is that repo only updated when
> pushing to Linus?

It's update only when david pushes and preps the pull reqs. I base all
my development on his misc-next branch on github.
> 
> Thanks,
> Qu
> 
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>> David, 
>>
>> This is a fixlet to the aforementioned patch which is only in your misc-next, 
>> I'd suggest just squash this fixlet into the original one. 
>>
>>  fs/btrfs/ctree.h | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index fbe51edb9cac..03be51d77357 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -2801,7 +2801,6 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range);
>>  int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
>>  int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
>>  					 struct btrfs_fs_info *fs_info);
>> -int __get_raid_index(u64 flags);
>>  int btrfs_start_write_no_snapshotting(struct btrfs_root *root);
>>  void btrfs_end_write_no_snapshotting(struct btrfs_root *root);
>>  void btrfs_wait_for_snapshot_creation(struct btrfs_root *root);
>>
> 
