Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:49885 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbaIDNDG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Sep 2014 09:03:06 -0400
Received: by mail-lb0-f180.google.com with SMTP id w7so11566179lbi.11
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Sep 2014 06:03:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANg_oxxmR+qkSfZeVYK5dF1HnbSJapEF1tZ+3-9ij5hq7d2E=w@mail.gmail.com>
References: <CANg_oxxmR+qkSfZeVYK5dF1HnbSJapEF1tZ+3-9ij5hq7d2E=w@mail.gmail.com>
Date: Thu, 4 Sep 2014 15:03:04 +0200
Message-ID: <CANg_oxzsAAV3S-Qc=mz0GTVXnPFrQ43riNXVbtT4Wjqtwsbo2A@mail.gmail.com>
Subject: Re: BTRFS critical (device dm-0): invalid dir item name len: 45389
From: john terragon <jterragon@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some more details about this problem:

-the directory involved is /lib/modules/3.17.0-rc3-cu3/kernel/drivers/iio/gyro
-in that dir there should be kernel object named hid-sensor-gyro-3d.ko
but there's
 no trace of it
-that dir cannot be removed or overwritten. rm -rf fails saying that
the dir cannot be
 removed because it's not empty (?, even with -rf ?) and trying to
reinstall the .deb
 package for that kernel image (thus overwriting that dir) ends up in a segfault

The only workaround is to mv that dir (well, I simply mv the whole
3.17.0-rc3-cu3 dir but it should work also for the gyro subdir) and
reinstall the deb package.

So, it's pretty serious because there's actual loss of data (even
though I was lucky I just lost a ko I don't use).

John
