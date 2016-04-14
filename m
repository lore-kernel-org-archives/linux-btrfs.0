Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:43309 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbcDNJKw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 05:10:52 -0400
Date: Thu, 14 Apr 2016 12:10:46 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Set superblock s_bdev field properly at device
 closing
Message-ID: <20160414091046.GA17024@jeknote.loshitsa1.net>
References: <1460470563-752-12-git-send-email-anand.jain@oracle.com>
 <1460596504-30172-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
 <570F3FCB.2090406@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <570F3FCB.2090406@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 14, 2016 at 02:59:23PM +0800, Anand Jain wrote:
> 
> 
> Hi Yauhen
> 
> On 04/14/2016 09:15 AM, Yauhen Kharuzhy wrote:
> >fs_info->sb->s_bdev field isn't set to any value at mount time
> 
>  There were patch to do set it at the vfs layer, or something like that.
> 
> >but is set
> >after device replacing or at device closing.
> 
>  Actually we are updating s_bdev/latest_bdev wrongly at most of
>  the device related operations, and not just here. I had plans
>  of wrapping all those into a common helper function and separate
>  from this patch set, when time permits, I am ok if you are fixing
>  all those.
> 
> Thanks, Anand

Yes, I can but I need to know expected behaviour. Should we set a s_bdev
field (as proposed in my patch) or we can keep it NULL because btrfs has
its own sync implementation and non-NULL value has no sense with multi-device FS?

Actually s_bdev is changed in two locations only: after device replace
and at device closing. At device replace we always (I hope...) may suppose that
target device's bdev is valid, so we need to change behaviour of
device_force_close() only. But I still didn't check latest_bdev exactly
meaning.

In any case, I will try to help to make global spare code stable first.

> 
> 
> >Existing code of
> >device_force_close() checks if current s_bdev is not equal to closing
> >bdev and, if equal, replace it by bdev field of first btrfs_device from
> >device list. This device may be the same as closed, and s_bdev field will
> >be invalid.
> >
> >If s_bdev is not NULL but references an freed block device, kernel
> >oopses at filesystem sync time on unmount.
> >
> >For multi-device FS setting of this field may be senseless, but using of
> >it should be consistent over the all btrfs code. So, set it on mount
> >time and select valid device at device closing time.
> >
> >Alternative solution may be to not set s_bdev entirely.
> >
> >Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
> >---
> >  fs/btrfs/super.c   |  1 +
> >  fs/btrfs/volumes.c | 16 ++++++++++++----
> >  2 files changed, 13 insertions(+), 4 deletions(-)
> >
> >diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> >index 3dd154e..1a2c58f 100644
> >--- a/fs/btrfs/super.c
> >+++ b/fs/btrfs/super.c
> >@@ -1522,6 +1522,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
> >  		char b[BDEVNAME_SIZE];
> >
> >  		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
> >+		s->s_bdev = bdev;
> >  		btrfs_sb(s)->bdev_holder = fs_type;
> >  		error = btrfs_fill_super(s, fs_devices, data,
> >  					 flags & MS_SILENT ? 1 : 0);
> >diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> >index 08ab116..f14f3f2 100644
> >--- a/fs/btrfs/volumes.c
> >+++ b/fs/btrfs/volumes.c
> >@@ -7132,6 +7132,7 @@ void device_force_close(struct btrfs_device *device)
> >  {
> >  	struct btrfs_device *next_device;
> >  	struct btrfs_fs_devices *fs_devices;
> >+	int found = 0;
> >
> >  	fs_devices = device->fs_devices;
> >
> >@@ -7139,13 +7140,20 @@ void device_force_close(struct btrfs_device *device)
> >  	mutex_lock(&fs_devices->fs_info->chunk_mutex);
> >  	spin_lock(&fs_devices->fs_info->free_chunk_lock);
> >
> >-	next_device = list_entry(fs_devices->devices.next,
> >-					struct btrfs_device, dev_list);
> >+	list_for_each_entry(next_device, &fs_devices->devices, dev_list) {
> >+		if (next_device->bdev && next_device->bdev != device->bdev) {
> >+			found = 1;
> >+			break;
> >+		}
> >+	}
> >+
> >  	if (device->bdev == fs_devices->fs_info->sb->s_bdev)
> >-		fs_devices->fs_info->sb->s_bdev = next_device->bdev;
> >+		fs_devices->fs_info->sb->s_bdev =
> >+			found ? next_device->bdev : NULL;
> >
> >  	if (device->bdev == fs_devices->latest_bdev)
> >-		fs_devices->latest_bdev = next_device->bdev;
> >+		fs_devices->latest_bdev =
> >+			found ? next_device->bdev : NULL;
> >
> >  	if (device->bdev)
> >  		fs_devices->open_devices--;
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Yauhen Kharuzhy
