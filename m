Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-out-2.itc.rwth-aachen.de ([134.130.5.47]:37031 "EHLO
        mail-out-2.itc.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932621AbdIYHEQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 03:04:16 -0400
From: "Fuhrmann, Carsten" <carsten.fuhrmann@rwth-aachen.de>
To: Andrei Borzenkov <arvidjaar@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: AW: AW: Btrfs performance with small blocksize on SSD
Date: Mon, 25 Sep 2017 07:04:14 +0000
Message-ID: <a7bde40e8fa8416c888e8c65a7442b65@rwth-aachen.de>
References: <3321b3c199da4d378bbfa3dbac3c4059@rwth-aachen.de>
 <f05a6500-19d6-fc7c-7461-905417c855b7@gmx.com>
 <b9067303023a49158bae2cdc34393716@rwth-aachen.de>
 <ffd3bf37-3029-9f6e-5d57-6d8cca74fdad@gmail.com>
In-Reply-To: <ffd3bf37-3029-9f6e-5d57-6d8cca74fdad@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well the correct translation for "Laufzeit" is runtime and not latency. But thank you for that hint, I'll change it to "gesamt Laufzeit" to make it more clear.


Best regards

Carsten

-----UrsprÃ¼ngliche Nachricht-----
Von: Andrei Borzenkov [mailto:arvidjaar@gmail.com] 
Gesendet: Sonntag, 24. September 2017 18:43
An: Fuhrmann, Carsten <carsten.fuhrmann@rwth-aachen.de>; Qu Wenruo <quwenruo.btrfs@gmx.com>; linux-btrfs@vger.kernel.org
Betreff: Re: AW: Btrfs performance with small blocksize on SSD

24.09.2017 16:53, Fuhrmann, Carsten Ğ¿Ğ¸ÑˆĞµÑ‚:
> Hello,
> 
> 1)
> I used direct write (no page cache) but I didn't disable the Disk cache of the HDD/SSD itself. In all tests I wrote 1GB and looked for the runtime of that write process.

So "latency" on your diagram means total time to write 1GiB file? That is highly unusual meaning for "latency" which normally means time to perform single IO. If so, you should better rename Y-axis to something like "total run time".
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
