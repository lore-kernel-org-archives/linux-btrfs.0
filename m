Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35690 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbbHOACu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 20:02:50 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t7F02nBA002294
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2015 00:02:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t7F02nEW018717
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2015 00:02:49 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t7F02neS016283
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2015 00:02:49 GMT
Message-ID: <55CE81A6.5070305@oracle.com>
Date: Sat, 15 Aug 2015 08:02:46 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID0 wrong (raw) device?
References: <20150812130758.GA26529@rus.uni-stuttgart.de> <55CC488D.4020203@oracle.com> <20150813120211.GA24122@rus.uni-stuttgart.de> <20150813145556.GA27405@rus.uni-stuttgart.de> <55CCC4AB.2080600@oracle.com> <20150814073211.GA10650@rus.uni-stuttgart.de>
In-Reply-To: <20150814073211.GA10650@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


First of all there is a known issue in handling multiple paths /
instances of the same device image in btrfs. Fixing this caused
regression earlier. And my survey
    [survey]  BTRFS_IOC_DEVICES_READY return status
almost told me not to fix the bug.

But these are just a reporting issue which would confuse users, should 
be fixed.


> There is now a new behaviour: after the btrfs mount, I can see shortly the
> wrong raw device /dev/sde and a few seconds later there is the correct
> /dev/drbd3 :

yep possible. but it does not mean that btrfs kernel is using the new 
path its just a reporting (bug).



(pls use -m option)
>
> root@toy02:/etc# umount /data
> root@toy02:/etc# mount /data
> root@toy02:/etc# btrfs filesystem show
> Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
>          Total devices 2 FS bytes used 109.56GiB
>          devid    3 size 1.82TiB used 63.03GiB path /dev/drbd2
>          devid    4 size 1.82TiB used 63.03GiB path /dev/sde
>
> Btrfs v3.12
> root@toy02:/etc# btrfs filesystem show
> Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
>          Total devices 2 FS bytes used 109.56GiB
>          devid    3 size 1.82TiB used 63.03GiB path /dev/drbd2
>          devid    4 size 1.82TiB used 63.03GiB path /dev/drbd3
>
> Btrfs v3.12
>
> root@toy02:/etc# btrfs filesystem show -m
> Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
>          Total devices 2 FS bytes used 109.56GiB
>          devid    3 size 1.82TiB used 63.03GiB path /dev/drbd2
>          devid    4 size 1.82TiB used 63.03GiB path /dev/drbd3
>
> Btrfs v3.12
>



> Still, the kernel sees 3 instead of (really) 2 HGST drives:
>
> root@toy02:/etc# hdparm -I /dev/sdb | grep Number:
>          Model Number:       HGST HUS724020ALA640
>          Serial Number:      PN2134P5G2P2AX
>
> root@toy02:/etc# hdparm -I /dev/sde | grep Number:
>          Model Number:       HGST HUS724020ALA640
>          Serial Number:      PN2134P5G2P2AX

This is important to know but not a btrfs issue. Do you have multiple 
host paths reaching this this device with serial # PN2134P5G2P2AX ?
