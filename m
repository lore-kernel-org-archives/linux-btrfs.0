Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51287 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab3FYC41 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 22:56:27 -0400
Message-ID: <51C907DA.2010902@oracle.com>
Date: Tue, 25 Jun 2013 11:00:42 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] btrfs: obtain used_bytes in BTRFS_IOC_FS_INFO
 ioctl
References: <1370876355-16584-3-git-send-email-anand.jain@oracle.com> <1371799948-14176-1-git-send-email-anand.jain@oracle.com> <20130624170316.GL4288@localhost.localdomain>
In-Reply-To: <20130624170316.GL4288@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/25/2013 01:03 AM, Josef Bacik wrote:
> On Fri, Jun 21, 2013 at 03:32:28PM +0800, Anand Jain wrote:
>> btrfs-progs has to read fs info from the kernel to
>> read the latest info instead of reading it from the disks,
>> which generally is a stale info after certain critical
>> operation.
>>
>> getting used_bytes parameter will help to fix
>> 	btrfs filesystem show --kernel
>> to show the current info of the fs
>>
>> v2->v3:
>> 	everything is changed dropped the plan to introduce
>> 	the new ioctl, as of now filesystem show could
>> 	manage if we add the used_bytes parameter to the
>> 	BTRFS_IOC_FS_INFO and
>> 	Update the title from
>> 	 add framework to read fs info and dev info from the kernel
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/ioctl.c           | 16 ++++++++++++++--
>>   include/uapi/linux/btrfs.h |  3 ++-
>>   2 files changed, 16 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 0e7bcc5..082c9fc 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2384,7 +2384,10 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
>>   	struct btrfs_ioctl_fs_info_args *fi_args;
>>   	struct btrfs_device *device;
>>   	struct btrfs_device *next;
>> -	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
>> +	struct btrfs_fs_info *info = root->fs_info;
>> +	struct btrfs_fs_devices *fs_devices = info->fs_devices;
>> +	struct btrfs_space_info *si;
>> +	u64 used_bytes = 0;
>>   	int ret = 0;
>>
>>   	if (!capable(CAP_SYS_ADMIN))
>> @@ -2394,8 +2397,17 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
>>   	if (!fi_args)
>>   		return -ENOMEM;
>>
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(si, &info->space_info, list) {
>> +		used_bytes += si->bytes_used + si->bytes_reserved
>> +				+ si->bytes_pinned + si->bytes_readonly
>> +				+ si->bytes_may_use;
>> +	}
>> +	rcu_read_unlock();
>> +	fi_args->used_bytes = used_bytes;
>> +
>
> So what exactly are we using this number for?  ->bytes_may_used is going to
> change all the damned time because of reservations and it could even make
> used_bytes to appear to be larger than total_bytes because of overcommitting.
 > So why exactly do you want this value?

  used for and to be consistent with what btrfs fi show does as of now,
  it shows the number of bytes used in the FS.

  just figured out that I could also use BTRFS_IOC_SPACE_INFO
  and do that math outside kernel. So pls. drop this kernel patch.
  I will be sending out a new progs patch which doesn't need kernel
  ioctl changes.

> Also how are you going to deal with
> older kernels where this isn't populated?  Thanks,

  Since the ioctl arg size didn't change here (as I was using the
  reserved space) it will just show 0.0 when old kernel is used.
  Not a best way (as it lets user to wonder) but a good trade-off
  to make the fix as simple as possible.

Thanks, Anand
