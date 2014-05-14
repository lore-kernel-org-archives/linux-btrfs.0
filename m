Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46963 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751468AbaENMtn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 08:49:43 -0400
Message-ID: <537366D2.3080808@fb.com>
Date: Wed, 14 May 2014 08:51:30 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>, Arvin Schnell <aschnell@suse.de>
Subject: Re: [PATCH] btrfs: extend BTRFS_IOC_SNAP_CREATE_V2 to snapshot by
 subvolid
References: <5330C6A8.5050206@suse.com>
In-Reply-To: <5330C6A8.5050206@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/24/2014 07:58 PM, Jeff Mahoney wrote:
> The BTRFS_IOC_SNAP_CREATE_V2 ioctl is limited by requiring that a file
> descriptor be passed in order to create the snapshot. This means that
> snapshots may only be created of trees that are available in the mounted
> namespace. We have a need to create snapshots from subvolumes outside
> of the namespace. This is already possible by mounting the numbered
> subvolume by ID on a separate mount point, creating the snapshot, and
> unmounting it. That's a tedious and unnecessary process since the ioctl
> can be extended so easily.
> 
> This patch adds a new BTRFS_SUBVOL_CREATE_SUBVOLID flag that instructs
> the ioctl to use the fd argument (which is now a union) as a subvolume
> id instead. The subvolume ID is used to look up the root and instantiate
> the inode so proper permission checking takes place.

Can you please make this root only?  The file handle makes sure the
admin hasn't intentionally hidden the subvol from the user, and this
bypasses those permission checks.

-chris
