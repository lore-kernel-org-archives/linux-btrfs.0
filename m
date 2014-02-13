Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41741 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaBMV1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 16:27:51 -0500
Received: by mail-pa0-f45.google.com with SMTP id lf10so11317199pab.4
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 13:27:51 -0800 (PST)
Received: from [10.2.222.50] (70-36-52-220.dyn.novuscom.net. [70.36.52.220])
        by mx.google.com with ESMTPSA id u6sm9845297pbu.16.2014.02.13.13.27.50
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 13 Feb 2014 13:27:50 -0800 (PST)
From: Graham Fleming <graham.fleming@gmail.com>
Content-Type: text/plain; charset=us-ascii
Subject: Can't mount volume after devices disconnected from an online RAID 10
Message-Id: <E7F9287A-C4A7-44D2-8EBD-EFBA6FF84BF3@gmail.com>
Date: Thu, 13 Feb 2014 13:27:48 -0800
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey guys,

I have a 6-drive RAID10 btrfs volume. 2 drives are internal, then I have 2 external 2-bay enclosures. One of the enclosures disconnected and went offline and I quickly unmounted the volume and then rebooted. With all drives connected, and visible in "btrfs fi show" I tried to mount the volumes but am getting errors in syslog:

failed to read tree root on sdf (one of the drives in the enclosure that went offline)
open_ctree failed

I also get this output when attempting to mount degraded on the command line (stdout):

wrong fs type, bad option, bad superblock on /dev/sdg,
       missing codepage or helper program, or other error

/dev/sdg is the other drive in the enclosure that disconnected.

I have most things backed up except for a bunch of movies and stuff. Not a huge deal but I'd like to see if any of the btrfs recovery tools can get me back to a working state.

Much appreciated. Thanks,

Graham