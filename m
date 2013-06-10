Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab3FJUa4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 16:30:56 -0400
Date: Mon, 10 Jun 2013 13:30:54 -0700
From: Zach Brown <zab@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] btrfs: add framework to read fs info and dev info
 from the kernel
Message-ID: <20130610203054.GK24721@lenny.home.zabbo.net>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
 <1370876355-16584-1-git-send-email-anand.jain@oracle.com>
 <1370876355-16584-3-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370876355-16584-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 10, 2013 at 10:59:15PM +0800, Anand Jain wrote:
> This adds two ioctl BTRFS_IOC_GET_FSIDS and BTRFS_IOC_GET_DEVS
> which reads the btrfs_fs_devices and btrfs_device structure
> from the kernel respectively.

Why not just use sysfs to export the device lists?

> The information in these structure are useful to report the
> device/fs information in line with the kernel operations and
> thus immediately addresses the problem that 'btrfs fi show'
> command reports the stale information after device device add
> remove operation is performed. That is because btrfs fi show
> reads the disks directly.

Hmm.  Would it be enough to get the block device address_space in sync
with the btrfs stuctures?  Would that get rid of the need for this
interface?

But sure, for the sake of argument and code review, let's say that we
wanted some ioctls to read the btrfs kernel device lists.

> Further the frame-work provided here would help to enhance

Please don't add a layer of generic encoding above these new ioctls.
It's not necessary and it makes more work for the various parts of the
world that want to do deep ioctl inspection (think, for example, of
strace).

> +static size_t get_ioctl_sz(size_t pl_list_sz, u64 mul, u64 alloc_cnt)
> +
> +static int get_ioctl_header_and_payload(unsigned long arg,
> +		size_t unit_sz, int default_len,
> +		struct btrfs_ioctl_header **argp, size_t *sz)

This adds a lot of fiddly math and allocation that can go wrong for no
benefit.  We can restructure the interface so all of this code goes
away.

1) Have a simple single fixed input structure for each ioctl.  Maybe
with some extra padding and a flags argument if you think stuff is going
to be added over time.  No generic header.  No casting.  The ioctl
number defines the input structure.  If you need a different structure
later, use a different ioctl number.

2) Don't have a fixed array of output structs embedded in the input
struct.  Have a pointer to the array of output structs in the input
struct.  Probably with a number of elements found there.

3) Don't copy the giant user output buffer into the kernel, write to it,
then copy it back to user space.  Instead have the kernel copy_to_user()
each output structure to the userspace pointer as it goes.  Have the
ioctl() return a positive count of the number of elements copied.

