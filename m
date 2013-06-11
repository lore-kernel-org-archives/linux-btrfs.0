Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39793 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3FKNKN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 09:10:13 -0400
Message-ID: <51B721B4.8030202@oracle.com>
Date: Tue, 11 Jun 2013 21:10:12 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] btrfs: add framework to read fs info and dev info
 from the kernel
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com> <1370876355-16584-1-git-send-email-anand.jain@oracle.com> <1370876355-16584-3-git-send-email-anand.jain@oracle.com> <20130610194030.GB10307@localhost.localdomain>
In-Reply-To: <20130610194030.GB10307@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/11/2013 03:40 AM, Josef Bacik wrote:
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
>
> Please submit an xfstest along with this to test the new functionality so we
> have something to test it with.  Make sure it runs properly if your patches are
> not in place since they obviously won't be for most people.  Once you have an
> xfstest I can properly test these patches.  Thanks,

  This kernel patch supports a new cli option --kernel
  under the existing command 'btrfs filesystem show'.
  xfstest first of all would need testcase to test the
  btrfs filesystem show which isn't there yet. Doing it
  here deviate too much from the point here. But let
  me try to quick get that.

Thanks, Anand
