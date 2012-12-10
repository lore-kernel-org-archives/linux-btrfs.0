Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33101 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab2LJJ7z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Dec 2012 04:59:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ti09b-0000KA-0t
	for linux-btrfs@vger.kernel.org; Mon, 10 Dec 2012 11:00:03 +0100
Received: from 77.116.246.216.wireless.dyn.drei.com ([77.116.246.216])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Dec 2012 11:00:03 +0100
Received: from philipp.smutny by 77.116.246.216.wireless.dyn.drei.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Dec 2012 11:00:03 +0100
To: linux-btrfs@vger.kernel.org
From: Philipp Smutny <philipp.smutny@gmail.com>
Subject: Re: Weird checksum error with VM images
Date: Mon, 10 Dec 2012 09:57:42 +0000 (UTC)
Message-ID: <loom.20121210T102718-486@post.gmane.org>
References: <1350475643.26001.18.camel@fatty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I think I experienced exactly the same issue, with Debian Wheezy, running
kernel 3.6 on an old fashioned spinning hd. I was using a 1GB raw image with
a plain ext2 filesystem running qemu-kvm with the cache=none option and I
got a lot of:

Dec  6 21:19:59 hephaistos kernel: [  664.769629] btrfs csum failed ino
693974 off 470827008 csum 3711077113 private 141102393

I could still copy the first ~470MB of the raw image and save the only file,
that was important to me. Scrub was unable to fix it, but showed no further
errors.

Philipp

