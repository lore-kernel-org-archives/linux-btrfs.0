Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaENWHC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 18:07:02 -0400
Message-ID: <5373E908.4040800@redhat.com>
Date: Wed, 14 May 2014 17:07:04 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>
CC: jshubin@redhat.com
Subject: Re: PATCH V3] mkfs.btrfs: allow UUID specification at mkfs time
References: <5372C457.3000706@redhat.com> <53738D29.7020405@redhat.com> <5373AA3B.5000100@redhat.com> <5373E864.4040807@libero.it>
In-Reply-To: <5373E864.4040807@libero.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/14/14, 5:04 PM, Goffredo Baroncelli wrote:
> On 05/14/2014 07:39 PM, Eric Sandeen wrote:
>> Allow the specification of the filesystem UUID at mkfs time.
>>
>> Non-unique unique IDs are rejected.  This includes attempting
>> to re-mkfs with the same UUID; if you really want to do that,
>> you can mkfs with a new UUID, then re-mkfs with the one you
>> wanted.  ;)
>>
>> (Implemented only for mkfs.btrfs, not btrfs-convert).
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> NB: the prior patch didn't work well if you re-mkfs'd with
>> the same UUID; to be honest I didn't get to the bottom of it,
>> but the fact that that old UUID was already in an internal
>> list of present devices seems to have confused things.
>>
>> V2: reject non-unique unique IDs.
>> V3: test for non-unique unique IDs early in mkfs.
>>

<snip>

>> @@ -1368,6 +1374,20 @@ int main(int ac, char **av)
>>  			"The -r option is limited to a single device\n");
>>  		exit(1);
>>  	}
>> +
>> +	if (fs_uuid) {
>> +		uuid_t dummy_uuid;
>> +
>> +		if (uuid_parse(fs_uuid, dummy_uuid) != 0) {
>> +			fprintf(stderr, "could not parse UUID: %s\n", fs_uuid);
>> +			exit(1);
>> +		}
>> +		if (!test_uuid_unique(fs_uuid)) {
>> +			fprintf(stderr, "non-unique UUID: %s\n", fs_uuid);
>> +			exit(1);
>> +		}
> 
> My test showed that this detect a false positive when the user tries to mkfs two time on the same device with the same uuid.

It's not a false positive; after the first mkfs, the UUID does exist.  :)  See also the commit log I wrote.

>> diff --git a/utils.c b/utils.c
>> index 3e9c527..cfac0d4 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -93,12 +93,41 @@ static u64 reference_root_table[] = {
>>  	[6] =	BTRFS_CSUM_TREE_OBJECTID,
>>  };
>>  
>> -int make_btrfs(int fd, const char *device, const char *label,
>> +int test_uuid_unique(char *fs_uuid)
>> +{
>> +	int unique = 1;
>> +	blkid_dev_iterate iter = NULL;
>> +	blkid_dev dev = NULL;
>> +	blkid_cache cache = NULL;
>> +
>> +	if (blkid_get_cache(&cache, 0) < 0) {
>> +		printf("ERROR: lblkid cache get failed\n");
>> +		return 1;
>> +	}
>> +	blkid_probe_all(cache);
>> +	iter = blkid_dev_iterate_begin(cache);
>> +	blkid_dev_set_search(iter, "UUID", fs_uuid);
>> +
>> +	while (blkid_dev_next(iter, &dev) == 0) {
> 
> This function should skip the check for the devices involved in the mkfs.

Perhaps.  When I was doing something similar before, I ended up with 
inexplicable segfaults when a device found on initial scan (?) got recreated
with the same UUID.  Or something.

<snip>

>> @@ -125,7 +154,20 @@ int make_btrfs(int fd, const char *device, const char *label,
>>  	memset(&super, 0, sizeof(super));
>>  
>>  	num_bytes = (num_bytes / sectorsize) * sectorsize;
>> -	uuid_generate(super.fsid);
>> +	if (fs_uuid) {
>> +		if (uuid_parse(fs_uuid, super.fsid) != 0) {
>> +			fprintf(stderr, "could not parse UUID: %s\n", fs_uuid);
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +		if (!test_uuid_unique(fs_uuid)) {
>> +			fprintf(stderr, "non-unique UUID: %s\n", fs_uuid);
>> +			ret = -EBUSY;
>> +			goto out;
>> +		}
> 
> Why a second call to test_uuid_unique(fs_uuid) ?

Because kdave said he thought it was worth being paranoid in an earlier email,
if I understood him correctly.

-Eric
