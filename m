Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17747 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbaBEOW7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 09:22:59 -0500
Message-ID: <52F2493E.3070900@fb.com>
Date: Wed, 5 Feb 2014 09:22:54 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: "Remco Hosman - Yerf-it.com" <remco@yerf-it.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: hitting BUG_ON on troublesome FS
References: <CCAC08D7-4639-40F4-85DD-459E6D795DAD@yerf-it.com> <52F16045.5020808@fb.com> <50C9BA7F-4988-4765-963C-20B241A13C84@yerf-it.com>
In-Reply-To: <50C9BA7F-4988-4765-963C-20B241A13C84@yerf-it.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/05/2014 01:34 AM, Remco Hosman - Yerf-it.com wrote:
> How can i tell?
>
> Label: data  uuid: a8626d67-4684-4b23-99b3-8d5fa8e7fd69
> Total devices 5 FS bytes used 820.00KiB
> devid    2 size 1.82TiB used 1.00GiB path /dev/sdb2
> devid    3 size 1.82TiB used 1.00GiB path /dev/sdf2
> devid    5 size 2.73TiB used 3.00GiB path /dev/sdd2
> devid    10 size 2.73TiB used 2.03GiB path /dev/sde2
> devid    11 size 3.64TiB used 1.03GiB path /dev/sdc1
>
> Data, RAID10: total=2.00GiB, used=768.00KiB
> Data, RAID1: total=1.00GiB, used=12.00KiB
> System, RAID1: total=32.00MiB, used=4.00KiB
> Metadata, RAID1: total=1.00GiB, used=36.00KiB
>
> i made a image with `btrfs-image`, when i do -c 9, the file size is 
> 7k, so eazy enough to mail if it would be of any use.
>
Yup that would be perfect.  THanks,

Josef
