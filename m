From: Berke Durak <berke.durak@gmail.com>
Subject: Minimum device size of 256 MiB?
Date: Fri, 11 May 2012 15:57:24 -0400
Message-ID: <CAALTfKDFhNgCuvuA3C+wYCBL2b-qZkNrwti_MbNn4Aiob+QdkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

There seems to be a 256 MiB lower limit on device size : mkfs.btrfs
refuses to create a filesystem
on a device that is smaller than that.

I'm interested in using the btrfs RAID facility to provide redundancy
for an embedded system, but I can't afford
two 256 MiB partitions.

What are the structural reasons for this limit?  Could I reduce this
limit easily with a couple small code changes
or would it take a major effort?

Thanks,
-- 
Berke Durak
