Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:57985 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbbBFUBb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Feb 2015 15:01:31 -0500
Received: by mail-oi0-f52.google.com with SMTP id h136so13703934oig.11
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Feb 2015 12:01:30 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 6 Feb 2015 15:01:30 -0500
Message-ID: <CAPn+qJhxzbG-FjUUG9VzzZvvA=nSyaFxp3PQrMSm10QXrCtNNw@mail.gmail.com>
Subject: RAID1, SSD+non-SSD
From: Brian B <canis8585@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My laptop has two disks, a SSD and a traditional magnetic disk. I plan
to make a partition on the mag disk equal in size the SSD and set up
BTRFS RAID1. This I know how to do.

The only reason I'm doing the RAID1 is for the self-healing. I realize
writing large amounts of data will be slower than the SSD alone, but
is it possible to set it up to only read from the magnetic drive if
there's an error reading from the SSD?

In other words, is there a way to tell it to only read from the faster
disk?  Is that even necessary?  Is there a better way to accomplish
this?
