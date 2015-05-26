Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35299 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbbEZNT1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 09:19:27 -0400
Received: by lbbuc2 with SMTP id uc2so70205365lbb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 06:19:24 -0700 (PDT)
Received: from [172.20.216.32] ([212.98.163.35])
        by mx.google.com with ESMTPSA id z7sm2969036lal.33.2015.05.26.04.23.36
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 May 2015 04:23:36 -0700 (PDT)
Message-ID: <556457b8.e72b980a.ee08.ffffce60@mx.google.com>
Date: Tue, 26 May 2015 14:23:35 +0300
Subject: RAID1: system stability
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,
I'm regular on this list and I very like btrfs, I want use it on production server, and I want replace hw raid on it.

Test case: server with N scsi discs
2 SAS disks used for raid 1 root fs
If I just remove one disk physically, all okay, kernel show me write errors and system continue work some time. But after first sync call, example
# sync
# dd if=/Dev/zero of=/zero

Kernel will crush and system freeze.
Yes, after reboot, I can mount with degraded and recovery options, and I can add failed disk again, and btrfs will rebuild array.
But kernel crush and reboot expected in this case, or I can skip it? How?
# mount -o remount, degraded -> kernel crush
Insert failed disk again -> kernel crush

May be I missing something? I just want avoid shutdown time or/and reboot =.=ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
