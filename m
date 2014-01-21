Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58909 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaAUJGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 04:06:41 -0500
Received: by mail-pb0-f53.google.com with SMTP id md12so3075184pbc.26
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 01:06:40 -0800 (PST)
Received: from [10.2.222.50] (216-19-183-145.dyn.novuscom.net. [216.19.183.145])
        by mx.google.com with ESMTPSA id g6sm21781463pat.2.2014.01.21.01.06.38
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 21 Jan 2014 01:06:39 -0800 (PST)
From: Graham Fleming <graham.fleming@gmail.com>
Content-Type: text/plain; charset=us-ascii
Subject: RE: Scrubbing with BTRFS Raid 5
Message-Id: <95DB9BB3-D706-4023-940A-D100D93D560A@gmail.com>
Date: Tue, 21 Jan 2014 01:06:37 -0800
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for all the info guys.

I ran some tests on the latest 3.12.8 kernel. I set up 3 1GB files and attached them to /dev/loop{1..3} and created a BTRFS RAID 5 volume with them.

I copied some data (from dev/urandom) into two test files and got their MD5 sums and saved them to a text file.

I then unmounted the volume, trashed Disk3 and created a new Disk4 file, attached to /dev/loop4.

I mounted the BTRFS RAID 5 volume degraded and the md5 sums were fine. I added /dev/loop4 to the volume and then deleted the missing device and it rebalanced. I had data spread out on all three devices now. MD5 sums unchanged on test files.

This, to me, implies BTRFS RAID 5 is working quite well and I can in fact, replace a dead drive.

Am I missing something?