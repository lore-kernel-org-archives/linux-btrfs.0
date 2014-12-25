Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39622 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaLYJVM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Dec 2014 04:21:12 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so17242228wiv.0
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 01:21:11 -0800 (PST)
Message-ID: <549BD770.60400@gmail.com>
Date: Thu, 25 Dec 2014 10:22:56 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
CC: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 5/8] Return the fsid from make_btrfs()
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it> <1418847252-14184-6-git-send-email-kreijack@inwind.it> <549B79FD.9080408@jp.fujitsu.com>
In-Reply-To: <549B79FD.9080408@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/25/2014 03:44 AM, Satoru Takeuchi wrote:
> On 2014/12/18 5:14, Goffredo Baroncelli wrote:
>> The function make_btrfs() has as argument the fsid of the filesystem.
>> If this fsid is empty or null make_btrfs() generates a new fsid. However
>> If the buffer is valid (but the string is empty) the generated fsid is
>> copied back to the caller.
> 
> The code is goods. However, I have a comment to the description.
> 
> In this case, describing the purpose of this patch is better.
> I consider your purpose is to use fs_uuid after make_btrfs()
> when user doesn't passed -U option.
> 
> Anyway,
> 
> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> Thanks,
> Satoru


Many thanks Satoru,

BR
G.Baroncelli

> 
>>
>> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
>> ---
>>   mkfs.c  | 7 ++++---
>>   utils.c | 7 ++++++-
>>   2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/mkfs.c b/mkfs.c
>> index 042d12e..70c88ea 100644
>> --- a/mkfs.c
>> +++ b/mkfs.c
>> @@ -1281,7 +1281,7 @@ int main(int ac, char **av)
>>   	int dev_cnt = 0;
>>   	int saved_optind;
>>   	char estr[100];
>> -	char *fs_uuid = NULL;
>> +	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
>>   	u64 features = DEFAULT_MKFS_FEATURES;
>>   
>>   	while(1) {
>> @@ -1356,7 +1356,8 @@ int main(int ac, char **av)
>>   				source_dir_set = 1;
>>   				break;
>>   			case 'U':
>> -				fs_uuid = optarg;
>> +				strncpy(fs_uuid,optarg,
>> +					BTRFS_UUID_UNPARSED_SIZE - 1);
>>   				break;
>>   			case 'K':
>>   				discard = 0;
>> @@ -1387,7 +1388,7 @@ int main(int ac, char **av)
>>   		exit(1);
>>   	}
>>   
>> -	if (fs_uuid) {
>> +	if (*fs_uuid) {
>>   		uuid_t dummy_uuid;
>>   
>>   		if (uuid_parse(fs_uuid, dummy_uuid) != 0) {
>> diff --git a/utils.c b/utils.c
>> index 3f50e4d..c7f1b2f 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -203,7 +203,7 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
>>   	memset(&super, 0, sizeof(super));
>>   
>>   	num_bytes = (num_bytes / sectorsize) * sectorsize;
>> -	if (fs_uuid) {
>> +	if (fs_uuid && *fs_uuid) {
>>   		if (uuid_parse(fs_uuid, super.fsid) != 0) {
>>   			fprintf(stderr, "could not parse UUID: %s\n", fs_uuid);
>>   			ret = -EINVAL;
>> @@ -216,6 +216,11 @@ int make_btrfs(int fd, const char *device, const char *label, char *fs_uuid,
>>   		}
>>   	} else {
>>   		uuid_generate(super.fsid);
>> +		/*
>> +		 * if the fs_uuid is a valid pointer, return the generated uuid
>> +		 */
>> +		if (fs_uuid)
>> +			uuid_unparse(super.fsid, fs_uuid);
>>   	}
>>   	uuid_generate(super.dev_item.uuid);
>>   	uuid_generate(chunk_tree_uuid);
>>
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
