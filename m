Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50277 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdJFXh6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 19:37:58 -0400
Date: Fri, 6 Oct 2017 16:33:58 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v8 2/2] btrfs: check device for critical errors and mark
 failed
Message-ID: <20171006233357.GB19068@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20171003155920.24925-1-anand.jain@oracle.com>
 <20171003155920.24925-3-anand.jain@oracle.com>
 <20171004201154.GB4902@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <bd328a02-8823-a3a4-35ff-a9b890f00679@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bd328a02-8823-a3a4-35ff-a9b890f00679@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 05, 2017 at 07:07:44AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-10-04 16:11, Liu Bo wrote:
> > On Tue, Oct 03, 2017 at 11:59:20PM +0800, Anand Jain wrote:
> > > From: Anand Jain <Anand.Jain@oracle.com>
> > > 
> > > Write and flush errors are critical errors, upon which the device fd
> > > must be closed and marked as failed.
> > > 
> > 
> > Can we defer the job of closing device to umount?
> > 
> > We can go mark the device failed and skip it while doing read/write,
> > and umount can do the cleanup work.
> > 
> > That way we don't need a dedicated thread looping around to detect a
> > rare situation.
> If BTRFS doesn't close the device, then it's 100% guaranteed if it
> reconnects that it will show up under a different device node.  It would
> also mean that the device node stays visible when there is in fact no device
> connected to it, which is a pain from a monitoring perspective.

I see, you're assuming that these errors are due to disconnection of
disks, it could be bad sectors (although almost impossible from
enterprise hard disks) or some other errors across the stack.

I do agree that cleanup needs to be done if disk got disconnected, but
not doing cleanup here, a udev rule is needed to handle such an event.


thanks,
-liubo
