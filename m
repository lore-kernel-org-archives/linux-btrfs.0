Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33872 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbcDRFaI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 01:30:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1as1l5-000082-Fk
	for linux-btrfs@vger.kernel.org; Mon, 18 Apr 2016 07:30:03 +0200
Received: from p50908ba1.dip0.t-ipconnect.de ([80.144.139.161])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 07:30:03 +0200
Received: from matthias by p50908ba1.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 07:30:03 +0200
To: linux-btrfs@vger.kernel.org
From: Matthias Bodenbinder <matthias@bodenbinder.de>
Subject: Question: raid1 behaviour on failure
Date: Mon, 18 Apr 2016 07:06:27 +0200
Message-ID: <nf1q0j$ug4$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a raid1 with 3 drives: 698, 465 and 232 GB. I copied 1,7 GB data to that raid1, balanced the filesystem and then removed the bigger drive (hotplug). 

The data was still available. Now I copied the /root directory to the raid1. It showed up via ls -l. Then I plugged in the missing hard drive again (hotplug). After a few seconds "btrfs fi show" is giving output as usual:

Label: none  uuid: 16d5891f-5d52-4b29-8591-588ddf11e73d
	Total devices 3 FS bytes used 1.60GiB
	devid    1 size 698.64GiB used 4.03GiB path /dev/sdg
	devid    2 size 465.76GiB used 4.03GiB path /dev/sdh
	devid    3 size 232.88GiB used 0.00B path /dev/sdi

The /root is still showing up, but the raid1 is now mounted in *read-only* mode. 

I umounted it and mounted it again. Now the /root directory on the raid1 is no longer available. Its gone.

I guess I missed some important step to recover the degraded raid1 before umounting it.

What is it that I missed?

Matthias

