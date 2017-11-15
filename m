Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33748 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752424AbdKOKSA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 05:18:00 -0500
Subject: Re: [PATCH] btrfs: handle dynamically reappearing missing device
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org
References: <20171112105650.3248-1-anand.jain@oracle.com>
 <201711151544.db5uf33W%fengguang.wu@intel.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <efe58777-792d-cd3c-d406-cd84c58909b2@oracle.com>
Date: Wed, 15 Nov 2017 18:18:09 +0800
MIME-Version: 1.0
In-Reply-To: <201711151544.db5uf33W%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/15/2017 03:38 PM, kbuild test robot wrote:
> Hi Anand,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on btrfs/next]
> [also build test ERROR on v4.14 next-20171114]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Anand-Jain/btrfs-handle-dynamically-reappearing-missing-device/20171115-143047
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git next
> config: sparc64-allyesconfig (attached as .config)
> compiler: sparc64-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          make.cross ARCH=sparc64
> 
> All errors (new ones prefixed by >>):
> 
>     fs/btrfs/volumes.c: In function 'device_list_add':
>>> fs/btrfs/volumes.c:732:10: error: implicit declaration of function 'btrfs_open_one_device'; did you mean 'btrfs_scan_one_device'? [-Werror=implicit-function-declaration]
>         ret = btrfs_open_one_device(fs_devices, device, fmode,
>               ^~~~~~~~~~~~~~~~~~~~~
>               btrfs_scan_one_device
>     cc1: some warnings being treated as errors


Its missing this patch set in the ML which was sent separately.
  [PATCH 0/4] factor __btrfs_open_devices()

Thanks, Anand


> vim +732 fs/btrfs/volumes.c
> 
>     610	
>     611	/*
>     612	 * Add new device to list of registered devices
>     613	 *
>     614	 * Returns:
>     615	 * 1   - first time device is seen
>     616	 * 0   - device already known
>     617	 * < 0 - error
>     618	 */
>     619	static noinline int device_list_add(const char *path,
>     620				   struct btrfs_super_block *disk_super,
>     621				   u64 devid, struct btrfs_fs_devices **fs_devices_ret)
>     622	{
>     623		struct btrfs_device *device;
>     624		struct btrfs_fs_devices *fs_devices;
>     625		struct rcu_string *name;
>     626		int ret = 0;
>     627		u64 found_transid = btrfs_super_generation(disk_super);
>     628	
>     629		fs_devices = find_fsid(disk_super->fsid);
>     630		if (!fs_devices) {
>     631			fs_devices = alloc_fs_devices(disk_super->fsid);
>     632			if (IS_ERR(fs_devices))
>     633				return PTR_ERR(fs_devices);
>     634	
>     635			list_add(&fs_devices->list, &fs_uuids);
>     636	
>     637			device = NULL;
>     638		} else {
>     639			device = __find_device(&fs_devices->devices, devid,
>     640					       disk_super->dev_item.uuid);
>     641		}
>     642	
>     643		if (!device) {
>     644			if (fs_devices->opened)
>     645				return -EBUSY;
>     646	
>     647			device = btrfs_alloc_device(NULL, &devid,
>     648						    disk_super->dev_item.uuid);
>     649			if (IS_ERR(device)) {
>     650				/* we can safely leave the fs_devices entry around */
>     651				return PTR_ERR(device);
>     652			}
>     653	
>     654			name = rcu_string_strdup(path, GFP_NOFS);
>     655			if (!name) {
>     656				kfree(device);
>     657				return -ENOMEM;
>     658			}
>     659			rcu_assign_pointer(device->name, name);
>     660	
>     661			mutex_lock(&fs_devices->device_list_mutex);
>     662			list_add_rcu(&device->dev_list, &fs_devices->devices);
>     663			fs_devices->num_devices++;
>     664			mutex_unlock(&fs_devices->device_list_mutex);
>     665	
>     666			ret = 1;
>     667			device->fs_devices = fs_devices;
>     668		} else if (!device->name || strcmp(device->name->str, path)) {
>     669			/*
>     670			 * When FS is already mounted.
>     671			 * 1. If you are here and if the device->name is NULL that
>     672			 *    means this device was missing at time of FS mount.
>     673			 * 2. If you are here and if the device->name is different
>     674			 *    from 'path' that means either
>     675			 *      a. The same device disappeared and reappeared with
>     676			 *         different name. or
>     677			 *      b. The missing-disk-which-was-replaced, has
>     678			 *         reappeared now.
>     679			 *
>     680			 * We must allow 1 and 2a above. But 2b would be a spurious
>     681			 * and unintentional.
>     682			 *
>     683			 * Further in case of 1 and 2a above, the disk at 'path'
>     684			 * would have missed some transaction when it was away and
>     685			 * in case of 2a the stale bdev has to be updated as well.
>     686			 * 2b must not be allowed at all time.
>     687			 */
>     688	
>     689			/*
>     690			 * For now, we do allow update to btrfs_fs_device through the
>     691			 * btrfs dev scan cli after FS has been mounted.  We're still
>     692			 * tracking a problem where systems fail mount by subvolume id
>     693			 * when we reject replacement on a mounted FS.
>     694			 */
>     695			if (!fs_devices->opened && found_transid < device->generation) {
>     696				/*
>     697				 * That is if the FS is _not_ mounted and if you
>     698				 * are here, that means there is more than one
>     699				 * disk with same uuid and devid.We keep the one
>     700				 * with larger generation number or the last-in if
>     701				 * generation are equal.
>     702				 */
>     703				return -EEXIST;
>     704			}
>     705	
>     706			name = rcu_string_strdup(path, GFP_NOFS);
>     707			if (!name)
>     708				return -ENOMEM;
>     709			rcu_string_free(device->name);
>     710			rcu_assign_pointer(device->name, name);
>     711			if (device->missing) {
>     712				int ret;
>     713				struct btrfs_fs_info *fs_info = fs_devices->fs_info;
>     714				fmode_t fmode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
>     715	
>     716				if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING)
>     717					fmode &= ~FMODE_WRITE;
>     718	
>     719				/*
>     720				 * Missing can be set only when FS is mounted.
>     721				 * So here its always fs_devices->opened > 0 and most
>     722				 * of the struct device members are already updated by
>     723				 * the mount process even if this device was missing, so
>     724				 * now follow the normal open device procedure for this
>     725				 * device. The scrub will take care of filling the
>     726				 * missing stripes for raid56 and balance for raid1 and
>     727				 * raid10.
>     728				 */
>     729				ASSERT(fs_devices->opened);
>     730				mutex_lock(&fs_devices->device_list_mutex);
>     731				mutex_lock(&fs_info->chunk_mutex);
>   > 732				ret = btrfs_open_one_device(fs_devices, device, fmode,
>     733								fs_info->bdev_holder);
>     734				if (!ret) {
>     735					fs_devices->missing_devices--;
>     736					device->missing = 0;
>     737					btrfs_clear_opt(fs_info->mount_opt, DEGRADED);
>     738					btrfs_warn(fs_info,
>     739						"BTRFS: device %s devid %llu uuid %pU joined\n",
>     740						path, devid, device->uuid);
>     741				}
>     742	
>     743				if (device->writeable &&
>     744						!device->is_tgtdev_for_dev_replace) {
>     745					fs_devices->total_rw_bytes += device->total_bytes;
>     746					atomic64_add(device->total_bytes -
>     747							device->bytes_used,
>     748							&fs_info->free_chunk_space);
>     749				}
>     750				device->in_fs_metadata = 1;
>     751				mutex_unlock(&fs_devices->fs_info->chunk_mutex);
>     752				mutex_unlock(&fs_devices->device_list_mutex);
>     753			}
>     754		}
>     755	
>     756		/*
>     757		 * Unmount does not free the btrfs_device struct but would zero
>     758		 * generation along with most of the other members. So just update
>     759		 * it back. We need it to pick the disk with largest generation
>     760		 * (as above).
>     761		 */
>     762		if (!fs_devices->opened)
>     763			device->generation = found_transid;
>     764	
>     765		/*
>     766		 * if there is new btrfs on an already registered device,
>     767		 * then remove the stale device entry.
>     768		 */
>     769		if (ret > 0)
>     770			btrfs_free_stale_device(device);
>     771	
>     772		*fs_devices_ret = fs_devices;
>     773	
>     774		return ret;
>     775	}
>     776	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
