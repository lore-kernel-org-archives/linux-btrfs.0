Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52448 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3C0QxK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 12:53:10 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1UKtb3-00078I-UW
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 09:53:09 -0700
Date: Wed, 27 Mar 2013 09:53:09 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: zlib vs lzo uncompress speed, ssd vs nossd
Message-ID: <20130327165309.GA23559@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just setup a new SSD with my laptop root filesystem, and at the time I
though, "eh, I'll just use zlib compression during the first copy, and then
switch to lzo afterwards to maintain write speed when I'm using the laptop
after the copy and reboot".

Now, I rebooted with the new ssd and zlib compressed rootfs, and it seemed
to boot slower than it did before with the same root files on btrfs lzo.

My mount options are back to lzo:
/dev/mapper/cryptroot / btrfs rw,noatime,compress=lzo,nossd,discard,space_cache 0 0

Is my feeling of slower boot wrong, or is zlib also noticeably slower than
lzo to read and decompress?

And separately, back a while ago, I read in multiple places that 'nossd'
actually worked better than 'ssd'. This was over a year ago now.

What's the current consensus on ssd and nosdd?
Am I correct that it mostly affects how data is layed out at write time by
btrfs?
Should I go back to trying ssd instead of nossd?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
