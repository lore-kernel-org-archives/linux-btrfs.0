Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2918FC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 06:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D71C8223CB
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 06:46:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D71C8223CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbeKPQ5f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 11:57:35 -0500
Received: from mout.gmx.net ([212.227.15.18]:37773 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727353AbeKPQ5f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 11:57:35 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M936L-1gBgqe0YRR-00CTw3; Fri, 16
 Nov 2018 07:46:22 +0100
Subject: Re: [PATCH] btrfs-progs: Cleanup warning reported by
 -Wmissing-prototypes except free space tree
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181116061312.2848-1-wqu@suse.com>
 <0079c368-c495-49c6-0698-d1844ae747b3@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <726ed60f-54a6-dc1b-0ed7-c77c57759311@gmx.com>
Date:   Fri, 16 Nov 2018 14:46:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <0079c368-c495-49c6-0698-d1844ae747b3@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:UnuPWxduykSO51+msNj6CYsdq/II0zEJyYtsrGW4AvsyhMN2vma
 pFkhh1KP/tCdkKVs7stM7mKluNGu7oQofFq3OlqgPk2Q+hBZxT1H0Ok09z8yUMBTqWBUZOB
 E/xQUmO5KcWFjW0prkLfkxpT9XkjS02kH6a+M+XqDfklwmbJW0BYP2T3U8YhpA1ssUuRoYa
 R/bfqb9AqHwykNOSZGT7A==
X-UI-Out-Filterresults: notjunk:1;V01:K0:gu/D0CViyDs=:TOKuT+WIDryoG1kd5eLg1L
 FJlIadUqf8ZVmZrvRIbgXtgmUc5MJRqwdOsXzaNpBWlgRB2PKqCG/PfHjc/owON36zin42EYp
 RQnZ3oPRfi0w0YUlYEGeO8AZVoV5KGkpUbUfSSMg9OvlxEJDYJewtGfiOjmQOrRMQ4q1Bsz5n
 b1/zCjkkqH37M2UgovMkAnkvnPF/zcP/3DV2TroOUH4nETodKeMdkrqeq8+E3kfvt0YJFYi6c
 rAZl+Y4WIX9TtuqFjLYqAFfSHsnN68eYthZGDTtohi6xNeLh7aaaQO+tUmWXqq0OCg6nesNBQ
 //ZzNRiAQAUnxvq1/ca8gKPLp0vqbpHfCKigbEhS+sudgAebi5U8Jxz8XFPyL5MpZuMfQ2Kld
 h2U7a5XfJIF0rMy69LbJ1mKmSIn/kN757XfaOufpdN88P8lbTLNghwn3sXPtfYHO+3/+dWvwC
 v9FKu6nTSV/PUurzDCfHfqlzpGsbYEvrXhafkdOBc0nsNwbW8hdKj4kWHw9IMn48HgCj7VmCz
 JKUs/lashXqwZdvHQfbIO+itfHXVex1UkReyoT1iTdvaRr4FmyKfjzGghyG4EIWpX2MPc1IBr
 jd4Tzy1NlbXFq18JErabJMKsA2Yf3+5B2qSCI3R125Xn5m0w4qaf0TxacziWfnhwBISUQ3QKT
 nPbjAjZ4+zHmx1cX7FnA+cmGwz9g3ivMZKhCMwNS3lQHFWfB4KnWZv8VA+FdScd5472mtfc55
 NaIcQIyQIITtwsfxWADFHNARRnD7W2OliUkcVvYy88558TwMscnVeok8fW0L1UX+JpOCfYPmr
 OnuMxJfKdHwxtZAUnsmz6vDe8IEaF1jzxgfHueEuDJHBN44E2i9Hi/IbiyyCcI2hPJ01lWao1
 5OM3tJGQUc/9xgSXdiJKydg4/xtqZZiQPVGPfw6HEdpgMz98lrZmuGbfWpjfJwVBDLoTDm3rS
 r2/1WJEoUKA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/16 下午2:39, Nikolay Borisov wrote:
> 
> 
> On 16.11.18 г. 8:13 ч., Qu Wenruo wrote:
>> The following missing prototypes will be fixed:
>> 1) btrfs.c::handle_special_globals()
>> 2) check/mode-lowmem.c::repair_ternary_lowmem()
>> 3) extent-tree.c::btrfs_search_overlap_extent()
>>    Above 3 can be fixed by making them static
>>
>> 4) utils.c::btrfs_check_nodesize()
>>    Fixed by moving it to fsfeatures.c
>>
>> 5) chunk-recover.c::btrfs_recover_chunk_tree()
>> 6) super-recover.c::btrfs_recover_superblocks()
>>    Fixed by moving the declaration from cmds-rescue.c to rescue.h
>>
>> 7) utils-lib.c::arg_strtou64()
>> 7) utils-lib.c::lookup_path_rootid()
>>    Fixed by include "utils.h"
>>
>> Free space tree is left untouched, as some unused functions are there
>> for later write support.
> 
> Hm, I think freespace tree is more or less done,

