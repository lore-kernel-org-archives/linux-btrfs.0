Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:59691 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2JHGQG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 02:16:06 -0400
Message-ID: <50726FA3.7050608@petaramesh.org>
Date: Mon, 08 Oct 2012 08:16:03 +0200
From: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
References: <50714AC8.4010100@petaramesh.org> <201210071259.05801.Martin@lichtvoll.de> <50718C44.2080701@petaramesh.org> (sfid-20121007_163444_636745_E6F75E74) <201210071648.54027.Martin@lichtvoll.de>
In-Reply-To: <201210071648.54027.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

Le 07/10/2012 16:48, Martin Steigerwald a écrit :
> Where is this volume pool located on? On which drive(s)?
All the concerned machines are laptops with a single physical HD...

> This could be 100 or more subvolumes / snapshots.
>
> Maybe slowness could be related to this one.
That's a good estimation... I'm not sure if there is any theoretical
reason why the number of snapshots of a given volume might slow down
access to this volume ?

> It would be good to have some capture of this slowness with
>
> vmstat 10
>
> iostat -xd 10 /your/device
I will try to give you some figures. But when the machine starts really
crawling, it becomes very hard to start any new program unless it's
"finished being slow", so that's not so easy...
> Also how much RAM has the machine? What does free -m / cat /proc/meminfo 
> tell.
The 4 concerned machines have either 4GB or 2GB RAM.  None is heavily
loaded as far as RAM is concerned (just booting into a standard Ubuntu
GUI and then accessing emailn, browser, office applications etc.)

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

