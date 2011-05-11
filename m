From: Marek Fstump <marekfstump@gmail.com>
Subject: very poor read / write performance compared to other FS's?
Date: Wed, 11 May 2011 23:33:35 +0100
Message-ID: <BANLkTinRa9TdVOAaMt9_gcR2xDhbDWVJcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I am very interested in using BTRFS for my solution but in basic tests
it seems to be very poor on read and write performance.  I am
surprised by this so suspect that maybe I am doing something
incorrectly or that there are updates I should be using, but I am not
sure how I update BTRFS on SLES11

Summary:
RESULTS on link below
SLES11 SP1
Compared Sequential read/write performance against XFS and OCFS2
Backend storage =96 FusionIO SLC SSD =3D circa 750MBsec

Tests  set as follows:
=46ilesystem contains 30 x 4GB files (made of random data)
Read tests will read from 1 to 30 files concurrently
Write tests will write 1 to 30 concurrent NEW files (simple 000=92s)
dd -direct flag used on writes

All defaults used for mounting etc.

Results shown in attachment.

BTRFS looks an excellent FS and perfect for my application and I am
hoping that there are some factors that I am missing
and would appreciate any advice / help

Graph is here (Thank you =91cwillu=92)

http://cwillu.com/files/btrfs/read-write_perf.pdf

Marek
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
