Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:46371 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935235AbeEYHrL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 03:47:11 -0400
Subject: Re: [PATCH v4 3/3] btrfs: Do super block verification before writing
 it to disk
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180525044325.3365-1-wqu@suse.com>
 <20180525044325.3365-4-wqu@suse.com>
 <f6f5ebde-d61d-c10f-fa06-5df5d6171c3b@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1c59368e-14ea-5c81-9e20-63e9ea86e9b0@gmx.com>
Date: Fri, 25 May 2018 15:46:55 +0800
MIME-Version: 1.0
In-Reply-To: <f6f5ebde-d61d-c10f-fa06-5df5d6171c3b@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年05月25日 14:33, Nikolay Borisov wrote:
> 
> 
> On 25.05.2018 07:43, Qu Wenruo wrote:
>> There are already 2 reports about strangely corrupted super blocks,
>> where csum still matches but extra garbage gets slipped into super block.
>>
>> The corruption would looks like:
>> ------
>> superblock: bytenr=65536, device=/dev/sdc1
>> ---------------------------------------------------------
>> csum_type               41700 (INVALID)
>> csum                    0x3b252d3a [match]
>> bytenr                  65536
>> flags                   0x1
>>                         ( WRITTEN )
>> magic                   _BHRfS_M [match]
>> ...
>> incompat_flags          0x5b22400000000169
>>                         ( MIXED_BACKREF |
>>                           COMPRESS_LZO |
>>                           BIG_METADATA |
>>                           EXTENDED_IREF |
>>                           SKINNY_METADATA |
>>                           unknown flag: 0x5b22400000000000 )
>> ...
>> ------
>> Or
>> ------
>> superblock: bytenr=65536, device=/dev/mapper/x
>> ---------------------------------------------------------
>> csum_type              35355 (INVALID)
>> csum_size              32
>> csum                   0xf0dbeddd [match]
>> bytenr                 65536
>> flags                  0x1
>>                        ( WRITTEN )
>> magic                  _BHRfS_M [match]
>> ...
>> incompat_flags         0x176d200000000169
>>                        ( MIXED_BACKREF |
>>                          COMPRESS_LZO |
>>                          BIG_METADATA |
>>                          EXTENDED_IREF |
>>                          SKINNY_METADATA |
>>                          unknown flag: 0x176d200000000000 )
>> ------
>>
>> Obviously, csum_type and incompat_flags get some garbage, but its csum
>> still matches, which means kernel calculates the csum based on corrupted
>> super block memory.
>> And after manually fixing these values, the filesystem is completely
>> healthy without any problem exposed by btrfs check.
>>
>> Although the cause is still unknown, at least detect it and prevent further
>> corruption.
>>
>> Reported-by: Ken Swenson <flat@imo.uto.moe>
>> Reported-by: Ben Parsons <9parsonsb@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com> , however 1 question
> see below
> 
>> ---
>>  fs/btrfs/disk-io.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 43 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index b981ecc4b6f9..d6c0cee627d9 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2610,6 +2610,41 @@ static int btrfs_validate_mount_super(struct btrfs_fs_info *fs_info)
>>  	return __validate_super(fs_info, fs_info->super_copy, 0);
>>  }
>>  
>> +/*
>> + * Check the validation of super block at write time.
>> + * Some checks like bytenr check will be skipped as their values will be
>> + * overwritten soon.
>> + * Extra checks like csum type and incompact flags will be executed here.
>> + */
> 
> Is this comment correct though, since this function is called right
> before write_dev_supers which is performing the actual write and doesn't
> really modify anything on the superblock ?

It still does extra modification on bytenr and csum.

> Why would they be
> overwritten? Perhaps it's somewhat stale since I see in the old version
> (the one which is in misc-next now) we call btrfs_validate_write_super
> before going into the loop which writes the super on each dev.

Sorry I forgot to mention in this patch (only mentioned in cover letter).
There is one case that we didn't cover before.

For seed sprout case (mount seed device, and then add a new device), the
fs_info->super_copy is still the old seed device one, thus fsid won't
match with newly generated fsid.

So we still need to do the check later on, other than just using super_copy.

Thanks,
Qu

> 
>> +static int btrfs_validate_write_super(struct btrfs_fs_info *fs_info,
>> +				      struct btrfs_super_block *sb)
>> +{
>> +	int ret;
>> +
>> +	ret = __validate_super(fs_info, sb, -1);
>> +	if (ret < 0)
>> +		goto out;
>> +	if (btrfs_super_csum_type(sb) != BTRFS_CSUM_TYPE_CRC32) {
>> +		ret = -EUCLEAN;
>> +		btrfs_err(fs_info, "invalid csum type, has %u want %u",
>> +			  btrfs_super_csum_type(sb), BTRFS_CSUM_TYPE_CRC32);
>> +		goto out;
>> +	}
>> +	if (btrfs_super_incompat_flags(sb) & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
>> +		ret = -EUCLEAN;
>> +		btrfs_err(fs_info,
>> +		"invalid incompact flags, has 0x%llu valid mask 0x%llu",
>> +			  btrfs_super_incompat_flags(sb),
>> +			  BTRFS_FEATURE_INCOMPAT_SUPP);
>> +		goto out;
>> +	}
>> +out:
>> +	if (ret < 0)
>> +		btrfs_err(fs_info,
>> +		"super block corruption detected before writing it to disk");
>> +	return ret;
>> +}
>> +
>>  int open_ctree(struct super_block *sb,
>>  	       struct btrfs_fs_devices *fs_devices,
>>  	       char *options)
>> @@ -3770,6 +3805,14 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>>  		flags = btrfs_super_flags(sb);
>>  		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
>>  
>> +		ret = btrfs_validate_write_super(fs_info, sb);
>> +		if (ret < 0) {
>> +			mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>> +			btrfs_handle_fs_error(fs_info, -EUCLEAN,
>> +				"unexpected superblock corruption detected");
>> +			return -EUCLEAN;
>> +		}
>> +
>>  		ret = write_dev_supers(dev, sb, max_mirrors);
>>  		if (ret)
>>  			total_errors++;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
