Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37225 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbbHMHhf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 03:37:35 -0400
Message-ID: <55CC488D.4020203@oracle.com>
Date: Thu, 13 Aug 2015 15:34:37 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Ulli Horlacher <framstag@rus.uni-stuttgart.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: RAID0 wrong (raw) device?
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
In-Reply-To: <20150812130758.GA26529@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> root@toy02:~# df -T /data
> Filesystem     Type   1K-blocks      Used  Available Use% Mounted on
> /dev/sdb       btrfs 3906909856 140031696 3765056176   4% /data
>
> root@toy02:~# btrfs filesystem show /data
> Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
>          Total devices 2 FS bytes used 129.81GiB
>          devid    3 size 1.82TiB used 67.03GiB path /dev/drbd2
>          devid    4 size 1.82TiB used 67.03GiB path /dev/sdb
>
> Btrfs v3.12
>
> ==> btrfs shows the wrong (raw) device /dev/sdb instead of /dev/drbd3 !

Don't be too alarmed by that, progs do a bit of user land fabrication 
(wrong). kernel may /may-not be using sdb. try -m option.

just in case if it didn't, Then use mount -o devices / btrfs dev scan 
<dev> option to provide the desired dev path to the kernel.

Thanks, Anand
