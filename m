From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: add subvolume when / is not mounted?
Date: Thu, 13 May 2010 20:19:21 +0200
Message-ID: <4BEC42A9.4090005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Well, I do not know if here is the right place to ask questions like
this one so please tell me if it is not.
The situation is the following: btrfs (data and metadata single) on
/dev/sda3 (size 100GB) with two subvolumes /one and /two. Both
subvolumes are mounted to /mnt/one resp. /mnt/two. Is there a way to
create a third subvolume, say three outside of the two existing
subvolumes without mounting "the whole volume /dev/sda3" or even worse
unmounting the two subvolumes before?

Thanks,
Andreas
