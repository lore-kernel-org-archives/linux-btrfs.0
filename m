Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm15.bullet.mail.ird.yahoo.com ([77.238.189.68]:27406 "HELO
	nm15.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751052Ab3EMPah (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 11:30:37 -0400
Message-ID: <5191071B.7090209@influence-pc.fr>
Date: Mon, 13 May 2013 17:30:35 +0200
From: Vincent <vincent@influence-pc.fr>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Remove a materially failed device from a Btrfs "single-raid"
 using partitions
References: <5190F59F.405@influence-pc.fr> <CAFWF=akT1vSPSXkAKCf9y3Ej63XSmBGC_MZKk0BCRxz2diCHFg@mail.gmail.com> <5190F9C7.1080904@influence-pc.fr> <CAFWF=ak4mKMgNZHx6pxuhY7pCEE0G-aifGNi_zRX5zyAUh7n-g@mail.gmail.com>
In-Reply-To: <CAFWF=ak4mKMgNZHx6pxuhY7pCEE0G-aifGNi_zRX5zyAUh7n-g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shit, I've followed the official documentation 
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Replacing_failed_devices

With, as explain:
mkfs.btrfs -d single /dev/sda3 /dev/sdb1 /dev/sdc1 /dev/sdd1

mount -o degraded /dev/sda3 /media/single-raid/
btrfs device delete missing /media/single-raid/

And now all my datas on ALL drive has been deleted. How could I retrieve 
datas on my Btrfs formatted partition now?!


