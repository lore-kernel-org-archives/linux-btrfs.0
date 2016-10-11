Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mc6.unige.ch ([129.194.9.219]:51927 "EHLO unige.ch"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753133AbcJKQCV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 12:02:21 -0400
Received: from wuniex13-2.unige.ch ([10.13.16.5] helo=wuniex13-2.isis.unige.ch)
        by unige.ch stage1 with esmtps
        (Exim MailCleaner)
        id 1btylC-0009wR-S9
        for <linux-btrfs@vger.kernel.org>
        from <Philip.Moetteli@unige.ch>; Tue, 11 Oct 2016 17:14:30 +0200
From: Philip Louis Moetteli <Philip.Moetteli@unige.ch>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RAID system with adaption to changed number of disks
Date: Tue, 11 Oct 2016 15:14:30 +0000
Message-ID: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,


I have to build a RAID 6 with the following 3 requirements:

	â€¢ Use different kinds of disks with different sizes.
	â€¢ When a disk fails and there's enough space, the RAID should be able to reconstruct itself out of the degraded state. Meaning, if I have e. g. a RAID with 8 disks and 1 fails, I should be able to chose to transform this in a non-degraded (!) RAID with 7 disks.
	â€¢ Also the other way round: If I add a disk of what size ever, it should redistribute the data, so that it becomes a RAID with 9 disks.

I donâ€™t care, if I have to do it manually.
I donâ€™t care so much about speed either.

Is BTrFS capable of doing that?


Thanks a lot for your help!

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
