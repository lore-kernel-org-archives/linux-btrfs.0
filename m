Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-out-1.itc.rwth-aachen.de ([134.130.5.46]:58361 "EHLO
        mail-out-1.itc.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751144AbdJEQCD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Oct 2017 12:02:03 -0400
From: "Fuhrmann, Carsten" <carsten.fuhrmann@rwth-aachen.de>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs HDD vs SSD
Date: Thu, 5 Oct 2017 16:02:01 +0000
Message-ID: <8b5db5ddf02d4832ac9abab51a5d62da@rwth-aachen.de>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

i compared btrfs raid with mdadm raid. The mdadm raid was used with ext4 filesystem.
I used 4 SSDs and 4 HDDs in RAID0, RAID1 and RAID5. In the test I compiled the linux kernel and took the time how long it compiled + pagecache drop.
The interesting result is that btrfs is always better on the HDDs but on the SSDs mdadm is better. Do you have an explanation for that?

Furthermore I tested writing on the RAIDs. I used a tool that wrote always 1GB with different blocksizes. The filesystems had the default 4k blocksize.
For RAID5 the runtime become better and better there was no saturation even for 512k blocksize. But when I compiled the kernel with raid 5 it took the same time as it took on a btrfs no raid disk. For a RAID 1 it's fine but for RAID5 it should be faster (for RAID0 it actually is).
Can you explain those results to me?


Thank you

Carsten
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
