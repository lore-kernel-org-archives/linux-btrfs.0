Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaIDJ6P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Sep 2014 05:58:15 -0400
Date: Thu, 4 Sep 2014 11:58:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, lists@colorremedies.com
Subject: Re: [PATCH v2] btrfs: ioctl BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO
 miss-matched with slots
Message-ID: <20140904095812.GA5636@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1408158488-4316-1-git-send-email-anand.jain@oracle.com>
 <1408351099-4721-1-git-send-email-anand.jain@oracle.com>
 <1408351099-4721-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1408351099-4721-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 18, 2014 at 04:38:18PM +0800, Anand Jain wrote:
> ioctl BTRFS_IOC_FS_INFO return num_devices which does _not_ include seed
> device, But the following ioctl BTRFS_IOC_DEV_INFO counts and gets seed
> disk when probed. So in the userland we hit a count-slot missmatch
> bug..
>             get_fs_info()
>             ::
>                     BUG_ON(ndevs >= fi_args->num_devices);
> which hits this bug when we have mounted a seed device.
> 
> So to fix this problem here in this patch ioctl BTRFS_IOC_FS_INFO
> will provide total_devices instead of num_devices.

The ioctl is very unclear what the 'num_device' actually means.

> This would fix the problem partly. Partly because ealier num_devices
> included the replacing device but now total_device does not include
> the replacing device. Getting a count which includes a transient device
> is rather too in efficient/wrong indeed, because there can be a race
> condition where in the time between ioctl BTRFS_IOC_FS_INFO to
> BTRFS_IOC_DEV_INFO the replace device operation might have been
> completed. So to fix this problem its better that user land btrfs-progs
> probes replacing device (at devid 0) separately.
> 
> v2:
> Agree with Wang's comment. Its better to show seed disks under the
> sprout fs, so that user can establish mapping of seed to sprout devices.
> 
> So here I am making BTRFS_IOC_FS_INFO to return the total_devices
> which would count the seed devices (but not the replacing device).

This is even more confusing. I think we need to add another member to
the ioctl struct to reflect the number of regular devices (num_devices)
and the true total number of devices including seeding and replaced
devices. The difference should be accompanied by a flag that would say
if there's a seeding or replace in progress.

There are some backward compatibility concerns. Setting num_devices to
total_devices changes semantics of the ioctl, so I think it should stay
as is for now, but the BUG_ON can be removed and replaced by code that
reallocates the buffer or allocates a few more items in advance.
