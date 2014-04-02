Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:60898 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbaDBRyZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 13:54:25 -0400
Received: by mail-lb0-f182.google.com with SMTP id n15so442156lbi.41
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Apr 2014 10:54:24 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Apr 2014 10:54:24 -0700
Message-ID: <CAKgsxVSJEug-R-OT3Z2TF5JFf-AU+hw4MaPOnupDV2CZBBLU7A@mail.gmail.com>
Subject: Space cache degradation
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've found that, after using some btrfs filesystems for some time,
that the first large write after a reboot takes a very long time.  So
I went to work trying out different test cases to simplify
reproduction of the issue, and I've got it down to just these steps:

1) mkfs.btrfs on a large-ish device.  I used a 14TB MD RAID5 device.
2) Fill it up a bit over half-way with ~5MB files.  In my test I made
30 copies of a 266GB data set consisting of 52,356 files and 20,268
folders.
3) umount
4) mount
5) time fallocate -l 2G /mount/point/2G.dat
real 3m9.412s
user 0m0.002s
sys 0m2.939s

By comparison, if I don't use space cache things go much better:
# umount
# mount -o nospace_cache
# time fallocate -l 2G /mount/point/2G.dat
real 0m15.982s
user 0m0.002s
sys 0m0.103s

If I use the clear_cache mount option, that also resolves the slowness.

Is this a known issue?  For me it's 100% reproducible, on various
kernel versions including 3.14-rc8.  Is there anything I should
provide to help debug?

-Justin
