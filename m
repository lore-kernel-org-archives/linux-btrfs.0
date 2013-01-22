Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:36419 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3AVMIY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 07:08:24 -0500
Received: by mail-vc0-f176.google.com with SMTP id fy27so2140611vcb.21
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 04:08:24 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 22 Jan 2013 16:08:23 +0400
Message-ID: <CAFCsa79Cn65gUFKT9RmCYG1WjP257n+iy0zGh_-vaX4Pc_grVA@mail.gmail.com>
Subject: Simple btrfs use case
From: Pavel Vasilyev <ml@yekm.name>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

For example I have a bunch of various disks. I want to use them all as
one big storage:
mkfs.btrfs -m raid1 -d single /dev/sda /dev/sdb /dev/sdc ...
And someday one of my disks becomes dead. Disappears.
However, I can still mount fs in degraded,ro mode. All files that lays
on working disks are still available, but the only option to save
those files is to make a new fs on a new disk and copy them to it.
Why? Can I just drop files, whose chunks was on the dead disk?


How btrfs allocates files (file chunks) on physical disks? i.e. can I
lose all my files in -d single mode, when one of my disk becomes dead?
