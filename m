Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54803 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750885AbdIQM1j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 08:27:39 -0400
Subject: Re: [PATCH] btrfs-progs: Output time elapsed for each major tree it
 checked
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, marc@merlins.org
References: <20170911052623.31999-1-quwenruo.btrfs@gmx.com>
 <87mv5tztta.wl-satoru.takeuchi@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2563aaf7-a262-8095-c303-4496ccafd0f8@gmx.com>
Date: Sun, 17 Sep 2017 20:27:26 +0800
MIME-Version: 1.0
In-Reply-To: <87mv5tztta.wl-satoru.takeuchi@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月17日 15:08, Satoru Takeuchi wrote:
> At Mon, 11 Sep 2017 14:26:23 +0900,
> Qu Wenruo wrote:
>>
>> Marc reported that "btrfs check --repair" runs much faster than "btrfs
>> check", which is quite weird.
>>
>> This patch will add time elapsed for each major tree it checked, for
>> both original mode and lowmem mode, so we can have a clue what's going
>> wrong.
>>
>> Reported-by: Marc MERLIN <marc@merlins.org>
>> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
>> ---
>>   cmds-check.c | 21 +++++++++++++++++++--
>>   utils.h      | 24 ++++++++++++++++++++++++
>>   2 files changed, 43 insertions(+), 2 deletions(-)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index 006edbde..fee806cd 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -5318,13 +5318,16 @@ static int do_check_fs_roots(struct btrfs_fs_info *fs_info,
>>   			  struct cache_tree *root_cache)
>>   {
>>   	int ret;
>> +	struct timer timer;
>>   
>>   	if (!ctx.progress_enabled)
>>   		fprintf(stderr, "checking fs roots\n");
>> +	start_timer(&timer);
>>   	if (check_mode == CHECK_MODE_LOWMEM)
>>   		ret = check_fs_roots_v2(fs_info);
>>   	else
>>   		ret = check_fs_roots(fs_info, root_cache);
>> +	printf("done in %d seconds\n", stop_timer(&timer));
> 
> How about adding the prefixes to show which part of check/repair is done
> before showing the elaplsed time, like "checking fs roots done in XX seconds"
> and "checking extents done in XX seconds"?

Nice advice.

I'll update the patch to add a prefix for this.

Thanks,
Qu

> 
> Current message, "done in XX seconds" for all parts, is hard to understand
> which part takes such the time, especially when something wrong happens
> in some parts. For example, please see the following example of repairing
> the image based on tests/fsck-tests/002-bad-transid/default_case.img
> 
> ===
> ...
> opening btrfs filesystem
> parent transid verify failed on 29360128 wanted 9 found 755944791
> parent transid verify failed on 29360128 wanted 9 found 755944791
> parent transid verify failed on 29360128 wanted 9 found 755944791
> parent transid verify failed on 29360128 wanted 9 found 755944791
> Ignoring transid failure
> done in 0 seconds
> ...
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> done in 0 seconds
> ...
> ===
> 
> Thanks,
> Satoru
> 
>>   
>>   	return ret;
>>   }
>> @@ -11584,14 +11587,16 @@ out:
>>   static int do_check_chunks_and_extents(struct btrfs_fs_info *fs_info)
>>   {
>>   	int ret;
>> +	struct timer timer;
>>   
>>   	if (!ctx.progress_enabled)
>>   		fprintf(stderr, "checking extents\n");
>> +	start_timer(&timer);
>>   	if (check_mode == CHECK_MODE_LOWMEM)
>>   		ret = check_chunks_and_extents_v2(fs_info);
>>   	else
>>   		ret = check_chunks_and_extents(fs_info);
>> -
>> +	printf("done in %d seconds\n", stop_timer(&timer));
>>   	return ret;
>>   }
>>   
>> @@ -12772,6 +12777,7 @@ int cmd_check(int argc, char **argv)
>>   	int qgroups_repaired = 0;
>>   	unsigned ctree_flags = OPEN_CTREE_EXCLUSIVE;
>>   	int force = 0;
>> +	struct timer timer;
>>   
>>   	while(1) {
>>   		int c;
>> @@ -12953,8 +12959,11 @@ int cmd_check(int argc, char **argv)
>>   	if (repair)
>>   		ctree_flags |= OPEN_CTREE_PARTIAL;
>>   
>> +	printf("opening btrfs filesystem\n");
>> +	start_timer(&timer);
>>   	info = open_ctree_fs_info(argv[optind], bytenr, tree_root_bytenr,
>>   				  chunk_root_bytenr, ctree_flags);
>> +	printf("done in %d seconds\n", stop_timer(&timer));
>>   	if (!info) {
>>   		error("cannot open file system");
>>   		ret = -EIO;
>> @@ -13115,8 +13124,10 @@ int cmd_check(int argc, char **argv)
>>   		else
>>   			fprintf(stderr, "checking free space cache\n");
>>   	}
>> +	start_timer(&timer);
>>   	ret = check_space_cache(root);
>>   	err |= !!ret;
>> +	printf("done in %d seconds\n", stop_timer(&timer));
>>   	if (ret) {
>>   		if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
>>   			error("errors found in free space tree");
>> @@ -13140,18 +13151,22 @@ int cmd_check(int argc, char **argv)
>>   	}
>>   
>>   	fprintf(stderr, "checking csums\n");
>> +	start_timer(&timer);
>>   	ret = check_csums(root);
>>   	err |= !!ret;
>> +	printf("done in %d seconds\n", stop_timer(&timer));
>>   	if (ret) {
>>   		error("errors found in csum tree");
>>   		goto out;
>>   	}
>>   
>> -	fprintf(stderr, "checking root refs\n");
>>   	/* For low memory mode, check_fs_roots_v2 handles root refs */
>>   	if (check_mode != CHECK_MODE_LOWMEM) {
>> +		fprintf(stderr, "checking root refs\n");
>> +		start_timer(&timer);
>>   		ret = check_root_refs(root, &root_cache);
>>   		err |= !!ret;
>> +		printf("done in %d seconds\n", stop_timer(&timer));
>>   		if (ret) {
>>   			error("errors found in root refs");
>>   			goto out;
>> @@ -13186,8 +13201,10 @@ int cmd_check(int argc, char **argv)
>>   
>>   	if (info->quota_enabled) {
>>   		fprintf(stderr, "checking quota groups\n");
>> +		start_timer(&timer);
>>   		ret = qgroup_verify_all(info);
>>   		err |= !!ret;
>> +		printf("done in %d seconds\n", stop_timer(&timer));
>>   		if (ret) {
>>   			error("failed to check quota groups");
>>   			goto out;
>> diff --git a/utils.h b/utils.h
>> index d28a05a6..159487db 100644
>> --- a/utils.h
>> +++ b/utils.h
>> @@ -172,4 +172,28 @@ u64 rand_u64(void);
>>   unsigned int rand_range(unsigned int upper);
>>   void init_rand_seed(u64 seed);
>>   
>> +/* Utils to report time duration */
>> +struct timer {
>> +	time_t start;
>> +};
>> +
>> +static inline void start_timer(struct timer *t)
>> +{
>> +	time(&t->start);
>> +}
>> +
>> +/*
>> + * Stop timer and return the time elapsed in int
>> + *
>> + * int should be large enough to "btrfs check" and avoid
>> + * type converting.
>> + */
>> +static inline int stop_timer(struct timer *t)
>> +{
>> +	time_t end;
>> +
>> +	time(&end);
>> +
>> +	return (int)(difftime(end, t->start));
>> +}
>>   #endif
>> -- 
>> 2.14.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
