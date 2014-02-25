Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hibox-130.abo.fi ([130.232.216.130]:59171 "EHLO centre.hibox.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbaBYRPE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 12:15:04 -0500
Received: from 82.131.86.40.cable.starman.ee ([82.131.86.40] helo=[192.168.42.7])
	by centre.hibox.fi with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <sundman@iki.fi>)
	id 1WILCc-0002Zc-Db
	for linux-btrfs@vger.kernel.org; Tue, 25 Feb 2014 18:49:54 +0200
Message-ID: <530CC9B0.1080703@iki.fi>
Date: Tue, 25 Feb 2014 18:49:52 +0200
From: Marcus Sundman <sundman@iki.fi>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: No space left on device (again)
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I get "No space left on device" and it is unclear why:

> # df -h|grep sda3
> /dev/sda3       413G  368G   45G  90% /home
> # btrfs filesystem show /dev/sda3
> Label: 'home'  uuid: 46279061-51f4-40c2-afd0-61d6faab7f60
>     Total devices 1 FS bytes used 371.11GB
>     devid    1 size 412.54GB used 412.54GB path /dev/sda3
>
> Btrfs v0.20-rc1
> # btrfs filesystem df /home
> Data: total=410.52GB, used=369.61GB
> System: total=4.00MB, used=64.00KB
> Metadata: total=2.01GB, used=1.50GB
> #

So, 'data' and 'metadata' seem to be fine(?), but 'system' is a bit low. 
Is that it? If so, can I do something about it? Or should I look 
somewhere else?

I really wish I could get a warning before running out of disk space, 
instead of everything breaking suddenly when there seems to be lots and 
lots of space left.

- Marcus

