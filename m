Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:50550 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbbE1Icm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 May 2015 04:32:42 -0400
MIME-Version: 1.0
Message-ID: <trinity-4b189d7e-816b-4903-87ba-0cfd9972d4e4-1432801960117@3capp-webde-bs21>
From: conchur@web.de
To: linux-btrfs@vger.kernel.org
Subject: Metadata size limitations of btrfs
Content-Type: text/plain; charset=UTF-8
Date: Thu, 28 May 2015 10:32:40 +0200
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am working a lot with multiple Linux + OpenWrt builds on top of a btrfs
filesystem. But I am encountering often that my filesystem is considered
full by btrfs (beside having more than 40% free space). The only thing
looking full is the metadata. I've tried to run the balance command with
-dusage=0 but it didn't help. The metadata size stayed at 10G and was
filled up to nearly 10G.

My question is: Can this metadata size limit be changed to allow more
small files on the filesystem? And if yes, how?

According to the kernel btrfs documentation, metadata_ratio= is
currently off by default. So I would guess that this ratio is not
the thing I should play with.

Here the requested information of my fs (after removing a lot of build
directories):

franzbroetchen#   uname -a
Linux franzbroetchen 4.0.0-1-amd64 #1 SMP Debian 4.0.2-1 (2015-05-11) x86_64 GNU/Linux
franzbroetchen#   btrfs --version
btrfs-progs v4.0
franzbroetchen#   btrfs fi show
Label: 'root'  uuid: 57fe2100-0510-11e5-977e-0021ccb48233
        Total devices 1 FS bytes used 182.55GiB
        devid    1 size 467.68GiB used 206.06GiB path /dev/mapper/franzbroetchen_vg-root

btrfs-progs v4.0
franzbroetchen#   btrfs fi df /         
Data, single: total=190.00GiB, used=176.47GiB
System, DUP: total=32.00MiB, used=48.00KiB
Metadata, DUP: total=8.00GiB, used=6.08GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
