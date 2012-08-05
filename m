Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45067 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2HEK1j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Aug 2012 06:27:39 -0400
Received: by pbbrr13 with SMTP id rr13so931892pbb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Aug 2012 03:27:38 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 5 Aug 2012 12:27:38 +0200
Message-ID: <CAJtBfr9mX-T8+-nGAvkinaO3yEw20zjRdab=4vjukwZTj0nR7w@mail.gmail.com>
Subject: filesystem show still has stale filesystem
From: Florian Lindner <mailinglists@xgm.de>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I was playing with btrfs and accidentally formatted the disk directly
(/dev/sdb instead of sdb1). Since then I rewrote the GPT partition
table, recreated the partition and ran btrfs device scan. Still, btrfs
filesystem show prints:

root@horus /mnt # btrfs fi sh --all-devices
failed to read /dev/sr0: No medium found
Label: 'test'  uuid: ffab72f2-eff1-4ac8-a694-d56dd84fda24
        Total devices 1 FS bytes used 28.00KB
        devid    1 size 2.73TB used 2.04GB path /dev/sdb

Label: 'home'  uuid: c465d715-098a-4d0d-bebc-6aa51f4cb349
        Total devices 1 FS bytes used 28.00KB
        devid    1 size 2.73TB used 2.04GB path /dev/sdb1

Btrfs Btrfs v0.19

Label home is the actual partition in use but how can I get rid of
label test which was the accidental formatting? Is this just some
cached value or still persistent on the disk?

Thanks,

Florian
