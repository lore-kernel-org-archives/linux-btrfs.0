Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:8565 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbbAKPtq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Jan 2015 10:49:46 -0500
To: linux-btrfs@vger.kernel.org
Message-ID: <m06ccfr0BFniGfQ.RZmta@mo4-p00-ob.smtp.rzone.de>
Received: from [192.168.1.87] (0x3ec726af.inet.dsl.telianet.dk [62.199.38.175])
	by smtp.strato.de (RZmta 36.3 DYNA|AUTH)
	with ESMTPSA id m06ccfr0BFniGfQ
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Sun, 11 Jan 2015 16:49:44 +0100 (CET)
Date: Sun, 11 Jan 2015 16:49:55 +0100
Subject: Re: Device only missing if unmounted
From: Florian Uekermann <florian@uekermann.me>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I wasn't sure when to drop the caches, so I did it before and after mounting. But no change the output of btrfs-show-super always looks the same and btrfs show fi only says "Total devices 4" if the fs is not mounted. After mounting it says 3 and after unmounting it says 4 again.
About the hardware: I am using a normal amd64 consumer Pc with a set of different normal sata disks. The machine is rebooted daily (in case that matters for caches).

To uneducated me, it looks a bit like the btrfs utility is screwing up here when figuring out how many devices should be there. I don't know how closely this is tied to the kernel and how much of the logic is actually part of the kernel here and how much is userspace code. Do you think it makes sense to use some newer upstream version of the btrfs utility?
The debian package containing the btrfs command has 3.17-1.1 as version string.

Best regards,
Florian

On Dec 24, 2014 4:45 PM, Anand Jain <anand.jain@oracle.com> wrote:
>
>
> Very strange, user space reads num_device as 4 but kernel 
> reads it as 3 (total_device), thus a device missing when 
> mounted. 
> Not sure what kind of hardware at your end, Can cache be 
> issue ? could you drop cache and check for me. 
> Â  echo 3 > /proc/sys/vm/drop_cache 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
