Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:44417 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbaLDNvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 08:51:07 -0500
Received: by mail-qc0-f180.google.com with SMTP id i8so12884505qcq.11
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 05:51:06 -0800 (PST)
MIME-Version: 1.0
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Thu, 4 Dec 2014 19:20:46 +0530
Message-ID: <CAH-HCWUcMofyaE8pBXRM5LTHjWcabz+DKouVbauH=Oh9fv2g4g@mail.gmail.com>
Subject: btrfs fi show not accepting mount path as arg?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using SuSE Tumbleweed. Observe:

[samjnaa:~] sudo btrfs fi show
root's password:
Label: 'BRIHATII'  uuid: 57836428-576e-466b-8a28-7961712867ab
        Total devices 1 FS bytes used 460.19GiB
        devid    1 size 931.51GiB used 464.04GiB path /dev/sdb1

Btrfs v3.17+20141103
[samjnaa:~] sudo btrfs fi show /dev/sdb1
Label: 'BRIHATII'  uuid: 57836428-576e-466b-8a28-7961712867ab
        Total devices 1 FS bytes used 460.16GiB
        devid    1 size 931.51GiB used 464.04GiB path /dev/sdb1

Btrfs v3.17+20141103
[samjnaa:~] mount | grep btrfs
/dev/sdb1 on /run/media/samjnaa/BRIHATII type btrfs
(rw,nosuid,nodev,relatime,space_cache,uhelper=udisks2)
[samjnaa:~] sudo btrfs fi show /run/media/samjnaa/BRIHATII/
Btrfs v3.17+20141103
[samjnaa:~]

But the manpage of btrfs filesystem says that <path> is an acceptable
argument to show, by which I understand to mean the mounted path of
the filesystem (or a subvolume thereof?).

Some problem here?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
