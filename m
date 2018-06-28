Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37720 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933017AbeF1HGz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 03:06:55 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 15A3AAE5F
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 07:06:54 +0000 (UTC)
Subject: Re: [PATCH RFC] btrfs: Do extra device generation check at mount time
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180628070443.23421-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c5fc1287-cf27-75c0-3175-33d71014fe78@suse.com>
Date: Thu, 28 Jun 2018 10:06:53 +0300
MIME-Version: 1.0
In-Reply-To: <20180628070443.23421-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.06.2018 10:04, Qu Wenruo wrote:
> There is a reporter considering btrfs raid1 has a major design flaw
> which can't handle nodatasum files.
> 
> Despite his incorrect expectation, btrfs indeed doesn't handle device
> generation mismatch well.
> 
> This means if one devices missed and re-appeared, even its generation
> no longer matches with the rest device pool, btrfs does nothing to it,
> but treat it as normal good device.
> 
> At least let's detect such generation mismatch and avoid mounting the
> fs.
> Currently there is no automatic rebuild yet, which means if users find
> device generation mismatch error message, they can only mount the fs
> using "device" and "degraded" mount option (if possible), then replace
> the offending device to manually "rebuild" the fs.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

I think a testcase of this functionality is important as well.
> ---
> I totally understand that, generation based solution can't handle
> split-brain case (where 2 RAID1 devices get mounted degraded separately)
> at all, but at least let's handle what we can do.
> 
> The best way to solve the problem is to make btrfs treat such lower gen
> devices as some kind of missing device, and queue an automatic scrub for
> that device.
> But that's a lot of extra work, at least let's start from detecting such
> problem first.
> ---
>  fs/btrfs/volumes.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e034ad9e23b4..80a7c44993bc 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6467,6 +6467,49 @@ static void btrfs_report_missing_device(struct btrfs_fs_info *fs_info,
>  			      devid, uuid);
>  }
>  
> +static int verify_devices_generation(struct btrfs_fs_info *fs_info,
> +				     struct btrfs_device *dev)
> +{
> +	struct btrfs_fs_devices *fs_devices = dev->fs_devices;
> +	struct btrfs_device *cur;
> +	bool warn_only = false;
> +	int ret = 0;
> +
> +	if (!fs_devices || fs_devices->seeding || !dev->generation)
> +		return 0;
> +
> +	/*
> +	 * If we're not replaying log, we're completely safe to allow
> +	 * generation mismatch as it won't write anything to disks, nor
> +	 * remount to rw.
> +	 */
> +	if (btrfs_test_opt(fs_info, NOLOGREPLAY))
> +		warn_only = true;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(cur, &fs_devices->devices, dev_list) {
> +		if (cur->generation && cur->generation != dev->generation) {
> +			if (warn_only) {
> +				btrfs_warn_rl_in_rcu(fs_info,
> +	"devid %llu has unexpected generation, has %llu expected %llu",
> +						     dev->devid,
> +						     dev->generation,
> +						     cur->generation);
> +			} else {
> +				btrfs_err_rl_in_rcu(fs_info,
> +	"devid %llu has unexpected generation, has %llu expected %llu",
> +						     dev->devid,
> +						     dev->generation,
> +						     cur->generation);
> +				ret = -EINVAL;
> +				break;
> +			}
> +		}
> +	}
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
>  static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>  			  struct extent_buffer *leaf,
>  			  struct btrfs_chunk *chunk)
> @@ -6552,6 +6595,13 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>  				return PTR_ERR(map->stripes[i].dev);
>  			}
>  			btrfs_report_missing_device(fs_info, devid, uuid, false);
> +		} else {
> +			ret = verify_devices_generation(fs_info,
> +							map->stripes[i].dev);
> +			if (ret < 0) {
> +				free_extent_map(em);
> +				return ret;
> +			}
>  		}
>  		set_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
>  				&(map->stripes[i].dev->dev_state));
> 
