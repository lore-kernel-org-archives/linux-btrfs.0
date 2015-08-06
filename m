Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:60825 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbbHFEBf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 00:01:35 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 820F9AC0151
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2015 13:01:32 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: add newline to some error messages
To: Zhao Lei <zhaolei@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <201508060305.AA00001@WIN-5MHF4RKU941.jp.fujitsu.com>
 <0bab01d0cffb$2c558f10$8500ad30$@cn.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <55C2DC0D.8010804@jp.fujitsu.com>
Date: Thu, 6 Aug 2015 13:01:17 +0900
MIME-Version: 1.0
In-Reply-To: <0bab01d0cffb$2c558f10$8500ad30$@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/08/06 12:51, Zhao Lei wrote:
> Hi, Itoh
>
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org
>> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Tsutomu Itoh
>> Sent: Thursday, August 06, 2015 11:06 AM
>> To: linux-btrfs@vger.kernel.org
>> Subject: [PATCH] btrfs-progs: add newline to some error messages
>>
>> Added a missing newline to some error messages.
>>
> Good found!
>
> Seems more code need to be fixed, as:
>
> # cat mkfs.c | tr -d '\n' | grep -o -w 'f\?printf([^(]*);' | sed 's/f\?printf[[:blank:]]*(\(stderr,\|\)[[:blank:]]*"\(.*\)"[,)].*/\2/g' | grep -v '\\n'                                  symlink too long for %s
> Incompat features:  %s
> #

It's OK.

       printf("Incompat features:  %s", features_buf);
       printf("\n");

>
> # cat utils.c | tr -d '\n' | grep -o -w 'f\?printf([^(]*);' | sed 's/f\?printf[[:blank:]]*(\(stderr,\|\)[[:blank:]]*"\(.*\)"[,)].*/\2/g' | grep -v '\\n'
> ERROR: DUP for data is allowed only in mixed mode
> %s [y/N]: *1
> #
> *1: It is not problem, should to be ignored

Already fixed by David in devel branch.

Thanks,
Tsutomu

>
> Thanks
> Zhaolei
>
>> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> ---
>>   btrfs-corrupt-block.c | 2 +-
>>   cmds-check.c          | 4 ++--
>>   cmds-send.c           | 4 ++--
>>   dir-item.c            | 6 +++---
>>   mkfs.c                | 2 +-
>>   5 files changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c index 1a2aa23..ea871f4
>> 100644
>> --- a/btrfs-corrupt-block.c
>> +++ b/btrfs-corrupt-block.c
>> @@ -1010,7 +1010,7 @@ int find_chunk_offset(struct btrfs_root *root,
>>   		goto out;
>>   	}
>>   	if (ret < 0) {
>> -		fprintf(stderr, "Error searching chunk");
>> +		fprintf(stderr, "Error searching chunk\n");
>>   		goto out;
>>   	}
>>   out:
>> diff --git a/cmds-check.c b/cmds-check.c index dd2fce3..0ddf57c 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -2398,7 +2398,7 @@ static int repair_inode_nlinks(struct
>> btrfs_trans_handle *trans,
>>   				  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
>>   				  mode);
>>   		if (ret < 0) {
>> -			fprintf(stderr, "Failed to create '%s' dir: %s",
>> +			fprintf(stderr, "Failed to create '%s' dir: %s\n",
>>   				dir_name, strerror(-ret));
>>   			goto out;
>>   		}
>> @@ -2426,7 +2426,7 @@ static int repair_inode_nlinks(struct
>> btrfs_trans_handle *trans,
>>   		}
>>   		if (ret < 0) {
>>   			fprintf(stderr,
>> -				"Failed to link the inode %llu to %s dir: %s",
>> +				"Failed to link the inode %llu to %s dir: %s\n",
>>   				rec->ino, dir_name, strerror(-ret));
>>   			goto out;
>>   		}
>> diff --git a/cmds-send.c b/cmds-send.c
>> index 20bba18..78ee54c 100644
>> --- a/cmds-send.c
>> +++ b/cmds-send.c
>> @@ -192,13 +192,13 @@ static int write_buf(int fd, const void *buf, int size)
>>   		ret = write(fd, (char*)buf + pos, size - pos);
>>   		if (ret < 0) {
>>   			ret = -errno;
>> -			fprintf(stderr, "ERROR: failed to dump stream. %s",
>> +			fprintf(stderr, "ERROR: failed to dump stream. %s\n",
>>   					strerror(-ret));
>>   			goto out;
>>   		}
>>   		if (!ret) {
>>   			ret = -EIO;
>> -			fprintf(stderr, "ERROR: failed to dump stream. %s",
>> +			fprintf(stderr, "ERROR: failed to dump stream. %s\n",
>>   					strerror(-ret));
>>   			goto out;
>>   		}
>> diff --git a/dir-item.c b/dir-item.c
>> index a5bf861..f3ad98f 100644
>> --- a/dir-item.c
>> +++ b/dir-item.c
>> @@ -285,7 +285,7 @@ int verify_dir_item(struct btrfs_root *root,
>>   	u8 type = btrfs_dir_type(leaf, dir_item);
>>
>>   	if (type >= BTRFS_FT_MAX) {
>> -		fprintf(stderr, "invalid dir item type: %d",
>> +		fprintf(stderr, "invalid dir item type: %d\n",
>>   		       (int)type);
>>   		return 1;
>>   	}
>> @@ -294,7 +294,7 @@ int verify_dir_item(struct btrfs_root *root,
>>   		namelen = XATTR_NAME_MAX;
>>
>>   	if (btrfs_dir_name_len(leaf, dir_item) > namelen) {
>> -		fprintf(stderr, "invalid dir item name len: %u",
>> +		fprintf(stderr, "invalid dir item name len: %u\n",
>>   		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
>>   		return 1;
>>   	}
>> @@ -302,7 +302,7 @@ int verify_dir_item(struct btrfs_root *root,
>>   	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
>>   	if ((btrfs_dir_data_len(leaf, dir_item) +
>>   	     btrfs_dir_name_len(leaf, dir_item)) >
>> BTRFS_MAX_XATTR_SIZE(root)) {
>> -		fprintf(stderr, "invalid dir item name + data len: %u + %u",
>> +		fprintf(stderr, "invalid dir item name + data len: %u + %u\n",
>>   		       (unsigned)btrfs_dir_name_len(leaf, dir_item),
>>   		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
>>   		return 1;
>> diff --git a/mkfs.c b/mkfs.c
>> index dafd500..909b591 100644
>> --- a/mkfs.c
>> +++ b/mkfs.c
>> @@ -599,7 +599,7 @@ static int add_symbolic_link(struct btrfs_trans_handle
>> *trans,
>>   		goto fail;
>>   	}
>>   	if (ret >= sectorsize) {
>> -		fprintf(stderr, "symlink too long for %s", path_name);
>> +		fprintf(stderr, "symlink too long for %s\n", path_name);
>>   		ret = -1;
>>   		goto fail;
>>   	}
>> --
>> 2.4.5
>>
>> ----
>> Tsutomu Itoh  t-itoh@jp.fujitsu.com
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body
>> of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


