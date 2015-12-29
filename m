Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35869 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbbL2AKO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 19:10:14 -0500
Received: by mail-io0-f177.google.com with SMTP id o67so316299986iof.3
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 16:10:14 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 28 Dec 2015 17:10:14 -0700
Message-ID: <CAJCQCtT78=kqXZVDAV-x0C1NW=7okBBM_+vM3+HAc5BtUArsiw@mail.gmail.com>
Subject: should btrfsck fix a bad superblock?
From: Chris Murphy <chris@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I (intentionally) used wipefs -a on a device with a btrfs. As expected
btrfs check doesn't recognize the device as having a btrfs volume
anymore.

Slightly surprising that it doesn't mention other intact supers are found.

Most surprising that options -s1 --repair doesn't fix it.

I thought maybe it's intentional, only with explicitly bad magic, and
I'd get different results if it were zero'd. So I zero'd it and I get
the same results. s0 superblock isn't repaired with --repair.

Bug?

Of course I can fix it with echo+dd.


-- 
Chris Murphy
