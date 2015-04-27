Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-afa67.mailout.artfiles.de ([212.72.176.67]:42559 "EHLO
	mailout-afa67.mailout.artfiles.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbbD0IB7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 04:01:59 -0400
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to get the devid of a missing device
Date: Mon, 27 Apr 2015 10:01:52 +0200
Message-ID: <2297316.VxuZ9hm5NH@discus>
In-Reply-To: <553DBF87.2080205@oracle.com>
References: <1704142.6uN5bYeLWo@discus> <553DBF87.2080205@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, April 27, 2015 12:48:07 PM Anand Jain wrote:
> On 04/27/2015 02:39 AM, Wolfgang Mader wrote:
> > Hello,
> > 
> > I have a raid10 with one device missing. I would like to use btrfs replace
> > to replace it. However, I am unsure on how to obtain the devid of the
> > missing device. Having the filesystem mounted in degraded mode under mnt,
> > btrfs fs
>   At the user end there is no way. unless you want to use gdb and dump
>   the fs_uuids and check.
> 
>   Submitted these patches as of now to obtain from the logs. Will
>   help in the situation when device is missing at the time of mount.
> 
> Btrfs: check error before reporting missing device and add uuid
> Btrfs: log when missing device is created
> 
>   For long term we have sysfs interface, patches are in the ML if you
>   want to tests.
> 
> Good luck.
> 
> Anand

Great. Thank you for patching this in.

Best,
Ẃolfgang

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

