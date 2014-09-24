Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45055 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIXGdf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Sep 2014 02:33:35 -0400
Message-ID: <542265A9.6020903@oracle.com>
Date: Wed, 24 Sep 2014 14:33:13 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH] btrfs-progs: canonicalize pathnames for device commands
References: <538F84DF.3090300@suse.com> <5413F2D0.3020006@oracle.com> <54161AFD.3070604@suse.com> <5417299F.6040504@oracle.com>
In-Reply-To: <5417299F.6040504@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>> Nice patch. However its better if we do this in the btrfs kernel
>>> function btrfs_scan_one_device(). Since the non-canonicalize path
>>> can still sneak through the btrfs specific mount option "device=".
>>>
>>> Any comments ?
>>
>> My initial reaction is to avoid playing naming names within the
>> kernel. But since it's device mapper-specific, it might not be too
>> messy to do that. In addition to the patch to the progs, we're also
>> carrying a patch to systemd since it has it's own little ioctl wrapper
>> to do the scanning. It needed to be fixed there as well.
>
>   looks like we need to fix systemd as well. As I check systemd is using
>   READY ioctl.


systemd is using device ready ioctl's bug as a feature (if the
comment in systemd is true, as below).

./systemd/rules/64-btrfs.rules
----
# let the kernel know about this btrfs filesystem, and check if it is 
complete
IMPORT{builtin}="btrfs ready $devnode"
----

btrfs dev ready is only to check if the device is ready,
not to let the kernel know about it. the bug part in the
ioctl is it would update the device path, even when the
device is mounted.

Either we need transition the bug as a feature OR fix the bug.

-Anand