>  static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>  				unsigned long arg)
>  {
> -	struct btrfs_ioctl_vol_args *vol;
> +	struct btrfs_ioctl_vol_args *vol = NULL;
>  	struct btrfs_fs_devices *fs_devices;
> -	int ret = -ENOTTY;
> +	struct btrfs_ioctl_header *argp = NULL;
> + 	int ret = -ENOTTY;
> +	size_t sz = 0;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> -	vol = memdup_user((void __user *)arg, sizeof(*vol));
> -	if (IS_ERR(vol))
> -		return PTR_ERR(vol);
> -
>  	switch (cmd) {
>  	case BTRFS_IOC_SCAN_DEV:
> +		vol = memdup_user((void __user *)arg, sizeof(*vol));
> +		if (IS_ERR(vol))
> +			return PTR_ERR(vol);

Hmm, having to duplicate that previously shared setup into each ioctl
block is a sign that the layering is wrong.

Don't smush the new ioctls into case bodies of this existing simple
fuction that worked with the _vol_args ioctls.  Rename this
btrfs_ioctl_vol_args, or something, and call it from a tiny new
btrfs_control_ioctl() for its two ioctls.  That new high level btrfs
ioctl dispatch function can then call the two new _get_devs and
_get_fsids functions.

> +	case BTRFS_IOC_GET_FSIDS:
> +		ret = get_ioctl_header_and_payload(arg,
> +				sizeof(struct btrfs_ioctl_fs_list),
> +				BTRFS_FSIDS_LEN, &argp, &sz);
> +		if (ret == 1) {
> +			ret = copy_to_user((void __user *)arg, argp, sz);
> +			kfree(argp);
> +			return -EFAULT;
> +		} else if (ret)
> +			return -EFAULT;
> +		ret = btrfs_get_fsids(argp);
> +		if (ret == 0 && copy_to_user((void __user *)arg, argp, sz))
> +			ret = -EFAULT;
> +		kfree(argp);
> +		break;

All of this can go away if you have trivial input and array-of-output
args that the ioctl helper works with.

	case BTRFS_IOC_GET_FSIDS:
		ret = btrfs_ioctl_get_fsids(arg);
		break;

> +int btrfs_get_fsids(struct btrfs_ioctl_header *argp)
> +{
> +	u64 cnt = 0;
> +	struct btrfs_device *device;
> +	struct btrfs_fs_devices *fs_devices;
> +	struct btrfs_ioctl_fs_list *fslist;
> +	struct btrfs_ioctl_fsinfo *fsinfo;
> +
> +	fslist = (struct btrfs_ioctl_fs_list *)((u8 *)argp
> +						+ sizeof(*argp));

Instead of working with an allocated copy of the input, copy the user
input struct onto the stack here.

	struct btrfs_ioctl_get_fsids_input in;

	if (copy_from_user(&in, argp, sizeof(in)))
		return -EFAULT;

(Or you could get_user() each field.. but that's probably not worth it
for a small input struct.)

> +
> +	list_for_each_entry(fs_devices, &fs_uuids, list) {

Surely this needs to be protected by some lock?  The uuid_mutex, maybe?

> +			fsinfo = &fslist->fsinfo[cnt];
> +			memcpy(fsinfo->fsid, fs_devices->fsid,
> +					BTRFS_FSID_SIZE);

And then copy each device's output struct back to userspace one at a
time instead of building them up in the giant allocated kernel buffer.

This might get a little hairy if you don't want to block under the
uuid_mutex, but that's solvable too (dummy cursor items on the list,
probably).

> +				fsinfo->bytes_used = device->dev_root\
> +						->fs_info->super_copy->bytes_used;

A line continuation in the middle of a pointer deref?  Cache the
super_copy pointer on the stack, maybe.  It's probably better to use a
function that copies a single device's output struct to get all those
indentation levels back.

> +	/* Todo: optimize. there must be better way of doing this*/
> +	list_for_each_entry(fs_devices, &fs_uuids, list) {

(same locking question)

> +				if (device->in_fs_metadata)
> +					dev->flags = dev->flags |
> +						BTRFS_DEV_IN_FS_MD;

	'a = a | b' -> 'a |= b'

> +				memcpy(dev->name, rcu_str_deref(device->name),
> +						BTRFS_PATH_NAME_MAX);

Hmm.  Don't we need to be in rcu_read_lock() to use rcu_str_deref()?

> +struct btrfs_ioctl_fsinfo {
> +	__u64 sz_self;
> +	__u8 fsid[BTRFS_FSID_SIZE]; /* out */
> +	__u64 num_devices;
> +	__u64 total_devices;
> +	__u64 missing_devices;
> +	__u64 total_rw_bytes;
> +	__u64 bytes_used;
> +	__u64 flags;
> +	__u64 default_mount_subvol_id;
> +	char label[BTRFS_LABEL_SIZE];
> +}__attribute__ ((__packed__));

It'd be __packed, but I'd naturally align the structs to u64s and not
use it.

> +struct btrfs_ioctl_fs_list {
> +	__u64 all; /* in */
> +	struct btrfs_ioctl_fsinfo fsinfo[BTRFS_FSIDS_LEN]; /* out */
> +}__attribute__ ((__packed__));

I'd turn this into something like:

struct btrfs_ioctl_get_fsinfo_input {
	__u64 flags;  /* bit for all */
	__u64 nr_fsinfo;
	__u64 fsinfo_ptr; /* u64 ptr to avoid compat */
};

> +struct btrfs_ioctl_devinfo {
> +	__u64 sz_self;
> +	__u64 flags;
> +	__u64 devid;
> +	__u64 total_bytes;
> +	__u64 disk_total_bytes;
> +	__u64 bytes_used;
> +	__u64 type;
> +	__u64 generation;
> +	__u32 io_align;
> +	__u32 io_width;
> +	__u32 sector_size;
 __u32 _padding;
> +	__u8 uuid[BTRFS_UUID_SIZE];
> +	__u8 name[BTRFS_PATH_NAME_MAX + 1];

Pad that nutty 4088 byte string to a multiple of u64s and you can
remove the packed attribute.

- z
