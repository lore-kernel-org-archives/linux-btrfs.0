Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:14226 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730029AbeGQBik (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 21:38:40 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "anand.jain@oracle.com" <anand.jain@oracle.com>
Subject: RE: [PATCH v5 2/2] btrfs: get device pointer from
 btrfs_scan_one_device
Date: Tue, 17 Jul 2018 01:08:34 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A35A22@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1531733656-23806-1-git-send-email-gujx@cn.fujitsu.com>
 <1531732277-23517-2-git-send-email-gujx@cn.fujitsu.com>
 <20180716123417.GF3126@twin.jikos.cz>
In-Reply-To: <20180716123417.GF3126@twin.jikos.cz>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Monday, July 16, 2018 8:34 PM
> To: Gu, Jinxiang/¹Ë ½ğÏã <gujx@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org; anand.jain@oracle.com
> Subject: Re: [PATCH v5 2/2] btrfs: get device pointer from btrfs_scan_one_device
> 
> On Mon, Jul 16, 2018 at 05:11:17PM +0800, Gu Jinxiang wrote:
> > Instead of pointer to btrfs_fs_devices as an arg in
> > btrfs_scan_one_device, better to make it as a return value.
> >
> > And since btrfs_fs_devices can be get by btrfs_device,
> > better to return btrfs_device than fs_btrfs_devices.
> >
> > Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> > ---
> >
> > Changelog:
> > v5: rebase to misc-next.
> > v4: as suggested by Anand, change return value of
> >     btrfs_scan_one_device from btrfs_fs_devices to btrfs_device.
> > v3: as comment by robot, use PTR_ERR_OR_ZERO, and rebase to misc-next.
> > v2: as comment by Nikolay, use ERR_CAST instead of cast type manually.
> >
> >  fs/btrfs/super.c   | 35 ++++++++++++++++++++++-------------
> >  fs/btrfs/volumes.c | 22 ++++++++--------------
> >  fs/btrfs/volumes.h |  4 ++--
> >  3 files changed, 32 insertions(+), 29 deletions(-)
> >
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index dcab4a0244e5..413bbe2d6db2 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -888,7 +888,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
> >  {
> >  	substring_t args[MAX_OPT_ARGS];
> >  	char *device_name, *opts, *orig, *p;
> > -	struct btrfs_fs_devices *fs_devices = NULL;
> > +	struct btrfs_device *device = NULL;
> >  	int error = 0;
> >
> >  	lockdep_assert_held(&uuid_mutex);
> > @@ -918,11 +918,13 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
> >  				error = -ENOMEM;
> >  				goto out;
> >  			}
> > -			error = btrfs_scan_one_device(device_name, flags,
> > -							holder, &fs_devices);
> > +			device = btrfs_scan_one_device(device_name, flags,
> > +							holder);
> >  			kfree(device_name);
> > -			if (error)
> > +			if (IS_ERR(device)) {
> > +				error = PTR_ERR(device);
> >  				goto out;
> > +			}
> >  		}
> >  	}
> >
> > @@ -1518,6 +1520,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
> >  {
> >  	struct block_device *bdev = NULL;
> >  	struct super_block *s;
> > +	struct btrfs_device *device = NULL;
> >  	struct btrfs_fs_devices *fs_devices = NULL;
> >  	struct btrfs_fs_info *fs_info = NULL;
> >  	struct security_mnt_opts new_sec_opts;
> > @@ -1561,12 +1564,15 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
> >  		goto error_fs_info;
> >  	}
> >
> > -	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
> > -	if (error) {
> > +	device = btrfs_scan_one_device(device_name, mode, fs_type);
> > +	if (IS_ERR(device)) {
> > +		error = PTR_ERR(device);
> >  		mutex_unlock(&uuid_mutex);
> >  		goto error_fs_info;
> >  	}
> >
> > +	fs_devices = device->fs_devices;
> > +
> >  	fs_info->fs_devices = fs_devices;
> >
> >  	error = btrfs_open_devices(fs_devices, mode, fs_type);
> > @@ -2227,7 +2233,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
> >  				unsigned long arg)
> >  {
> >  	struct btrfs_ioctl_vol_args *vol;
> > -	struct btrfs_fs_devices *fs_devices;
> > +	struct btrfs_device *device = NULL;
> >  	int ret = -ENOTTY;
> >
> >  	if (!capable(CAP_SYS_ADMIN))
> > @@ -2240,19 +2246,22 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
> >  	switch (cmd) {
> >  	case BTRFS_IOC_SCAN_DEV:
> >  		mutex_lock(&uuid_mutex);
> > -		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
> > -					    &btrfs_root_fs_type, &fs_devices);
> > +		device = btrfs_scan_one_device(vol->name, FMODE_READ,
> > +					    &btrfs_root_fs_type);
> > +		ret = PTR_ERR_OR_ZERO(device);
> >  		mutex_unlock(&uuid_mutex);
> >  		break;
> >  	case BTRFS_IOC_DEVICES_READY:
> >  		mutex_lock(&uuid_mutex);
> > -		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
> > -					    &btrfs_root_fs_type, &fs_devices);
> > -		if (ret) {
> > +		device = btrfs_scan_one_device(vol->name, FMODE_READ,
> > +					    &btrfs_root_fs_type);
> > +		if (IS_ERR(device)) {
> > +			ret = PTR_ERR(device);
> >  			mutex_unlock(&uuid_mutex);
> >  			break;
> >  		}
> > -		ret = !(fs_devices->num_devices == fs_devices->total_devices);
> > +		ret = !(device->fs_devices->num_devices ==
> > +				device->fs_devices->total_devices);
> >  		mutex_unlock(&uuid_mutex);
> >  		break;
> >  	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 88d37bfa99c8..9f485696461b 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -1213,15 +1213,14 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
> >   * and we are not allowed to call set_blocksize during the scan. The superblock
> >   * is read via pagecache
> >   */
> > -int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
> > -			  struct btrfs_fs_devices **fs_devices_ret)
> > +struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags,
> > +					   void *holder)
> >  {
> >  	struct btrfs_super_block *disk_super;
> >  	bool new_device_added = false;
> > -	struct btrfs_device *device;
> > +	struct btrfs_device *ret = NULL;
> >  	struct block_device *bdev;
> >  	struct page *page;
> > -	int ret = 0;
> >  	u64 bytenr;
> >
> >  	lockdep_assert_held(&uuid_mutex);
> > @@ -1237,21 +1236,16 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
> >
> >  	bdev = blkdev_get_by_path(path, flags, holder);
> >  	if (IS_ERR(bdev))
> > -		return PTR_ERR(bdev);
> > +		return ERR_CAST(bdev);
> >
> >  	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
> > -		ret = -EINVAL;
> > +		ret = ERR_PTR(-EINVAL);
> >  		goto error_bdev_put;
> >  	}
> >
> > -	device = device_list_add(path, disk_super, &new_device_added);
> > -	if (IS_ERR(device)) {
> > -		ret = PTR_ERR(device);
> > -	} else {
> > -		*fs_devices_ret = device->fs_devices;
> > -		if (new_device_added)
> > -			btrfs_free_stale_devices(path, device);
> > -	}
> > +	ret = device_list_add(path, disk_super, &new_device_added);
> > +	if (new_device_added)
> > +		btrfs_free_stale_devices(path, ret);
> 
> Why is this skipping the error handling? I've resolved the conflict in a
> different way in misc-next, have you had a look there?

Since when new_device_added set to be true, the return value of device_list_add
must not a error value.
So, I think no necessary to add the judge.

> 
> Also the 'ret' got dropped and 'device' is used instead, the non-int
> type for ret would be confusing.
OK, Thank you.


> 
> >
> >  	btrfs_release_disk_super(page);
> >
> > diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> > index 9665b84b1026..06d8bb7dd557 100644
> > --- a/fs/btrfs/volumes.h
> > +++ b/fs/btrfs/volumes.h
> > @@ -403,8 +403,8 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
> >  			   int mirror_num, int async_submit);
> >  int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
> >  		       fmode_t flags, void *holder);
> > -int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
> > -			  struct btrfs_fs_devices **fs_devices_ret);
> > +struct btrfs_device *btrfs_scan_one_device(const char *path,
> > +					   fmode_t flags, void *holder);
> >  int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
> >  void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
> >  void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
> > --
> > 2.17.1
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
