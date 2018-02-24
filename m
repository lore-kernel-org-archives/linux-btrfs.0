Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38122 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751425AbeBXAwC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 19:52:02 -0500
Subject: Re: [PATCH] btrfs: Add nossd_spread mount option
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        <linux-btrfs@vger.kernel.org>
CC: <kernel-team@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Josef Bacik <jbacik@fb.com>
References: <20180221233140.23196-1-hmclauchlan@fb.com>
 <270bf5b5-5522-3cb9-7b7c-a6cae6303e2e@mendix.com>
From: Howard McLauchlan <hmclauchlan@fb.com>
Message-ID: <2740afd2-5385-d86b-b968-d934946aba75@fb.com>
Date: Fri, 23 Feb 2018 16:51:52 -0800
MIME-Version: 1.0
In-Reply-To: <270bf5b5-5522-3cb9-7b7c-a6cae6303e2e@mendix.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/21/2018 05:20 PM, Hans van Kranenburg wrote:
> On 02/22/2018 12:31 AM, Howard McLauchlan wrote:
>> Btrfs has two mount options for SSD optimizations: ssd and ssd_spread.
>> Presently there is an option to disable all SSD optimizations, but there
>> isn't an option to disable just ssd_spread.
>>
>> This patch adds a mount option nossd_spread that disables ssd_spread
>> only.
>>
>> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
>> ---
>>  fs/btrfs/super.c | 13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 6e71a2a78363..4c0fcf5b3e7e 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -310,10 +310,10 @@ static void btrfs_put_super(struct super_block *sb)
>>  enum {
>>  	Opt_degraded, Opt_subvol, Opt_subvolid, Opt_device, Opt_nodatasum,
>>  	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
>> -	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
>> -	Opt_compress_type, Opt_compress_force, Opt_compress_force_type,
>> -	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
>> -	Opt_space_cache, Opt_space_cache_version, Opt_clear_cache,
>> +	Opt_nossd, Opt_ssd_spread, Opt_nossd_spread, Opt_thread_pool, Opt_noacl,
>> +	Opt_compress, Opt_compress_type, Opt_compress_force,
>> +	Opt_compress_force_type, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
>> +	Opt_discard, Opt_space_cache, Opt_space_cache_version, Opt_clear_cache,
>>  	Opt_user_subvol_rm_allowed, Opt_enospc_debug, Opt_subvolrootid,
>>  	Opt_defrag, Opt_inode_cache, Opt_no_space_cache, Opt_recovery,
>>  	Opt_skip_balance, Opt_check_integrity,
>> @@ -353,6 +353,7 @@ static const match_table_t tokens = {
>>  	{Opt_ssd, "ssd"},
>>  	{Opt_ssd_spread, "ssd_spread"},
>>  	{Opt_nossd, "nossd"},
>> +	{Opt_nossd_spread, "nossd_spread"},
>>  	{Opt_acl, "acl"},
>>  	{Opt_noacl, "noacl"},
>>  	{Opt_notreelog, "notreelog"},
> 
> .oO(Why doesn't the enum just have one option per line, so the changelog
> is less invasive?)
> 
>> @@ -582,6 +583,10 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>>  			btrfs_clear_and_info(info, SSD_SPREAD,
>>  					     "not using spread ssd allocation scheme");
>>  			break;
>> +		case Opt_nossd_spread:
>> +			btrfs_clear_and_info(info, SSD_SPREAD,
>> +					     "not using spread ssd allocation scheme");
>> +			break;
>>  		case Opt_barrier:
>>  			btrfs_clear_and_info(info, NOBARRIER,
>>  					     "turning on barriers");
>>
> 
> Related:
> * https://urldefense.proofpoint.com/v2/url?u=https-3A__www.spinics.net_lists_linux-2Dbtrfs_msg64247.html&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=UA4c4GV4shA70-jKB4kwcF99U6K6bzKVYdicFvu-DtQ&m=oYU5SWdFSoawOXAWRYLqZvvDYpROHFkzMQLlAZEehaU&s=0LRSD37KWUOyo_i9ypRAaZrv7_8R_kJ0yHv9vNoqDB4&e=
> * https://urldefense.proofpoint.com/v2/url?u=https-3A__www.spinics.net_lists_linux-2Dbtrfs_msg64277.html&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=UA4c4GV4shA70-jKB4kwcF99U6K6bzKVYdicFvu-DtQ&m=oYU5SWdFSoawOXAWRYLqZvvDYpROHFkzMQLlAZEehaU&s=WB_Fyhm3SDx3XdaE71X6aYRxonuk0Q8Jr4f1ai6K2dI&e=
> * https://urldefense.proofpoint.com/v2/url?u=https-3A__www.spinics.net_lists_linux-2Dbtrfs_msg64499.html&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=UA4c4GV4shA70-jKB4kwcF99U6K6bzKVYdicFvu-DtQ&m=oYU5SWdFSoawOXAWRYLqZvvDYpROHFkzMQLlAZEehaU&s=FcKlny0UlOCTWEfvCgEz_QtGnYI20EiDF3weQVKPyDs&e=
> 
> Apparently that discussion never resulted in actual changes, so thanks
> for continuing it now.
> 
> The mount options are a bit weird, because ssd_spread also includes ssd,
> but doesn't show it.
> 
> I personally don't like all of them at all, and I should really finish
> and send my proposal to get them replaced by options that can choose
> extent allocator for data and metadata individually (instead of some
> setting that changes them both at the same time) because there are
> proper real life situations that e.g. benefit from nossd style 'tetris'
> data allocator with ssd_spread style 'contiguous' metadata extent allocator.
> 
I agree; this change is just something very specific that came up in prod for us, so I decided to push a patch for it. 
