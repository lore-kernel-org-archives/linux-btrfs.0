Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:24918 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752960AbeFGDrG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 23:47:06 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 0CAF74B41E79
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jun 2018 11:46:57 +0800 (CST)
Subject: Re: [PATCH v2 1/3] btrfs-progs: check: check symlinks with
 append/immutable flags
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
References: <20180515013324.18838-1-suy.fnst@cn.fujitsu.com>
 <20180515013324.18838-2-suy.fnst@cn.fujitsu.com>
 <ee67d0b0-567f-efa3-5d7f-667bbb098e8c@jp.fujitsu.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <5ed43d8e-cd04-9433-d245-51438f613ee5@cn.fujitsu.com>
Date: Thu, 7 Jun 2018 11:53:09 +0800
MIME-Version: 1.0
In-Reply-To: <ee67d0b0-567f-efa3-5d7f-667bbb098e8c@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/07/2018 10:45 AM, Misono Tomohiro wrote:
> 
> 
> On 2018/05/15 10:33, Su Yue wrote:
>> Define new macro I_ERR_ODD_INODE_FLAGS to represents odd inode flags.
>>
>> Symlinks should never have append/immutable flags.
>> While processing inodes, if found a symlink with append/immutable
>> flags, mark the inode record with I_ERR_ODD_INODE_FLAGS.
>>
>> This is for original mode.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>  check/main.c          | 7 +++++++
>>  check/mode-original.h | 1 +
>>  2 files changed, 8 insertions(+)
>>
>> diff --git a/check/main.c b/check/main.c
>> index 68da994f7ae0..c764fc011ded 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -576,6 +576,8 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
>>  		fprintf(stderr, ", link count wrong");
>>  	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
>>  		fprintf(stderr, ", orphan file extent");
>> +	if (errors & I_ERR_ODD_INODE_FLAGS)
>> +		fprintf(stderr, ", odd inode flags");
>>  	fprintf(stderr, "\n");
>>  	/* Print the orphan extents if needed */
>>  	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
>> @@ -805,6 +807,7 @@ static int process_inode_item(struct extent_buffer *eb,
>>  {
>>  	struct inode_record *rec;
>>  	struct btrfs_inode_item *item;
>> +	u64 flags;
>>  
>>  	rec = active_node->current;
>>  	BUG_ON(rec->ino != key->objectid || rec->refs > 1);
>> @@ -822,6 +825,10 @@ static int process_inode_item(struct extent_buffer *eb,
>>  	rec->found_inode_item = 1;
>>  	if (rec->nlink == 0)
>>  		rec->errors |= I_ERR_NO_ORPHAN_ITEM;
>> +	flags = btrfs_inode_flags(eb, item);
>> +	if (rec->imode & BTRFS_FT_SYMLINK &&
> 
> Hello,
> 
> I observed that this commit causes test-convert/009 in current kdave/devel branch.
> Since rec->imode uses S_IFLNK (0xa000) for symbolic link and BTRFS_FT_SYMLINK is 7,
> above statement does not work well. Shouldn't we use S_ISLNK(rec->imode) instead?
> 

Oh.. Yep, my bad.
Since the test case is created by hand, the whole patchset should be
modified in next version.
Thanks a lot.

Su

> Thanks,
> Tomohiro Misono
> 
>> +	    flags & (BTRFS_INODE_IMMUTABLE | BTRFS_INODE_APPEND))
>> +		rec->errors |= I_ERR_ODD_INODE_FLAGS;
>>  	maybe_free_inode_rec(&active_node->inode_cache, rec);
>>  	return 0;
>>  }
>> diff --git a/check/mode-original.h b/check/mode-original.h
>> index 368de692fdd1..13cfa5b9e1b3 100644
>> --- a/check/mode-original.h
>> +++ b/check/mode-original.h
>> @@ -186,6 +186,7 @@ struct file_extent_hole {
>>  #define I_ERR_LINK_COUNT_WRONG		(1 << 13)
>>  #define I_ERR_FILE_EXTENT_ORPHAN	(1 << 14)
>>  #define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
>> +#define I_ERR_ODD_INODE_FLAGS		(1 << 16)
>>  
>>  struct inode_record {
>>  	struct list_head backrefs;
>>


