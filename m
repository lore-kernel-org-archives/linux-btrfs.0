Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19454 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaJAHgD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Oct 2014 03:36:03 -0400
Message-ID: <542BB011.4000302@oracle.com>
Date: Wed, 01 Oct 2014 15:41:05 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: introduce procfs interface for the device
 list
References: <1411967340-23802-1-git-send-email-anand.jain@oracle.com> <1412087020.14485.0@mail.thefacebook.com>
In-Reply-To: <1412087020.14485.0@mail.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Chris,

  Thanks for commenting. Some clarifying comments as below.


On 30/09/2014 22:23, Chris Mason wrote:
>
>
> On Mon, Sep 29, 2014 at 1:09 AM, Anand Jain <anand.jain@oracle.com> wrote:
>> From: Anand Jain <Anand.Jain@oracle.com>
>>
>> (added RFC prefix to the patch header)
>> (as of now just an experimental interface)
>>
>> This patch introduces profs interface /proc/fs/btrfs/devlist,
>> which as of now exports all the members of kernel fs_devices.
>>
>> The current /sys/fs/btrfs interface works when the fs is
>> mounted, and is on the file directory hierarchy and also has
>> the sysfs limitation max output of U64 per file.
>>
>> Here btrfs procfs uses seq_file to export all the members of
>> fs_devices. Also shows the contents when device is not mounted,
>> but have registered with btrfs kernel (useful as an alternative
>> to buggy ready ioctl)
>>
>> An attempt is made to follow the some standard file format
>> output such as ini. So that a simple warper python script will
>> provide end user useful interfaces.
>>
>> Further planning to add few more members to the interface such as
>> group profile info. The long term idea is to make procfs
>> interface a onestop btrfs application interface for the device and
>> fs info from the kernel, where a simple python script can make
>> use of it.
>
> Hi Anand,
>
> We're going to have a really hard time getting a new proc interface
> merged in, and after we've recently fixed up all (most?) of our sysfs
> races, I'd rather not have to do it all over again with /proc.

  This does not use fsid/devid based file-directory. So races as were
  in sysfs implementation does not apply here. (But there are opportunity
  to optimize the code at the place mentioned in the code as todo).

> I know
> the lack of a seq interface is a difficult compromise to make in sysfs,
> but at this point I think we're stuck with it.  Which specific part do
> you hope to improve by dumping more information out in a single file?

  Since its a single file and dumping most of the members of fs_devices
  we would ensure the interface will remain unchanged for a long time
  and helps debugging. This is hard to do when we layout files per
  parameter value.

  Less clutter. But needs python script abstraction to provide what
  user want. Better than using ioctls.

  file-parameter-layout might introduce races. So here there is no file
  parameter layout, its just one file /proc/fs/btrfs/devlist, provides
  an interface which is compatible with parser such as python
  configparser, with which application can organize it using a simple
  script.


Further,
  This also exports all registered devices which may not be mounted.
  (sysfs implementation does not).

  we need alternative to btrfs-progs check_mounted(). check_mounted() is
  too heavy as it has to scans all devices when num_devices > 1. This
  interface can help to light weight check_mounted().

  This provides alternative to following ioctl and thus will remove
  its bugs mentioned below.
     BTRFS_IOC_DEVICES_READY
     This ioctl should have been readonly but it can update device path.

     BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO conflict on the slots
     when seed disk is used.

  Could provide RAID volume status information mainly for enterprise
  users.

Thanks, Anand



> -chris
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
