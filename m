Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BA14CA788
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 19:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789499807; cv=none; b=sXBzVtUPS2hLKsumx/7rrRV/JlmNYRHp7srCr1uMR4ZHQJcuayYuKI45Fu6jU9xWYebFa7TzYgI0Rj94GQTwyhQ7DMQFVdyt7AK85sJmDuFXliRXK7QFuldt8PRmsRuG4liVYmNz6WwCgKIKU9NirYhjRa2TzgCO8yDEu4H+9/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789499807; c=relaxed/simple;
	bh=mb85EAULYxyqmrRFJCpp4Houz24oS0/6C2SMC9kFwmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qLV84Cfwht86aarl1W5gT/iErjL4kfyuP6yyS8GDNZ7AP0fJwxlddrAk5MfKGn5aIgYgmC0SqB18ZWL723lrwCgy/8kZQPOIYGRSUaTT44YL8af631lV+v18uUHIs/UmwesR4rm120GpHCJEhdMVVdc4JQMexXhkWsD2sIdem6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=MPfeBS0w; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WOR5qGPW; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="MPfeBS0w";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WOR5qGPW"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 71DB81D00184;
	Tue, 15 Sep 2026 15:16:43 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 15 Sep 2026 15:16:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1789499803; x=1789586203; bh=jzqf6rIZ3a
	fErJ3PDSKcAcCChzISy1x+nm6y+Zs0pnk=; b=MPfeBS0waj+3B9fBt3wfO0mAt0
	+CsuDDEnRNb88aZdyI6UVASb2ioDi2oYO+P7g6HecM3iixa39Qm41BPnY3s8pJ4s
	7LHFZuFYfiKP5nbVekl3eXB5H0Lmmn/ng5dFpVJbCbbguTlCF8EiLwykf64a7xHz
	cTc4YhZypHeHewUe13G/gqv7ncMZdW5dmg8iC89Il5VN1vXfmaJXWHiVRqNnduMC
	5Od0S7I7xB8jm1tVu0rohG9uFoF1v6FZaerVMK9HgxJNExkXb0ABFWtS084kF4mL
	QLPuBavIdR89/cMU9oqctz28ajKioTtSWkq+tVwGLrpjtD0reY+O84fKhZkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789499803; x=1789586203; bh=jzqf6rIZ3afErJ3PDSKcAcCChzISy1x+nm6
	y+Zs0pnk=; b=WOR5qGPWUIxMAQCT0P/oG1u+r7Us+efARujMqWZa4MmIVGp/V/y
	zt4CNTFlxGO91XYzwdERF+qkSjy9ZwdjRSI/IYDg5Qjktciqy0/bNf5ObrYAU3Tb
	u5i/LRfOKou4+J5pIb7IKIekAcEkQIqpzhCffSG8WYofdkM6Z+Ml5ywGohzxxnnE
	4C3uKJNAnA2CCTJ2QIPirAixt2Hpk6mJkXqZVhXWVKFOW/h3UyQQtIGLDvNx45b7
	y9uRVPHrqdb/SWUeJ/4ftZ1HvOkfTigep9Pi6ocXQuyscy+iLlY+jRDyA8e1KSVO
	ZCz0Y4Tiyd5VdXxlvIs5Mti3rvdvPMG5kdg==
X-ME-Sender: <xms:m5mpaiS0B2vPFD2wZJpCHkRXZfEoV2p1cc25xt8A1sQP9SbLzwMgoQ>
    <xme:m5mpatyq45-y78yJxm0_VADQVA4lulSMamljabupA5qDu56a3eFlFSTR_JCQq_Igh
    WcYpV9-8rY7i7sh1Kv_dZil9ZfRyiY5z7__5oAcyyWDvHtoC11RSYjmJw>
X-ME-Received: <xmr:m5mpatddih5LBInQYabEAPivxGoYHGEnyEVA2mTvTOPlSoJpWiKzVMA>
X-ME-Proxy-Cause: dmFkZTF0IW2ayHWWCICHLvezycQT8V39TSYb/9hPVy+qXoYq0XFGe5bKwqxDEIJ4h/pjoV
    0E5YKT72PjPIk/Kevk2lQgdeZu62QHSTsOMvHcBbeTsUmfMJrUsb0qoZOQrBKJNvWKYN2s
    cppuITMl0AmtTRyfBusMq2o6Y8mREr8GfsBr9dsNUrzWUP3ea09KQ20e2CffhcHpGJcPkq
    aVIVsj28MrewgZwl1k/TAq0vywnE+xRaOTcwRRwT0XDGE2AS0dWthxRXljLckMMVIsGMmt
    Q48l3MH9hQDwAx7gt+Gq7WdHSTDaA7SiGd75zRg8i/dtS59BVUleZy+E95Czh+JtQC8so9
    tijt4z5eg5QT1+ifNSq+LCfQxsUvR9VAdBuAoLam9ipGBjINtCX8NYw5Sf3+HwYO9OnK9W
    zVPZn79STB79WcDJeA4QZuSSrGE4+v+AFIA99GinmRq3CJPNfYDPlcJEtLTA0Ol/ZY6yHx
    QGZQSlaGLjQJCWRXZLPzdwOHJrBk92E9dR6cU+K4tMkFJxwbqjhDP2h+oEwwUaxC+rNV5/
    UuzoFQm6aDfcw74adEZeqyCw28U8KwJhNGPisnE8ovF84acyN4GGHRbEcxaabFLzROgp5s
    ckukHyejexcW7Div1x91TLnLJepgHAD/1+wQmG8iaacLlP/jiXVWX9S8nO8Q
