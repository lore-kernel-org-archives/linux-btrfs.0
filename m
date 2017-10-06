Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18613 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751869AbdJGAAt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 20:00:49 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9700mc8006951
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 7 Oct 2017 00:00:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9700mk3010162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 7 Oct 2017 00:00:48 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9700hX7002609
        for <linux-btrfs@vger.kernel.org>; Sat, 7 Oct 2017 00:00:43 GMT
Date: Fri, 6 Oct 2017 16:56:45 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v8 2/2] btrfs: check device for critical errors and mark
 failed
Message-ID: <20171006235645.GC19068@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20171003155920.24925-1-anand.jain@oracle.com>
 <20171003155920.24925-3-anand.jain@oracle.com>
 <20171004201154.GB4902@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <881db992-2240-ce30-4d05-d0bd1faa2aa4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <881db992-2240-ce30-4d05-d0bd1faa2aa4@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 05, 2017 at 09:56:59PM +0800, Anand Jain wrote:
> 
> 
> On 10/05/2017 04:11 AM, Liu Bo wrote:
> > On Tue, Oct 03, 2017 at 11:59:20PM +0800, Anand Jain wrote:
> > > From: Anand Jain <Anand.Jain@oracle.com>
> > > 
> > > Write and flush errors are critical errors, upon which the device fd
> > > must be closed and marked as failed.
> > > 
> > 
> > Can we defer the job of closing device to umount?
> 
>  Originally I think it was designed to handle the bad disk
>  same as missing device. as below [1]. This patch just does that.
>  But I am curious to know if there is any issue to close failed
>  device ?
> 
> [1]
> -----
> static int read_one_dev(struct btrfs_fs_info *fs_info,
>                         struct extent_buffer *leaf,
>                         struct btrfs_dev_item *dev_item)
> ::
>             /*
>              * this happens when a device that was properly setup
>              * in the device info lists suddenly goes bad.
>              * device->bdev is NULL, and so we have to set
>              * device->missing to one here
>              */
> ------
> 
>  So here I misuse the device missing scenario (device->bdev = NULL)
>  to the failed device scenario. (code comment mentioned it).
>

This is OK to me, we can unify these stuff later, for now, ->missing
is to bypass this failed disk for r/w.

>  Secondly as in the patch 1/2 commit log and also Austin mentioned it,
>  if failed device close is deferred it will also defer the cleanup of
>  the failed device at the block layer.
> 
>  But yes block layer can still clean up when btrfs closes the
>  device at the time of replace, also where in the long run, pulling
>  out of the failed disk would (planned) trigger a udev notification
>  into the btrfs sysfs interface and it can close the device.
> 
>  Anything that I have missed ?
>

I'm more inclined to do cleanup by making udev call 'device remove',
which is supposed to do all the validation checks you need to done
here.

>  Further, jfyi closing of failed device isn't related to the
>  looping for device failure though.
> 
> > We can go mark the device failed and skip it while doing read/write,
> > and umount can do the cleanup work.
> 
>  In servers a need of umount is considered as downtime, things
>  shouldn't wait for umount to cleanup.
>

OK.

> > That way we don't need a dedicated thread looping around to detect a
> > rare situation.
> 
>  I think its better to make it event based instead of thread looping,
>  pls take a look..
> 
>    [PATCH v8.1 2/2] btrfs: mark device failed for write and flush errors
> 

Event based is good, for anything about failing disk, we would have to
follow what md is doing eventually, i.e. let udev handle it.

thanks,
-liubo
