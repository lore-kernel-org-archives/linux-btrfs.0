Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58406 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753775AbeF1NXg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 09:23:36 -0400
Subject: Re: [PATCH RFC] btrfs: Do extra device generation check at mount time
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180628070443.23421-1-wqu@suse.com>
 <575511f2-512c-2aa0-1dd9-027f00c4ce75@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6f5c1e15-f9ca-4e10-5e28-f671ceaa5f85@oracle.com>
Date: Thu, 28 Jun 2018 21:26:39 +0800
MIME-Version: 1.0
In-Reply-To: <575511f2-512c-2aa0-1dd9-027f00c4ce75@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/28/2018 04:02 PM, Qu Wenruo wrote:
> Also CC Anand Jain, since he is also working on various device related
> work, and an expert on this.
> 
> Especially I'm not pretty sure if such enhancement is already on his
> agenda or there are already some unmerged patch for this.

  Right, some of the patches are already in the ML and probably it needs
  a revival. Unless there are new challenges, my target is to consolidate
  them and get them integrated by this year. I am trying harder.

  I think its a good idea to report the write-hole status to the
  user-land instead of failing the mount, so that a script can trigger
  the re-silver as required by the use case. I introduced
  fs_devices::volume_flags, which is under review as of now, and have
  plans to add the volume degraded state bit which can be accessed by
  the sysfs. So yes this is been taken care.


Thanks, Anand


> Thanks,
> Qu
> 
> On 2018年06月28日 15:04, Qu Wenruo wrote:
>> There is a reporter considering btrfs raid1 has a major design flaw
>> which can't handle nodatasum files.
>>
>> Despite his incorrect expectation, btrfs indeed doesn't handle device
>> generation mismatch well.
>>
>> This means if one devices missed and re-appeared, even its generation
>> no longer matches with the rest device pool, btrfs does nothing to it,
>> but treat it as normal good device.
>>
>> At least let's detect such generation mismatch and avoid mounting the
>> fs.
>> Currently there is no automatic rebuild yet, which means if users find
>> device generation mismatch error message, they can only mount the fs
>> using "device" and "degraded" mount option (if possible), then replace
>> the offending device to manually "rebuild" the fs.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> I totally understand that, generation based solution can't handle
>> split-brain case (where 2 RAID1 devices get mounted degraded separately)
>> at all, but at least let's handle what we can do.
>>
>> The best way to solve the problem is to make btrfs treat such lower gen
>> devices as some kind of missing device, and queue an automatic scrub for
>> that device.
>> But that's a lot of extra work, at least let's start from detecting such
>> problem first.
>> ---
>>   fs/btrfs/volumes.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 50 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index e034ad9e23b4..80a7c44993bc 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -6467,6 +6467,49 @@ static void btrfs_report_missing_device(struct btrfs_fs_info *fs_info,
>>   			      devid, uuid);
>>   }
>>   
>> +static int verify_devices_generation(struct btrfs_fs_info *fs_info,
>> +				     struct btrfs_device *dev)
>> +{
>> +	struct btrfs_fs_devices *fs_devices = dev->fs_devices;
>> +	struct btrfs_device *cur;
>> +	bool warn_only = false;
>> +	int ret = 0;
>> +
>> +	if (!fs_devices || fs_devices->seeding || !dev->generation)
>> +		return 0;
>> +
>> +	/*
>> +	 * If we're not replaying log, we're completely safe to allow
>> +	 * generation mismatch as it won't write anything to disks, nor
>> +	 * remount to rw.
>> +	 */
>> +	if (btrfs_test_opt(fs_info, NOLOGREPLAY))
>> +		warn_only = true;
>> +
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(cur, &fs_devices->devices, dev_list) {
>> +		if (cur->generation && cur->generation != dev->generation) {
>> +			if (warn_only) {
>> +				btrfs_warn_rl_in_rcu(fs_info,
>> +	"devid %llu has unexpected generation, has %llu expected %llu",
>> +						     dev->devid,
>> +						     dev->generation,
>> +						     cur->generation);
>> +			} else {
>> +				btrfs_err_rl_in_rcu(fs_info,
>> +	"devid %llu has unexpected generation, has %llu expected %llu",
>> +						     dev->devid,
>> +						     dev->generation,
>> +						     cur->generation);
>> +				ret = -EINVAL;




>> +				break;
>> +			}
>> +		}
>> +	}
>> +	rcu_read_unlock();
>> +	return ret;
>> +}
>> +
>>   static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>>   			  struct extent_buffer *leaf,
>>   			  struct btrfs_chunk *chunk)
>> @@ -6552,6 +6595,13 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>>   				return PTR_ERR(map->stripes[i].dev);
>>   			}
>>   			btrfs_report_missing_device(fs_info, devid, uuid, false);
>> +		} else {
>> +			ret = verify_devices_generation(fs_info,
>> +							map->stripes[i].dev);
>> +			if (ret < 0) {
>> +				free_extent_map(em);
>> +				return ret;
>> +			}
>>   		}
>>   		set_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
>>   				&(map->stripes[i].dev->dev_state));
>>
> 
