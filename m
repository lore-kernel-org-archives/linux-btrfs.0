Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:59081 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3BBP0V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2013 10:26:21 -0500
Received: by mail-we0-f170.google.com with SMTP id z53so3836185wey.29
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Feb 2013 07:26:20 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 2 Feb 2013 20:56:20 +0530
Message-ID: <CAOeZVicqqcrBrL6EiVBgsUzc5uTSTzwghktS2ebtP09Gdg2miw@mail.gmail.com>
Subject: Newbie help-- Making BTRFS partition
From: Atri Sharma <atri.jiit@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I am running a Fedora 17 system. I am trying to set up a new partition
of 2 GB size which has BTRFS as file system.

When I am trying to do mkfs.btrfs on a partition, I get:

[atri@AtriServer ~]$ mkfs.btrfs /dev/sda3

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

check_mounted(): Could not open /dev/sda3
error checking /dev/sda3 mount status


I have unallocated space on my hard disk, but I am not able to make a
partition as it says that I already have 4 primary partitions. Now,I
have no option but to try and convert an existing partition to BTRFS,
which is giving the above error.

Please help.

Thanks,

Atri

--
Regards,

Atri
l'apprenant
