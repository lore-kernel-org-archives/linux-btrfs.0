Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:58752 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbaBPN6M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 08:58:12 -0500
Received: from frosties.localnet ([149.172.224.32]) by smtp.web.de (mrweb103)
 with ESMTPSA (Nemesis) id 0MeBHO-1WeqHX2eWE-00Pugo for
 <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 14:58:09 +0100
Received: from mrvn by frosties.localnet with local (Exim 4.80)
	(envelope-from <goswin-v-b@web.de>)
	id 1WF2ES-0000Ot-Su
	for linux-btrfs@vger.kernel.org; Sun, 16 Feb 2014 14:58:08 +0100
Date: Sun, 16 Feb 2014 14:58:08 +0100
From: Goswin von Brederlow <goswin-v-b@web.de>
To: linux-btrfs@vger.kernel.org
Subject: ENOSPC with 270GiB free
Message-ID: <20140216135808.GA1491@frosties>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm getting a ENOSPC error from btrfs despite there still being plenty
of space left:

% df -m /mnt/nas3
Filesystem         1M-blocks     Used Available Use% Mounted on
/dev/mapper/nas3-a  19077220 18805132    270773  99% /mnt/nas3

% btrfs fi show
Label: none  uuid: 4b18f84e-2499-41ca-81ff-fe1783c11491
        Total devices 1 FS bytes used 17.91TiB
        devid    1 size 18.19TiB used 17.94TiB path /dev/mapper/nas3-a

Btrfs v3.12

% btrfs fi df
Data, single: total=17.89TiB, used=17.88TiB
System, DUP: total=32.00MiB, used=1.92MiB
Metadata, DUP: total=25.50GiB, used=24.89GiB

As you can see there are still 270GiB free and plenty of block groups
free on the device too.

So why isn't btrfs allocating a new block group to store more data?

MfG
	Goswin
