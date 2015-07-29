Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34390 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbbG2CQb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 22:16:31 -0400
Received: by lbbzr7 with SMTP id zr7so86491331lbb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2015 19:16:30 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 29 Jul 2015 02:16:29 +0000
Message-ID: <CA+X5Wn63oURx2yKAJS4cCR+9v8fdx950RervzmXqTtXbHXn+gg@mail.gmail.com>
Subject: mkfs.btrfs with invalid -d option uses default single drive, rather
 than errors
From: james harvey <jamespharvey20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Doing some fast-paced benchmarking of lots of raid levels, some in a
kvm, some via RDMA access over InfiniBand using different procotols,
etc.

Was shocked to see horrible raid0 performance in one of the tests.
Looked back through the logs and found:

(Note that I typo'ed -d raid**e**0

=====
$ sudo mkfs.btrfs -f -m raid0 -d raide0 /dev/vda2 /dev/vdb1 /dev/vdc1
Unknown profile raide0
btrfs-progs v4.1.2
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               6a49602b-2edb-46aa-b602-352c5257284c
Node size:          16384
Sector size:        4096
Filesystem size:    108.00GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         RAID0             3.01GiB
  System:           RAID0            19.94MiB
=====

It defaulted to using a single drive for data.

I think having it do nothing and give an error would be better.