X-ME-Proxy: <xmx:m5mpapJnR21fPhPBjhLMhEzpovEdLdYXspb0_7IveAqjQa_NQ98ZvQ>
    <xmx:m5mpauHC0q7WsinWM0E4VqED2rjvmGev-ZaAKUHxQYBJefIXFuOGCw>
    <xmx:m5mpajoL1y3LWKksZGqceMn764wUNeDtyAKwaZ_-IPQZmEv1_h4sOw>
    <xmx:m5mpanSWsjm_QWEOUZXVnp_skS7FtGQmrLZJGzQ1k1El65Ano4ZuNw>
    <xmx:m5mpaueng7egksDcHIhJ7qu-jRA17wiiyVU4f3MiERChws5EkbwBqBQO>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Sep 2026 15:16:42 -0400 (EDT)
Date: Tue, 15 Sep 2026 12:16:59 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: introduce a new ioctl to force updating the
 device name
Message-ID: <20260915191659.GB910335@zen.localdomain>
References: <5e65d9ba5927b4b6985ce819e9e49d082c6e9b45.1789112424.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e65d9ba5927b4b6985ce819e9e49d082c6e9b45.1789112424.git.wqu@suse.com>

On Fri, Sep 11, 2026 at 05:10:28PM +0930, Qu Wenruo wrote:
> Btrfs has a very long history fighting to determine what is the proper
> name to show in btrfs_show_devname().
> 
> The long history includes:
> 
> - 7e06de7c83a7 ("btrfs: canonicalize the device path before adding it")
>   To address a report that a very weird path can be utilized to do the
>   mount, and btrfs saves that weird path as the device name.
>   But such a name cannot be accessed outside of a certain pid, so the end
>   result is that the device shown in btrfs is completely meaningless.
> 
>   That commit tries to canonicalize the path, but it is not good enough.
> 
> - 2e8b6bc0ab41 ("btrfs: avoid unnecessary device path update for the same device")
>   This is to address a lot of unnecessary device path updates caused by
>   different soft links of the same block device.
> 
> - 8fb1dcbbcc1f ("Revert "btrfs: canonicalize the device path before adding it"")
>   This reverts the first patch.
> 
>   The reason is that the "/dev/" directory is not guaranteed to be a
>   devfs, it can be a regular directory with manually populated special
>   files, and it can even be in a different name space, which means other
>   namespaces may not see the same special file at all.
> 
> - 108cc8733989 ("btrfs: fix a lockdep caused by path resolution during device scan")
>   This one completely gets rid of the path based device check, to avoid
>   deadlock.
> 
>   Since the "/dev/" is not ensured to be a devfs, one can put "/dev/"
>   into a btrfs, and path resolution will lock the involved inode,
>   meanwhile device scan also needs to lock that inode, which can lead to
>   deadlock.
> 
> - A recent report that the device name shown in mountinfo is incorrect
>   This is another corner case where the end user is booting the kernel
>   without an initramfs.
>   So that at rootfs mount time, a special path "/dev/root" is passed as
>   the device for rootfs.
> 
>   And a later btrfs device rescan won't update the device name since the
>   newer name points to the same devt.
> 
> In short, unlike LVM which uses device-mapper and has a dedicated dm-*
> device, btrfs has to directly manage the device names during mount/rescan
> and all kinds of corner cases inside btrfs itself.
> 
> Instead of handling all those hassles inside btrfs, push the
> responsibility to end users, and provide a new ioctl to force updating
> the btrfs device path.
> 
> Now all the decisions are made by end users, they have every right to do
> stupid things (including namespace related hassles) or to replace
> outdated device paths with a correct one.
> 
> With this new ioctl and corresponding btrfs-progs changes, end users
> finally have the proper way to update the weird names shown in
> btrfs_show_devname():
> 
>  # cd /dev
>  # mknod weird b 253 3
>  # mount /dev/weird /mnt/btrfs
>  # mount | grep weird
>  /dev/weird on /mnt/btrfs type btrfs (rw,relatime,discard=async,space_cache=v2,subvolid=5,subvol=/)
>  ^^^^^^^^^^ The weird name is still utilized here.
>  # btrfs dev scan -r /dev/test/scratch1

