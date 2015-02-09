Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33437 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbBIWYm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 17:24:42 -0500
Received: by pdbnh10 with SMTP id nh10so31676803pdb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 14:24:42 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Feb 2015 17:24:42 -0500
Message-ID: <CAGfcS_=Jz8Ktz3VMwkeKTZyAd5=8r+_YnkhDsVad9yGmpfkyAg@mail.gmail.com>
Subject: btrfs raid5 with mixed disks
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How does btrfs raid5 handle mixed-size disks?  The docs weren't
terribly clear on this.

Suppose I have 4x3TB and 1x1TB disks.  Using conventional lvm+mdadm in
raid5 mode I'd expect to be able to fit about 10TB of space on those
(2TB striped across 4 disks plus 1TB striped across 5 disks after
partitioning).  How much would btrfs be able to store in the same
configuration?  I did see something about being able to use fixed-size
stripes, and I'm not sure if this helps.  If it does, are there any
penalties, especially with future expansion of the array?

With raid1 mode btrfrs is reasonably smart about mixed disk sizes, and
you usually end up with half of the total space available.

--
Rich
