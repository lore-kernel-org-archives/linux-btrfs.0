Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45449 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932655AbcLGWwG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 17:52:06 -0500
Date: Wed, 7 Dec 2016 14:51:06 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, Jan Kara <jack@suse.cz>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 4/6] Btrfs: add DAX support for nocow btrfs
Message-ID: <20161207225106.GB29547@dhcp-whq-twvpn-2-vpnpool-10-159-183-5.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
 <1481147110-20048-5-git-send-email-bo.li.liu@oracle.com>
 <ad5694be-df94-f1ed-46ac-96ef19d8007d@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ad5694be-df94-f1ed-46ac-96ef19d8007d@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 07, 2016 at 05:15:42PM -0500, Chris Mason wrote:
> 
> 
> On 12/07/2016 04:45 PM, Liu Bo wrote:
> > This has implemented DAX support for btrfs with nocow and single-device.
> > 
> > DAX is developed for block devices that are memory-like in order to avoid
> > double buffer in both page cache and the storage, so DAX can performs reads and
> > writes directly to the storage device, and for those who prefer to using
> > filesystem, filesystem dax support can help to map the storage into userspace
> > for file-mapping.
> > 
> > Since I haven't figure out how to map multiple devices to userspace without
> > pagecache, this DAX support is only for single-device, and I don't think
> > DAX(Direct Access) can work with cow, this is limited to nocow case.  I made
> > this by setting nodatacow in dax mount option.
> 
> Interesting, this is a nice small start.  It might make more sense to limit
> snapshots to readonly in DAX mode until we can figure out how to cow
> properly.

Sounds good and easy to do.

>  I think it can be done, I just need to sit down with the dax code
> to do a good review.
> 
> But bigger picture, if we can't cow and we can't crc and we can't
> multi-device, I'd rather let XFS/ext4 sort out the dax space until we pull
> in more of the btrfs features too.

Well, I agree with that, initially I thought dax doesn't fit with
btrfs's expectation as it's mainly used to bypass kernel stuff and
offers a bridge between application and pmem devices, but one benefit I
forgot to mention in the commit log is that btrfs can do DUP metadata
which is mirroring, and it has a slightly bigger chance than ext4/xfs to
get metadata corruption fixed online.

Thanks,

-liubo
