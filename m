Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38750 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbaFCA14 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 20:27:56 -0400
Message-ID: <538D1676.9050202@oracle.com>
Date: Tue, 03 Jun 2014 08:27:34 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jeffm@suse.com, clm@fb.com
Subject: Re: [PATCH 4/4] btrfs: create sprout should rename fsid on the sysfs
 as well
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com> <1401096626-13210-5-git-send-email-anand.jain@oracle.com> <20140529125422.GB29992@twin.jikos.cz> <538C343C.20308@oracle.com> <20140602153944.GB22324@twin.jikos.cz>
In-Reply-To: <20140602153944.GB22324@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/06/2014 23:39, David Sterba wrote:
> On Mon, Jun 02, 2014 at 04:22:20PM +0800, Anand Jain wrote:
>>>> --- a/fs/btrfs/volumes.c
>>>> +++ b/fs/btrfs/volumes.c
>>>> @@ -2084,6 +2084,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>>>>   	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
>>>>
>>>>   	if (seeding_dev) {
>>>> +		char fsid_buf[37];
>>>
>>> Is there a symbolic constant available? We have one in userspace, but I
>>> can't find one for kernel, only a few locally defined.
>>
>>   now defined the same (as in progs) in kernel as well.
>
> In progs it's in utils.h
>
>   40 #define BTRFS_UUID_UNPARSED_SIZE        37
>
> but I don't see where it's defined in kernel. Can you please give me a
> pointer?
>
> On the other hand, progs have a local define, we can do the same, I
> don't see any other potential users.

  David,
  What I have as of now (in my workspace) is a local define in volume.h.

  but in the 2nd thought I am thinking if it is better to be at

./include/uapi/linux/btrfs.h
::
#define BTRFS_FSID_SIZE 16
#define BTRFS_UUID_SIZE 16
#define BTRFS_UUID_UNPARSED_SIZE 37 <--

  Eventually in the long run, when we clean up btrfs-progs it could
  just include ./include/uapi/linux/btrfs.h

  Also there is this driver, who has defined it but its local

#define MAXUUIDLEN  37
./drivers/staging/tidspbridge/include/dspbridge/uuidutil.h

  How do you like the idea of define at include/uapi/linux/btrfs.h
  let me know.

Thxs, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