One thing that is slightly unclear to me is what the required connection
between /dev/weird and /dev/test/scratch1 is. I would hope that they
must resolve to the same device for this to work / make sense.

Can you make that relationship a little more clear in this worked
example by including some commands defining/printing /dev/test/scratch1?

>  # dmesg -t | tail -n1
>  BTRFS info: devid 1 device path /dev/weird changed to /dev/mapper/test-scratch1 scanned by btrfs (4068)
>  # mount | tail -n1
>  /dev/mapper/test-scratch1 on /mnt/btrfs type btrfs (rw,relatime,discard=async,space_cache=v2,subvolid=5,subvol=/)
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v3:
> - Remove the DEVICE_READY ioctl change
>   That will break the kernel ABI, and there is really no special meaning
>   for using _IOW other than a different ioctl number.
> 
> v2:
> - Add a new patch to fix an existing bug in ioctl read/write direction
> 
> - Use the correct _IOW for the new ioctl
>   Exposed by Sashiko, and the older wrong direction was copied from the
>   only exception.
> ---
>  fs/btrfs/super.c           | 16 +++++++++++-----
>  fs/btrfs/volumes.c         | 24 +++++++++++++++++-------
>  fs/btrfs/volumes.h         |  6 +++++-
>  include/uapi/linux/btrfs.h |  2 ++
>  4 files changed, 35 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 464129b1b0d4..76c58a2e6d40 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -374,7 +374,7 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
>  		struct btrfs_device *device;
>  
>  		mutex_lock(&uuid_mutex);
> -		device = btrfs_scan_one_device(param->string, false);
> +		device = btrfs_scan_one_device(param->string, 0);
>  		mutex_unlock(&uuid_mutex);
>  		if (IS_ERR(device))
>  			return PTR_ERR(device);
> @@ -1872,10 +1872,10 @@ static int btrfs_get_tree_super(struct fs_context *fc)
>  	mutex_lock(&uuid_mutex);
>  
>  	/*
> -	 * With 'true' passed to btrfs_scan_one_device() (mount time) we expect
> +	 * With BTRFS_SCAN_DEV_MOUNT passed to btrfs_scan_one_device() we expect
>  	 * either a valid device or an error.
>  	 */
> -	device = btrfs_scan_one_device(fc->source, true);
> +	device = btrfs_scan_one_device(fc->source, BTRFS_SCAN_DEV_MOUNT);
>  	ASSERT(device != NULL);
>  	if (IS_ERR(device)) {
>  		mutex_unlock(&uuid_mutex);
> @@ -2270,7 +2270,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>  		 * Scanning outside of mount can return NULL which would turn
>  		 * into 0 error code.
>  		 */
> -		device = btrfs_scan_one_device(vol->name, false);
> +		device = btrfs_scan_one_device(vol->name, 0);
>  		ret = PTR_ERR_OR_ZERO(device);
>  		mutex_unlock(&uuid_mutex);
>  		break;
> @@ -2288,7 +2288,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>  		 * Scanning outside of mount can return NULL which would turn
>  		 * into 0 error code.
>  		 */
> -		device = btrfs_scan_one_device(vol->name, false);
> +		device = btrfs_scan_one_device(vol->name, 0);
>  		if (IS_ERR_OR_NULL(device)) {
>  			mutex_unlock(&uuid_mutex);
>  			ret = PTR_ERR_OR_ZERO(device);
> @@ -2298,6 +2298,12 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>  			device->fs_devices->total_devices);
>  		mutex_unlock(&uuid_mutex);
>  		break;
> +	case BTRFS_IOC_RENAME_DEV:
> +		mutex_lock(&uuid_mutex);

What privileges does this require? We don't check CAP_SYS_ADMIN or
anything like it, but maybe being able to read the /dev/ files implies
sufficient privilege? Somehow this feels similar enough to ADD_DEVICE
that it ought to require CAP_SYS_ADMIN?

> +		device = btrfs_scan_one_device(vol->name, BTRFS_SCAN_DEV_RENAME);
> +		ret = PTR_ERR_OR_ZERO(device);
> +		mutex_unlock(&uuid_mutex);
> +		break;
>  	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
>  		ret = btrfs_ioctl_get_supported_features((void __user*)arg);
>  		break;
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 4ddabadc9188..268bf10ab181 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -758,7 +758,7 @@ const u8 *btrfs_sb_fsid_ptr(const struct btrfs_super_block *sb)
>   */
>  static noinline struct btrfs_device *device_list_add(const char *path,
>  			   struct btrfs_super_block *disk_super,
> -			   bool *new_device_added)
> +			   bool *new_device_added, bool force_rename)
>  {
>  	struct btrfs_device *device;
>  	struct btrfs_fs_devices *fs_devices = NULL;
> @@ -869,7 +869,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
>  				MAJOR(path_devt), MINOR(path_devt),
>  				current->comm, task_pid_nr(current));
>  
> -	} else if (!device->name || device->devt != path_devt) {

Going back to my question above, just to be sure I undertand:

My understanding is that we get here when we found fs_devices by
path_devt and then found device by devid. So the new force_rename is to
use the new name when we find the device and the name is present and the
devt matches.

So basically we use the new name for the same maj:min by force, which is
the intended behavior.

The part that is less clear is whether it is possible to hit any of the
other scanning paths that modify the device by attempting the force rename
with some different device. Like if I craft a device with the right
UUID, devid but wrong devt, then call this ioctl or something. If it
gets to *this* code, it is probably ok anyway, but if it takes some
other path, it could be messing with the core volume logic without
enough permissions.

Thanks,
Boris

> +	} else if (!device->name || device->devt != path_devt || force_rename) {
>  		const char *old_name;
>  
>  		/*
> @@ -882,9 +882,14 @@ static noinline struct btrfs_device *device_list_add(const char *path,
>  		 *         different name. or
>  		 *      b. The missing-disk-which-was-replaced, has
>  		 *         reappeared now.
> +		 *      c. A device scan is triggered on different soft links
> +		 *         of the block device.
>  		 *
> -		 * We must allow 1 and 2a above. But 2b would be a spurious
> -		 * and unintentional.
> +		 * We must allow 1 and 2a above.
> +		 * For 2c, we should only allow it when it's triggered from
> +		 * BTRFS_IOC_RENAME_DEV.
> +		 *
> +		 * But 2b would be a spurious and unintentional.
>  		 *
>  		 * Further in case of 1 and 2a above, the disk at 'path'
>  		 * would have missed some transaction when it was away and
> @@ -1443,14 +1448,19 @@ static bool btrfs_skip_registration(struct btrfs_super_block *disk_super,
>   * and we are not allowed to call set_blocksize during the scan. The superblock
>   * is read via pagecache.
>   *
> - * With @mount_arg_dev it's a scan during mount time that will always register
> + * With BTRFS_SCAN_DEV_MOUNT it's a scan during mount time that will always register
>   * the device or return an error. Multi-device and seeding devices are registered
>   * in both cases.
> + *
> + * With BTRFS_SCAN_DEV_RENAME it's to force a device name update for a mounted
> + * device.
>   */
>  struct btrfs_device *btrfs_scan_one_device(const char *path,
> -					   bool mount_arg_dev)
> +					   unsigned int flags)
>  {
>  	struct btrfs_super_block *disk_super;
> +	bool mount_arg_dev = flags & BTRFS_SCAN_DEV_MOUNT;
> +	bool force_rename = flags & BTRFS_SCAN_DEV_RENAME;
>  	bool new_device_added = false;
>  	struct btrfs_device *device = NULL;
>  	struct file *bdev_file;
> @@ -1489,7 +1499,7 @@ struct btrfs_device *btrfs_scan_one_device(const char *path,
>  		goto free_disk_super;
>  	}
>  
> -	device = device_list_add(path, disk_super, &new_device_added);
> +	device = device_list_add(path, disk_super, &new_device_added, force_rename);
>  	if (!IS_ERR(device) && new_device_added)
>  		btrfs_free_stale_devices(device->devt, device);
>  
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 337d7007d9e2..509e1c0ef67c 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -747,7 +747,11 @@ struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
>  void btrfs_mapping_tree_free(struct btrfs_fs_info *fs_info);
>  int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  		       blk_mode_t flags, void *holder);
> -struct btrfs_device *btrfs_scan_one_device(const char *path, bool mount_arg_dev);
> +
> +#define BTRFS_SCAN_DEV_MOUNT	(1U << 0)
> +#define BTRFS_SCAN_DEV_RENAME	(1U << 1)
> +struct btrfs_device *btrfs_scan_one_device(const char *path, unsigned int flags);
> +
>  int btrfs_forget_devices(dev_t devt);
>  void btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>  void btrfs_release_device_allow_freeze(struct file *bdev_file);
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 0a13baf3d8d1..ea95470b1347 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -1226,6 +1226,8 @@ struct btrfs_ioctl_get_csums_args {
>  #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
>  			       struct btrfs_ioctl_quota_rescan_args)
>  #define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
> +#define BTRFS_IOC_RENAME_DEV _IOW(BTRFS_IOCTL_MAGIC, 47, \
> +				  struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_GET_FSLABEL 	FS_IOC_GETFSLABEL
>  #define BTRFS_IOC_SET_FSLABEL	FS_IOC_SETFSLABEL
>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
> -- 
> 2.55.0
> 
