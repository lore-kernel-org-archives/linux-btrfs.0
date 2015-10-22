Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36138 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbbJVBTA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 21:19:00 -0400
Received: by wicfx6 with SMTP id fx6so114682559wic.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 18:18:59 -0700 (PDT)
Received: from [192.168.1.113] ([88.132.201.190])
        by smtp.gmail.com with ESMTPSA id g9sm1290547wix.1.2015.10.21.18.18.57
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Oct 2015 18:18:57 -0700 (PDT)
Message-ID: <56283981.294fb40a.5301a.5630@mx.google.com>
Date: Thu, 22 Oct 2015 03:18:52 +0200
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
From: =?ISO-8859-1?Q?J=E1nos_T=F3th_F=2E?= <toth.f.janos@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried that after every possible combinations of RO mount failed. I used it in the past for an USB attached drive where an USB-SATA adapter had some issues (I plugged it into a standard USB2 port even though it expected USB3 power current, so a high-current or several standard USB2 ports should have been used to prevent it from emergency shutdown during file copy). It worked flawlessly then but in this case it threw the same errors as "btrsf check". It couldn't even find and list alternative roots. Every tools seemed to give up really fast and easy, sometimes with segfaults and tracing messages in the kernel log.On Oct 21, 2015 22:26, Chris Murphy <lists@colorremedies.com> wrote:
>
> https://btrfs.wiki.kernel.org/index.php/Restore 
>
> This should still be possible with even a degraded/unmounted raid5. It 
> is a bit tedious to figure out how to use it but if you've got some 
> things you want off the volume, it's not so difficult to prevent 
> trying it. 
>
>
> Chris Murphy 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
