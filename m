Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073AbaFCOIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jun 2014 10:08:10 -0400
Date: Tue, 3 Jun 2014 16:08:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com, dsterba@suse.cz, clm@fb.com,
        hugo@carfax.org.uk
Subject: Re: [PATCH 6/6 RFC v2] btrfs: revamp /sys/fs/btrfs/<fsid>/devices
Message-ID: <20140603140807.GO22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
 <1401766564-7381-7-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401766564-7381-7-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 03, 2014 at 11:36:04AM +0800, Anand Jain wrote:
> From: Anand Jain <anand.jain@oracle.com>
> 
> As of now with out this patch the sysfs interface under dir
> /sys/fs/btrfs/<fsid>/devices is just link to the block devs.

At this point it's part of the sysfs ABI and should not be changed.

> Moving forward we would need the above btrfs sysfs path to contain more
> info about the btrfs devices. So this patch provides a framework for
> the same.

I'd prefer a separate directory for that, Hugo once sent a proposal for
that, /sys/fs/btrfs/devmap/... with enhanced information about the
devices

http://article.gmane.org/gmane.comp.file-systems.btrfs/32410

but was not a per-filesystem list of devices as your patch introduces. I
think we should consider something similar to the /dev/disk/... symlink
structure, both per-module and per-filesystem.

Example:

/sys/fs/btrfs/devmap/by-id/
  contains directories with integer numbers that represent devices

/sys/fs/btrfs/devmap/by-uuid/
  symlink to the corresponding by-id directory based on the device uuid

/sys/fs/btrfs/devmap/by-dev/
  dtto but by the the physical device name

I take the device id as the primary reference to the devices, the
physical block devices may differ, but the ids are stable.

The by-id/by-uuid/by-dev are there for users' convenience.

The /sys/fs/btrfs/<uuid>/ directory would contain subset of the devmap
and has symlinks to /sys/fs/btrfs/devmap directories.

This should present the general idea of the device-related directories,
naming or other tweaking is possible.

The existing directory 'devices' links to the physical devices (located
in sysfs), while the devmap represents the btrfs module POV, so this is
not duplicate.

> And as of now a probe interface is added, which can be used to notify
> btrfs for any change in the device status.

So, the probe  would be located in the 'by-id/n' directory.
