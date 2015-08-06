Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35982 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbbHFWRY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 18:17:24 -0400
Received: by qkdv3 with SMTP id v3so31545337qkd.3
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Aug 2015 15:17:23 -0700 (PDT)
MIME-Version: 1.0
From: Peter Foley <pefoley2@pefoley.com>
Date: Thu, 6 Aug 2015 15:17:04 -0700
Message-ID: <CAOFdcFMnYfLzw+xH71eNNgZyhqrgH4qOccak0m4OAnH31V_H=A@mail.gmail.com>
Subject: Removing bad hdd from btrfs volume
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have an btrfs volume that spans multiple disks (no raid, just
single), and earlier this morning I hit some hardware problems with
one of the disks.
I tried btrfs dev del /dev/sda1 /, but btrfs was unable to migrate the
1gb that appears to be causing the read errors.
See http://sprunge.us/aeZC
Is there some way to figure out which file(s) are affected, and if
they are stuff I don't care about, is there some way to force btrfs to
"lose" the 1gb it can't copy off of the failing hdd?

Thanks,

Peter Foley
