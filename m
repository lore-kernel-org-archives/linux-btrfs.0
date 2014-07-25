Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbaGYSED (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 14:04:03 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6PI43S9001485
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 14:04:03 -0400
Message-ID: <53D29C11.1090800@redhat.com>
Date: Fri, 25 Jul 2014 13:04:01 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs.btrfs: round all device sizes to sectorsize
References: <53D1DCB4.8090409@redhat.com> <20140725171236.GJ17798@lenny.home.zabbo.net> <53D292FF.7030500@redhat.com>
In-Reply-To: <53D292FF.7030500@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/25/14, 12:25 PM, Eric Sandeen wrote:
> On 7/25/14, 12:12 PM, Zach Brown wrote:
>> On Thu, Jul 24, 2014 at 11:27:32PM -0500, Eric Sandeen wrote:
>>> make_btrfs() rounds down the first device size to a multiple of sectorsize:
>>
>>                ^^^^^^^^^^^
>>
>>> -	device->total_bytes = block_count;
>>> +	device->total_bytes = (block_count / sectorsize) * sectorsize;
>>
>> kerncompat.h:#define round_down(x, y) ((x) & ~__round_mask(x, y))
>>
>> - z
>>
> 
> yeah yeah ;) this isn't copied kernel code but sure, that'd be better.
> 
> I'm trying to clean up this whole "we say blocks when we mean bytes!"
> thing, and I'll include round_down() as well.

meh.  And half this is done in kernelspace for device add/replace
(device size setting etc) so TBH I'm increasingly inclined to
just back away slowly here.  :(

(IOWs device_add calls btrfs_prepare_device(), but the size
it finds is never used; the kernel does:

	device->total_bytes = i_size_read(bdev->bd_inode);

so changing prepare_device doesn't catch add/replace cases...)

Perhaps the simpler option is to remove the rounding which is
only done on the first device added in userspace, but I honestly
don't know what the design plan is, or what the ramifications of
that might be ...

-Eric

