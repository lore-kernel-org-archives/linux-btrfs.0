Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58350 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756246AbaDIDZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 23:25:53 -0400
Message-ID: <5344BDFF.70101@cn.fujitsu.com>
Date: Wed, 9 Apr 2014 11:26:55 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: Add missing devices check for mounted
 btrfs.
References: <1391755560-4721-1-git-send-email-quwenruo@cn.fujitsu.com> <52F4A8B6.5070009@oracle.com> <52F81EF6.4080901@cn.fujitsu.com> <5344B8A8.1080507@oracle.com>
In-Reply-To: <5344B8A8.1080507@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, the deleted device scan is still one of the deep problems yet.

But my patch is not intented to deal anything related to the problem.

For me, I am *only* going to deal with the *exit code* problem,
'btrfs fi show <device>' executes correctly(OK, only part of it exactlly),
but exit code is still 1, which is the bug I'm trying to fix it.

IMO, the users/admins may never be interested in the inside mechanism 
nor algorithm,
but the output and exit value things.

This bug is much like the previous 'btrfs fi show' bugs that breaks some 
xfstests test case
(always showing a error due to the scan_kernel_v2 function which calls a 
unimplemented ioctl interface),
if some patch breaks the old exit code or output, then it should be 
fixed to maintain the old
output/exit code (except some big decision is made to change it).

So for the output/exit code consistence, it should be fixed even the 
patch may not  means a cure but
only a workaround for you.

Thanks,
Qu.

