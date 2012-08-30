Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:27990 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2H3HXL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 03:23:11 -0400
Message-ID: <503F14D1.1080506@oracle.com>
Date: Thu, 30 Aug 2012 15:22:57 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz, chris.mason@fusionio.com
Subject: Re: [PATCH] Btrfs: Add get/set label ioctl
References: <1346229961-635-1-git-send-email-Anand.Jain@oracle.com> <503DDA25.1020407@oracle.com> <503EC7F0.2020305@oracle.com> <503EFDBA.8030707@oracle.com> <503F005E.1060908@oracle.com> <503F082A.4070603@oracle.com>
In-Reply-To: <503F082A.4070603@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/30/12 14:28, Anand Jain wrote:
>
>> The original patch could be revised with this support easily.
>> How about using one structure and one ioctl number for both of them?
>> i.e,
>>
>> #define BTRFS_IOC_FSLABEL_CTL    _IOW(BTRFS_IOCTL_MAGIC, 50, struct
>> btrfs_ioctl_fslabel_ctl_args)
>>
>> #define BTRFS_FSLABEL_CTL_GET    0
>> #define BTRFS_FSLABEL_CTL_SET    1
>>
>> struct btrfs_ioctl_fslabel_ctl_args {
>>          char label[BTRFS_LABEL_SIZE];
>>          u32  flags;
>> };
>>
>> so that get/set label from user tools would looks like,
>>
>> struct btrfs_ioctl_fslabel_ctl_args arg;
>> arg.flags = BTRFS_FSLABEL_CTL_GET;  /* get label */
>> or
>> arg.flags = BTRFS_FSLABEL_CTL_SET; /* set label */
>> ....
>>
>> ioctl(fd, BTRFS_FSLABEL_CTL,&arg);
>
>
>  I would prefer separating GET and SET label ioctl,
>  (to have one operation with an ioctl define) that
>  will be similar to rest of the ioctl in btrfs.
>  Further we don't need ioctl-arg-struct here, unless
>  if you are keeping the flags.
>
Thanks for the suggestions.

Yes, I noticed Btrfs perform add/rm devices, as well as set/set flags,
etc... all with two separated ioctls,
It's better to make the code style in a manner consistent with them.

However, get/set label is assigned one number in previous, the next
number(51) has been assigned to David,
51 - compressed file size - David Sterba

To make the code style in a consistent manner,
We can re-assign those numbers if Chris and David would happy to hear that.

>  And in my understanding in kernel memcpy are better
>  instead of strcpy.
If we do copy binary structure/elements, memcpy is nice.
However, consider we're copying a label in string, I think the
difference between them in kernel is
same to the user lib, which means that the copy is stops or not when it
encounters a NUL.

By contrast , I think strcpy is better here, if the label is specified
with a NUL('\0', why do that?) in the middle of it,
and we do memcpy for it in kernel,  but, the user will get surprised
when he/she fetch the label and printf(3) it out.

Thanks,
-Jeff
>  
>  If you could add GET that will be nicer.
>
>  I would need this for an experiment to add the label
>  for the subvol/snapshots.
>
> Thanks, Anand