That's great, I could cut some code out.

> what else is there?
> There is one function in there: set_free_space_tree_thresholds which i
> think could be removed, can't remember why I backported it. And there
> were some other that could just be made static.

That's the full output for free-space-tree.

free-space-tree.c:27:6: warning: no previous prototype for
'set_free_space_tree_thresholds' [-Wmissing-prototypes]
 void set_free_space_tree_thresholds(struct btrfs_block_group_cache *cache,
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
free-space-tree.c:205:5: warning: no previous prototype for
'convert_free_space_to_bitmaps' [-Wmissing-prototypes]
 int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
free-space-tree.c:344:5: warning: no previous prototype for
'convert_free_space_to_extents' [-Wmissing-prototypes]
 int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
free-space-tree.c:783:5: warning: no previous prototype for
'__remove_from_free_space_tree' [-Wmissing-prototypes]
 int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
free-space-tree.c:963:5: warning: no previous prototype for
'__add_to_free_space_tree' [-Wmissing-prototypes]
 int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
     ^~~~~~~~~~~~~~~~~~~~~~~~
free-space-tree.c:1423:20: warning: no previous prototype for
'btrfs_create_tree' [-Wmissing-prototypes]
 struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
                    ^~~~~~~~~~~~~~~~~

I'll update these in v2.

Thanks,
Qu


> 
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  btrfs.c             |  2 +-
>>  check/mode-lowmem.c |  6 +++---
>>  chunk-recover.c     |  1 +
>>  cmds-rescue.c       |  4 +---
>>  extent-tree.c       |  2 +-
>>  fsfeatures.c        | 22 ++++++++++++++++++++++
>>  rescue.h            | 14 ++++++++++++++
>>  super-recover.c     |  1 +
>>  utils-lib.c         |  1 +
>>  utils.c             | 23 -----------------------
>>  10 files changed, 45 insertions(+), 31 deletions(-)
>>  create mode 100644 rescue.h
>>
>> diff --git a/btrfs.c b/btrfs.c
>> index 2d39f2ced3e8..78c468d2e050 100644
>> --- a/btrfs.c
>> +++ b/btrfs.c
>> @@ -210,7 +210,7 @@ static int handle_global_options(int argc, char **argv)
>>  	return shift;
>>  }
>>  
>> -void handle_special_globals(int shift, int argc, char **argv)
>> +static void handle_special_globals(int shift, int argc, char **argv)
>>  {
>>  	int has_help = 0;
>>  	int has_full = 0;
>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>> index 14bbc9ee6cb6..f56b5e8d45dc 100644
>> --- a/check/mode-lowmem.c
>> +++ b/check/mode-lowmem.c
>> @@ -953,9 +953,9 @@ out:
>>   * returns 0 means success.
>>   * returns not 0 means on error;
>>   */
>> -int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
>> -			  u64 index, char *name, int name_len, u8 filetype,
>> -			  int err)
>> +static int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
>> +				 u64 index, char *name, int name_len,
>> +				 u8 filetype, int err)
>>  {
>>  	struct btrfs_trans_handle *trans;
>>  	int stage = 0;
>> diff --git a/chunk-recover.c b/chunk-recover.c
>> index 1d30db51d8ed..1e554b8e8750 100644
>> --- a/chunk-recover.c
>> +++ b/chunk-recover.c
>> @@ -40,6 +40,7 @@
>>  #include "utils.h"
>>  #include "btrfsck.h"
>>  #include "commands.h"
>> +#include "rescue.h"
>>  
>>  struct recover_control {
>>  	int verbose;
>> diff --git a/cmds-rescue.c b/cmds-rescue.c
>> index 2bc50c0841ed..36e9e1277e40 100644
>> --- a/cmds-rescue.c
>> +++ b/cmds-rescue.c
>> @@ -26,15 +26,13 @@
>>  #include "commands.h"
>>  #include "utils.h"
>>  #include "help.h"
>> +#include "rescue.h"
>>  
>>  static const char * const rescue_cmd_group_usage[] = {
>>  	"btrfs rescue <command> [options] <path>",
>>  	NULL
>>  };
>>  
>> -int btrfs_recover_chunk_tree(const char *path, int verbose, int yes);
>> -int btrfs_recover_superblocks(const char *path, int verbose, int yes);
>> -
>>  static const char * const cmd_rescue_chunk_recover_usage[] = {
>>  	"btrfs rescue chunk-recover [options] <device>",
>>  	"Recover the chunk tree by scanning the devices one by one.",
>> diff --git a/extent-tree.c b/extent-tree.c
>> index cd98633992ac..8c9cdeff3b02 100644
>> --- a/extent-tree.c
>> +++ b/extent-tree.c
>> @@ -3749,7 +3749,7 @@ static void __get_extent_size(struct btrfs_root *root, struct btrfs_path *path,
>>   * Return >0 for not found.
>>   * Return <0 for err
>>   */
>> -int btrfs_search_overlap_extent(struct btrfs_root *root,
>> +static int btrfs_search_overlap_extent(struct btrfs_root *root,
>>  				struct btrfs_path *path, u64 bytenr, u64 len)
>>  {
>>  	struct btrfs_key key;
>> diff --git a/fsfeatures.c b/fsfeatures.c
>> index 7d85d60f1277..201d0f576688 100644
>> --- a/fsfeatures.c
>> +++ b/fsfeatures.c
>> @@ -225,3 +225,25 @@ u32 get_running_kernel_version(void)
>>  	return version;
>>  }
>>  
>> +int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features)
>> +{
>> +	if (nodesize < sectorsize) {
>> +		error("illegal nodesize %u (smaller than %u)",
>> +				nodesize, sectorsize);
>> +		return -1;
>> +	} else if (nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
>> +		error("illegal nodesize %u (larger than %u)",
>> +			nodesize, BTRFS_MAX_METADATA_BLOCKSIZE);
>> +		return -1;
>> +	} else if (nodesize & (sectorsize - 1)) {
>> +		error("illegal nodesize %u (not aligned to %u)",
>> +			nodesize, sectorsize);
>> +		return -1;
>> +	} else if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS &&
>> +		   nodesize != sectorsize) {
>> +		error("illegal nodesize %u (not equal to %u for mixed block group)",
>> +			nodesize, sectorsize);
>> +		return -1;
>> +	}
>> +	return 0;
>> +}
>> diff --git a/rescue.h b/rescue.h
>> new file mode 100644
>> index 000000000000..c9f6e7b80b16
>> --- /dev/null
>> +++ b/rescue.h
>> @@ -0,0 +1,14 @@
>> +/*
>> + * Copyright (C) 2018 SUSE.  All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public
>> + * License v2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +int btrfs_recover_superblocks(const char *path, int verbose, int yes);
>> +int btrfs_recover_chunk_tree(const char *path, int verbose, int yes);
>> diff --git a/super-recover.c b/super-recover.c
>> index 86b3df9867dc..a1af71786034 100644
>> --- a/super-recover.c
>> +++ b/super-recover.c
>> @@ -34,6 +34,7 @@
>>  #include "crc32c.h"
>>  #include "volumes.h"
>>  #include "commands.h"
>> +#include "rescue.h"
>>  
>>  struct btrfs_recover_superblock {
>>  	struct btrfs_fs_devices *fs_devices;
>> diff --git a/utils-lib.c b/utils-lib.c
>> index 044f93fc4446..5bb89f2f1a8d 100644
>> --- a/utils-lib.c
>> +++ b/utils-lib.c
>> @@ -1,4 +1,5 @@
>>  #include "kerncompat.h"
>> +#include "utils.h"
>>  #include <unistd.h>
>>  #include <stdlib.h>
>>  #include <limits.h>
>> diff --git a/utils.c b/utils.c
>> index a310300829eb..607a14e8f287 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -2252,29 +2252,6 @@ int btrfs_tree_search2_ioctl_supported(int fd)
>>  	return ret;
>>  }
>>  
>> -int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features)
>> -{
>> -	if (nodesize < sectorsize) {
>> -		error("illegal nodesize %u (smaller than %u)",
>> -				nodesize, sectorsize);
>> -		return -1;
>> -	} else if (nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
>> -		error("illegal nodesize %u (larger than %u)",
>> -			nodesize, BTRFS_MAX_METADATA_BLOCKSIZE);
>> -		return -1;
>> -	} else if (nodesize & (sectorsize - 1)) {
>> -		error("illegal nodesize %u (not aligned to %u)",
>> -			nodesize, sectorsize);
>> -		return -1;
>> -	} else if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS &&
>> -		   nodesize != sectorsize) {
>> -		error("illegal nodesize %u (not equal to %u for mixed block group)",
>> -			nodesize, sectorsize);
>> -		return -1;
>> -	}
>> -	return 0;
>> -}
>> -
>>  /*
>>   * Copy a path argument from SRC to DEST and check the SRC length if it's at
>>   * most PATH_MAX and fits into DEST. DESTLEN is supposed to be exact size of
>>
