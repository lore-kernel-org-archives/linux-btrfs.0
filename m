Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:47253 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaBFUKI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 15:10:08 -0500
Message-ID: <52F3EC15.1000508@libero.it>
Date: Thu, 06 Feb 2014 21:09:57 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: introduce BTRFS_IOC_GET_DEVS
References: <1390812770-11720-1-git-send-email-anand.jain@oracle.com> <1390812770-11720-2-git-send-email-anand.jain@oracle.com> <20140127084709.GK3314@carfax.org.uk> <20140206194935.GT1364@twin.jikos.cz>
In-Reply-To: <20140206194935.GT1364@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/06/2014 08:49 PM, David Sterba wrote:
> On Mon, Jan 27, 2014 at 08:47:09AM +0000, Hugo Mills wrote:
>> On Mon, Jan 27, 2014 at 04:52:50PM +0800, Anand Jain wrote:
>>> The user land progs needs   a simple way to read
>>> the raw list of disks and its parameters as
>>> btrfs kernel understands it. This patch will
>>> introduce BTRFS_IOC_GET_DEVS which dumps
>>> every thing under fs_devices.
>>>
>>> As of now btrfs-devlist uses this ioctl.
>>>
>>> In the long run this ioctl would help to optimize
>>> some part of btrfs-progs, mainly the current
>>> btrfs filesystem show
>>
>>    Just thinking out loud here, really, but can we export this
>> information in /sys instead, rather than adding yet more ioctls?
> 
> I tend to agree that this belongs to sysfs, it's more flexible in case
> we'll add more per-device stats, ie. one file that holds all the stats
> about the device. This is also easier to use from scripts that gather
> system information.
> 
> With 3.14 the sysfs interface is available, but the devices under
>  /sys/fs/btrfs/<fs-uuid>/devices/...
> are symlinks to the sysfs devices, so this btrfs-specific device
> information has to be located in a separate directory.

yes please; it would scale better than the ioctl()s; anyway I suggest 1
file per property, and not "...one file that holds all the stats
 about the device"

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
