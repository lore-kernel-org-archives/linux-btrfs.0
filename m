Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:51509 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3JVS0E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 14:26:04 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 207AB7C06A7
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 12:26:04 -0600 (MDT)
Date: Tue, 22 Oct 2013 14:26:02 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jeff Mahoney <jeffm@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [patch 00/13] sysfs publishing patchset
Message-ID: <20131022182602.GC27304@localhost.localdomain>
References: <20131021211940.432195222@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20131021211940.432195222@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 21, 2013 at 05:19:40PM -0400, Jeff Mahoney wrote:
> This patchset implements the stubbed-out sysfs interface for btrfs. Or
> at least begins to do so.
> 
> We publish:
> - Features supported by the file system implementation
> - Features enabled on the file system, including features unknown to
>   the implemenation. These attributes can also be used to enable or
>   disable features at runtime, subjecting to a safety mask.
> - Uses the attribute names to print feature names when declining to
>   mount a file system.
> - The allocation data: global metadata reservation size and reserved,
>   space_infos, and sums of the block groups total and used bytes.
> - Device membership via links to the block devices.
> - FS label, which is writeable.
> 
> - I've also added matching ioctls for some of the functionality here so
>   that btrfsprogs can use the information without jumping through hoops
>   to read/parse the sysfs files. There are ioctls to query the supported
>   features and to query/set features on a particular file system. There's
>   also one to export the size of the global metadata reservation. I have
>   a patch for btrfs-progs that uses this to print useful info in 'btrfs
>   fi df' output.
> 
> Ultimately, the tree structure looks like the following, under /sys/fs/btrfs.
> This is from a test file system, using two devices in raid1. You'll notice
> the 'single' and 'raid1' directories under the {data,metadata,system} dirs.
> The raid profiles are created and removed as the first/last block group
> of a certain profile is added and removed.
> 

I'm not pulling in patches that add new functionality without an accompanying
xfstest so that we're not merging features without a way to test to make sure
they are working properly, this applies to the global metadata reservation ioctl
as well.  Thanks,

Josef
