Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:56603 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbaLDXzh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 18:55:37 -0500
Received: by mail-qg0-f41.google.com with SMTP id j5so13600381qga.14
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 15:55:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5480A54C.6050900@pobox.com>
References: <CAH-HCWUp0yOZRsW2p2kDjw=eeK4_BQ9DgtKCM2MEC4G=9QtM3w@mail.gmail.com>
 <54806C19.4090503@gmail.com> <CAH-HCWXXerTeeXGoQhpj-eXO78H45f6rDje4Oh2CDuZDS8-cww@mail.gmail.com>
 <5480A54C.6050900@pobox.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Fri, 5 Dec 2014 05:25:16 +0530
Message-ID: <CAH-HCWUkCz4Z787bmpztKCjWzRSN8hyZhAp4B8OVm5eep7pGtg@mail.gmail.com>
Subject: Re: System/single + Metadata/single as leftover cruft of mkfs?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 4, 2014 at 11:47 PM, Robert White <rwhite@pobox.com> wrote:
>
> If those disappeared, or got stripped off onto other drives then not-amusing
> things would happen.

Well after doing btrfs bal start <path> -mprofiles=single, the FS is
still working...

-- 
Shriramana Sharma à®¶à¯à®°à¯€à®°à®®à®£à®¶à®°à¯à®®à®¾ à¤¶à¥à¤°à¥€à¤°à¤®à¤£à¤¶à¤°à¥à¤®à¤¾
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
