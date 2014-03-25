Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw7a-shanna.wadns.net ([196.220.39.217]:42416 "EHLO
	fw7a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbaCYGmf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 02:42:35 -0400
Message-ID: <53312549.6040207@swiftspirit.co.za>
Date: Tue, 25 Mar 2014 08:42:17 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Slava Barinov <rayslava@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: "Asymmetric" RAID0
References: <CADef55oE1UQbmEnvXcXuYxEwdR=ktYsC2C+QzTjQWu7h5vA7NQ@mail.gmail.com>
In-Reply-To: <CADef55oE1UQbmEnvXcXuYxEwdR=ktYsC2C+QzTjQWu7h5vA7NQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/03/14 07:15, Slava Barinov wrote:
> Hello,
>
>   I've been using a single drive btrfs for some time and when free space
>   became too low I've added an additional drive and rebalanced FS with
>   RAID0 data and RAID1 System and Metadata storage.
>
>   Now I have the following configuration:
>
> # btrfs fi show /btr
> Label: none  uuid: f9d78880-10a7-439b-8ebd-14d815edbc19
>      Total devices 2 FS bytes used 415.45GiB
>      devid    1 size 931.51GiB used 222.03GiB path /dev/sdc
>      devid    2 size 431.51GiB used 222.03GiB path /dev/sdb
>
> # btrfs fi df /btr
> Data, RAID0: total=424.00GiB, used=406.81GiB
> System, RAID1: total=32.00MiB, used=40.00KiB
> Metadata, RAID1: total=10.00GiB, used=8.64GiB
>
> # df -h
> Filesystem                               Size  Used Avail Use% Mounted on
> /dev/sdb                                 1.4T  424G  437G  50% /btr
>
>   I suppose I should trust to btrfs fi df, not df utility.
>
>   So the main question is if such "asymmetric" RAID0 configuration
>   possible at all and why does btrfs ignore ~500 GB of free space on
>   /dev/sdc drive?
>
>   Also it's interesting what will happen when I add 20 GB more data to
>   my FS. Should I be prepared to usual btrfs low-space problems?
>
> Best regards,
> Slava Barinov.
The "raid0" will always distribute data to each disk relatively equally. 
There are exceptions of course. The way to have it better utilise the 
diskspace is to use either "single" (which won't get the same 
performance as raid0) or to add a third disk.

In any raided configuration, the largest disk won't be fully utilised 
unless the other disks add up to be equal to or more than that largest disk.

Play around with Hugo's disk usage calculator to get a better idea of 
what the different configurations will do: http://carfax.org.uk/btrfs-usage/

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

