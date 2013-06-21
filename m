Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21491 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638Ab3FUG62 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 02:58:28 -0400
Message-ID: <51C3FA8B.4070607@oracle.com>
Date: Fri, 21 Jun 2013 15:02:35 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] btrfs: add framework to read fs info and dev info
 from the kernel
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com> <1370876355-16584-1-git-send-email-anand.jain@oracle.com> <1370876355-16584-3-git-send-email-anand.jain@oracle.com> <20130611142420.GB658@localhost.localdomain>
In-Reply-To: <20130611142420.GB658@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  TREE_SEARCH ioctl doesn't help in this case
  the dev item don't provide all the info
  that btrfs-progs might need in the long run
  (and even the current needs).

Thanks, Anand

On 06/11/2013 10:24 PM, Josef Bacik wrote:
> On Mon, Jun 10, 2013 at 08:59:15AM -0600, Anand Jain wrote:
>> This adds two ioctl BTRFS_IOC_GET_FSIDS and BTRFS_IOC_GET_DEVS
>> which reads the btrfs_fs_devices and btrfs_device structure
>> from the kernel respectively.
>>
>> The information in these structure are useful to report the
>> device/fs information in line with the kernel operations and
>> thus immediately addresses the problem that 'btrfs fi show'
>> command reports the stale information after device device add
>> remove operation is performed. That is because btrfs fi show
>> reads the disks directly.
>>
>> Further the frame-work provided here would help to enhance
>> the btrfs-progs/library to read the other fs information and
>> its device information. Also the frame work provided here is
>> easily extensible to retrieve any other structure as future
>> needs.
>>
>> v1->v2:
>>    .code optimized
>>    .get the device generation number as well, so that
>>     btrfs-progs could print using print_one_uuid
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>
> In fact NACK altogether on this patch, you can get the same info out with the
> TREE_SEARCH ioctl, just do that in btrfs-progs and don't add yet another ioctl.
> Thanks,
>
> Josef
