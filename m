Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from x1-6-a4-2b-8c-8c-bd-da.cpe.webspeed.dk ([2.104.2.239]:51224
	"EHLO mail.musikcheck.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbcECIwr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 04:52:47 -0400
Received: from [192.168.0.16]
	by mail.musikcheck.dk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.86_2)
	(envelope-from <hasse@hagenjohansen.dk>)
	id 1axW4U-00065j-EG
	for linux-btrfs@vger.kernel.org; Tue, 03 May 2016 10:52:46 +0200
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Subvolumes cannot be mounted after raid1 conversion 
From: Hasse Hagen Johansen <hasse@hagenjohansen.dk>
Date: Tue, 03 May 2016 10:52:36 +0200
To: linux-btrfs@vger.kernel.org
Message-ID: <983F0471-51E8-47EC-B5A0-FBA9040F634B@hagenjohansen.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I have made a btrfs on a single physical disk and made 3 subvolumes which I manually mounted and copied data to. Yesterday I added another disk to the filesystem and ran btrfs balance start -mconvert=raid1 -dconvert=raid1 /mnt/temp where /mnt/temp is top-level fimesystem(not the subvolumes). After that have finished I cannot mount the individual subvolumes

can anyone explain how it is supposed to work. I can still see the files in the top-level filesystem but it seems subvolumes doesn't work after raid1 conversion

Best Regards 
Hasse
-- 
Sendt fra min telefon med K9 Mail. Undskyld hvis jeg er lidt kortfattet.
