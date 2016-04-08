Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:36784 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbcDHTxG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 15:53:06 -0400
Date: Fri, 8 Apr 2016 22:53:00 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Missing device handling (was: 'unable to mount btrfs pool...')
Message-ID: <20160408195259.GA23661@jeknote.loshitsa1.net>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
 <CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
 <57064231.2070201@gmail.com>
 <CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
 <5707961D.6000803@gmail.com>
 <CAJCQCtT1Pt__k+aYqSjNPLmcgpH7F4N+ueJ3b+z+aVTYTYtGEg@mail.gmail.com>
 <57080530.7030805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57080530.7030805@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 08, 2016 at 03:23:28PM -0400, Austin S. Hemmelgarn wrote:
> On 2016-04-08 12:17, Chris Murphy wrote:
> 
> I would personally suggest adding a per-filesystem node in sysfs to handle
> both 2 and 5. Having it open tells BTRFS to not automatically attempt
> countermeasures when degraded, select/epoll on it will return when state
> changes, reads will return (at minimum): what devices comprise the FS, per
> disk state (is it working, failed, missing, a hot-spare, etc), and what
> effective redundancy we have (how many devices we can lose and still be
> mountable, so 1 for raid1, raid10, and raid5, 2 for raid6, and 0 for
> raid0/single/dup, possibly higher for n-way replication (n-1), n-order
> parity (n), or erasure coding). This would make it trivial to write a daemon
> to monitor the filesystem, react when something happens, and handle all the
> policy decisions.

Hm, good proposal. Personally I tried to use uevents for this but they
cause locking troubles, and I didn't continue this attempt.

In any case we need have interface for btrfs-progs to passing FS state
information (presence and IDs of missing devices, for example,
degraded/good state of RAID etc.).

For testing as first attempt I implemented following interface. It still seems
not good for me but acceptable as a starting point. Additionally to this, I changed
missing device name reported in btrfs_ioctl_dev_info() to 'missing' for avoiding of
interferences with block devices inserted after closing of failed device (adding of
'missing' field to the struct btrfs_ioctl_dev_info_args may be more right way). So,
your opinion?

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d9b147f..f9a2fa6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2716,12 +2716,17 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
 
        mutex_lock(&fs_devices->device_list_mutex);
        fi_args->num_devices = fs_devices->num_devices;
+       fi_args->missing_devices = fs_devices->missing_devices;
+       fi_args->open_devices = fs_devices->open_devices;
+       fi_args->rw_devices = fs_devices->rw_devices;
+       fi_args->total_devices = fs_devices->total_devices;
        memcpy(&fi_args->fsid, root->fs_info->fsid, sizeof(fi_args->fsid));
 
        list_for_each_entry(device, &fs_devices->devices, dev_list) {
                if (device->devid > fi_args->max_id)
                        fi_args->max_id = device->devid;
        }
+       fi_args->state = root->fs_info->fs_state;
        mutex_unlock(&fs_devices->device_list_mutex);
 
        fi_args->nodesize = root->fs_info->super_copy->nodesize;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index dea8931..6808bf2 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -186,8 +186,12 @@ struct btrfs_ioctl_fs_info_args {
        __u32 nodesize;                         /* out */
        __u32 sectorsize;                       /* out */
        __u32 clone_alignment;                  /* out */
-       __u32 reserved32;
-       __u64 reserved[122];                    /* pad to 1k */
+       __u32 state;                            /* out */
+       __u64 missing_devices;                  /* out */
+       __u64 open_devices;                     /* out */
+       __u64 rw_devices;                       /* out */
+       __u64 total_devices;                    /* out */
+       __u64 reserved[118];                    /* pad to 1k */
 };
 
 struct btrfs_ioctl_feature_flags {




-- 
Yauhen Kharuzhy