于 2014年04月09日 11:04, Anand Jain 写道:
>
>
>  Below shows the bug cascading to this patch.
>
>  And now to fix this I think we shouldn't fix/workaround in the
>  btrfs-progs again!, fix it in the btrfs-kernel (or leave it open
>  until suitable fix is found, I tried and failed. but don't fix it
>  in a wrong way). If you want to help to fix this problem: Find out
>  if we could get kobject notification with in kernel when disks gets
>  disappeared.
>
>  I have been advocating btrfs-progs should _not_ add its intelligence
>  and it should be as transparent as possible in showing the kernel's
>  status. This should be seriously considered.
>
> (-----------
>  For patches to take this approach the core problem here is different
>  and hope we could correct it..
>  First, we have a superficial and wrong measuring tape (xfstest) and
>  we are trying to fix the product using it And in between is btrfs-progs
>  which is trying to add more superficial-ness.
>  2nd, btrfs Wiki has a theory and thus sets the direction that
>  btrfs-progs would copy code from btrfs-kernel, I seriously doubt
>  if that's a good idea.
>  If you want to make btrfs-progs as intelligent as btrfs-kernel
>  (which I don't understand why you should ?  since the purpose of
>  btrfs-progs and btrfs-kernel are different) then first you need
>  develop a mini synchronization mechanism between btrfs-progs and btrfs
>  kernel which is as good as two active nodes FS which says from my
>  experience with Solaris/SAM-QFS. Developing a synchronization
>  mechanism is not in the plan here. Further from the End user
>  Application (DB) performance perspective calling sync at the need of
>  something like btrfs-progs is a very very bad idea. Applications would
>  experience jitters in their steady state performance. Once Solaris had
>  this issue and we fixed it.
> -----------)
>
>  Have fun. ;-)
>
> ----------------------------------------------------------------
> $ btrfs dev scan
> Scanning for Btrfs filesystems
> $ mount /dev/sdc /btrfs
> $ btrfs fi show
> Label: none  uuid: dfbf136d-e8d2-489b-8ee1-be0d5999769d
>     Total devices 2 FS bytes used 663.81MiB
>     devid    1 size 1.10GiB used 1.10GiB path /dev/sdf
>     devid    2 size 1.10GiB used 1.08GiB path /dev/sdc
>
> $ devmgt show
> host0 sda
> host1 sdf
> host2 sdc
> host3 sdd
> host4 sde
> $ devmgt detach /dev/sdf
> -----/dev/kmsg----
>     sd 1:0:0:0: [sdf] Stopping disk
>      SUBSYSTEM=scsi
>      DEVICE=+scsi:1:0:0:0
>     ata2.00: disabled
> ------------------
> detach /dev/sdf successful
>
> (as a known bug btrfs kernel does not know device is missing, missing 
> flag isn't set, as shown below)
>
> $ btrfs-devlist
> fsid name uuid (seed_fsid sprout_fsid)
>     (fs_latest_devid fs_num_devices fs_open_devices fs_rw_devices 
> fs_missing_devices fs_total_devices) fs_total_rw_bytes 
> fs_num_can_discard fs_latest_trans
>     devid gen total_bytes disk_total_bytes bytes_used type io_align 
> io_width sector_size fmode
>     fs_flags
>     dev_flags
>
> dfbf136d-e8d2-489b-8ee1-be0d5999769d /dev/sdf 
> 13715cc5-3aeb-4523-b02c-a072fd427a00 (null null)
>     (2 2 2 2 0 2) 2363490304 0 7
>     1 5 1181745152 1181745152 1181745152 0 4096 4096 4096 0x83
>     fs_Mounted|not_fs_Seeding|fs_Rotating
>     Writable|MD|not_Missing|not_Discard|not_Replace_tgt|not_Run_pending|not_Nobarriers|Stat_valid|Stat_dirty|Bdev 
>
>
> dfbf136d-e8d2-489b-8ee1-be0d5999769d /dev/sdc 
> 12ad34f7-8d58-44fa-95cf-b2bbc0cec69d (null null)
>     (2 2 2 2 0 2) 2363490304 0 7
>     2 7 1181745152 1181745152 1160773632 0 4096 4096 4096 0x83
>     fs_Mounted|not_fs_Seeding|fs_Rotating
>     Writable|MD|not_Missing|not_Discard|not_Replace_tgt|not_Run_pending|not_Nobarriers|Stat_valid|Stat_dirty|Bdev 
>
>
>
> (below btrfs-progs patch added intelligence to tell the world that 
> device is missing)
>
> Ref:
> ~~~~~~~
> commit 2ae6a037efd52ae0fa30052d456ad07f074f5d54
> Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date:   Fri Feb 7 15:07:19 2014 +0800
>
>     btrfs-progs: Add missing devices check for mounted btrfs.
> ~~~~~~~
>
> $ btrfs fi show
> Label: none  uuid: dfbf136d-e8d2-489b-8ee1-be0d5999769d
>     Total devices 2 FS bytes used 663.81MiB
>     devid    2 size 1.10GiB used 1.08GiB path /dev/sdc
>     *** Some devices missing
>
> $ btrfs dev add /dev/sde /btrfs
> $ btrfs fi show
> Label: none  uuid: dfbf136d-e8d2-489b-8ee1-be0d5999769d
>     Total devices 3 FS bytes used 663.81MiB
>     devid    2 size 1.10GiB used 1.08GiB path /dev/sdc
>     devid    3 size 1.04GiB used 0.00 path /dev/sde
>     *** Some devices missing
>
>
> Now the bug is delete missing fails. Since kernel don't
> understand whats missing.
>
> $ btrfs dev del missing /btrfs
> ERROR: error removing the device 'missing' - no missing devices found 
> to remove
> $
> --------------------------------------------------------------------------- 
>
>
>
>
>
>
> On 02/10/2014 08:36 AM, Qu Wenruo wrote:
>> On Fri, 07 Feb 2014 17:34:46 +0800, Anand Jain wrote:
>>>
>>>
>>>  IMO btrfs-progs shouldn't add its intelligence to know if disk
>>>  is missing. If btrfs-kernel doesn't know when disk is missing
>>>  that's a bug to fix in btrfs-kernel. yes that indeed true as
>>>  of now in btrfs-kernel. btrfs kernel has no idea when disk
>>>  goes missing, just -EIO doesn't tell btrfs that. I am trying
>>>  to fix this first.
>>>
>>>  But the problem is there isn't good way with in btrfs/FS
>>>  to know when disk goes missing. did I miss anything ?
>> Yes, kernel detection is the best way.
>> But since it has no better way to detect missing device, I think the
>> btrfs-progs way fix is good enough for now.
>>
>> Since btrfs fi show with "-d" options will scan the /dev to find fs and
>> check missing disks,
>> I think adds some user-land check even using the ioctl way is still
>> somewhat reasonable.
>>
>> Thanks
>> Qu
>>>
>>>
>>> Thanks, Anand
>>>
>>>
>>> On 02/07/2014 02:45 PM, Qu Wenruo wrote:
>>>> In btrfs/003 of xfstest, it will check whether btrfs fi show can find
>>>> missing devices.
>>>>
>>>> But before the patch, btrfs-progs will not check whether device 
>>>> missing
>>>> if given a mounted btrfs mountpoint/block device.
>>>> This patch fixes the bug and will pass btrfs/003.
>>>>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> Cc: Anand Jain <anand.jain@oracle.com>
>>>> ---
>>>>   cmds-filesystem.c | 12 ++++++++++++
>>>>   1 file changed, 12 insertions(+)
>>>>
>>>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>>>> index 384d1b9..4c9933d 100644
>>>> --- a/cmds-filesystem.c
>>>> +++ b/cmds-filesystem.c
>>>> @@ -363,6 +363,8 @@ static int print_one_fs(struct
>>>> btrfs_ioctl_fs_info_args *fs_info,
>>>>           char *label, char *path)
>>>>   {
>>>>       int i;
>>>> +    int fd;
>>>> +    int missing;
>>>>       char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
>>>>       struct btrfs_ioctl_dev_info_args *tmp_dev_info;
>>>>       int ret;
>>>> @@ -385,6 +387,14 @@ static int print_one_fs(struct
>>>> btrfs_ioctl_fs_info_args *fs_info,
>>>>
>>>>       for (i = 0; i < fs_info->num_devices; i++) {
>>>>           tmp_dev_info = (struct btrfs_ioctl_dev_info_args
>>>> *)&dev_info[i];
>>>> +
>>>> +        /* Add check for missing devices even mounted */
>>>> +        fd = open((char *)tmp_dev_info->path, O_RDONLY);
>>>> +        if (fd < 0) {
>>>> +            missing = 1;
>>>> +            continue;
>>>> +        }
>>>> +        close(fd);
>>>>           printf("\tdevid %4llu size %s used %s path %s\n",
>>>>               tmp_dev_info->devid,
>>>>               pretty_size(tmp_dev_info->total_bytes),
>>>> @@ -392,6 +402,8 @@ static int print_one_fs(struct
>>>> btrfs_ioctl_fs_info_args *fs_info,
>>>>               tmp_dev_info->path);
>>>>       }
>>>>
>>>> +    if (missing)
>>>> +        printf("\t*** Some devices missing\n");
>>>>       printf("\n");
>>>>       return 0;
>>>>   }
>>>>
>>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

