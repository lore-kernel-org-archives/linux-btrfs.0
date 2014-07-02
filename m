Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3502 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752163AbaGBCgl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 22:36:41 -0400
Message-ID: <53B370A7.6050108@cn.fujitsu.com>
Date: Wed, 2 Jul 2014 10:38:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: fix null pointer dereference in clone_fs_devices
 when name is null
References: <1404119568-4097-1-git-send-email-Anand.Jain@oracle.com> <53B135B2.5060405@cn.fujitsu.com> <53B17D0E.2050302@oracle.com>
In-Reply-To: <53B17D0E.2050302@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 30 Jun 2014 23:06:54 +0800, Anand Jain wrote:
> 
>> The primary reason of this problem is that we didn't scan the system and
>> find all the devices in the filesystem, if we scan the system, we can
>> mount the filesystem successfully, needn't mount it with degraded option.
>> so I think the right way to fix is to scan the system and find the device
>> that is not registered into the fs device list.
> 
> Thanks for commenting. Right. But I am testing the error
> scenario. that is, when one of the disk is missing in the system.

In fact, the disk is still in the system, but is not added into btrfs device list
(we can add it by "btrfs device scan" command), and after you mount the fs with
degraded option, the fs adds that disk as a missing device, so it doesn't has its
name.

Though avoiding access a null pointer is right, you didn't consider the missing
device and forgot to set the missing device counter. I think the following code
is better.

if (orig_dev->missing) {
	device->missing = 1;
	fs_devices->missing_devices++;
} else {
	ASSERT(orig_dev->name);
	......
}

Thanks
Miao
