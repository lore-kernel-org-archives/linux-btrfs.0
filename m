Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28243 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDDCdH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Apr 2014 22:33:07 -0400
Message-ID: <533E19CB.80205@oracle.com>
Date: Fri, 04 Apr 2014 10:32:43 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Lists <lists@benjamindsmith.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Hard restart required
References: <533DFC46.8020704@benjamindsmith.com>
In-Reply-To: <533DFC46.8020704@benjamindsmith.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2014 08:26, Lists wrote:
> Trying out BTRFS today for the first time after a few false starts with
> three drives configured raid1. I'm using Oracle Linux 6/64 with all
> updates applied on unremarkable hardware. (cast off Dell Core2 desktop,
> 2 GB RAM, no known problems) Here's what it looks like:
>
> [root@oracle ~]# btrfs filesystem show
> Label: none  uuid: bdaf3d87-f992-4a89-9e2b-41de0b5ff909
>      Total devices 3 FS bytes used 448.82MB
>      devid    2 size 1.36TB used 167.01GB path /dev/sdc
>      devid    3 size 1.82TB used 167.01GB path /dev/sdd
>      devid    1 size 931.51GB used 2.02GB path /dev/sdb
>
> It hard locked and required a power-off system restart. Is this
> atypical? Here's what did it, this should be OK?
>
> # mount -U bdaf3d87-f992-4a89-9e2b-41de0b5ff909 /media/btrfs;

  Does messages around the time of the problem say anything ?

Thanks, Anand


> UUID should work, right? Why else have a UUID if not? Currently, I'm
> using below in /etc/fstab, but this is not preferred since I'm expecting
> hard disks to come and go in my eventual use case - I'm rather certain
> that /dev/sdc will not be the correct drive to mount at some point:
>
> /dev/sdc    /backups/spfs     btrfs noatime,subvol=spfs,compress    0 0
>
>
> Thanks,
>
> -Ben
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
