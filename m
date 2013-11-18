Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49666 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3KRWJA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 17:09:00 -0500
MIME-Version: 1.0
Date: Mon, 18 Nov 2013 23:08:59 +0100
Message-ID: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
Subject: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: hpa@zytor.com, david.brown@hesbynett.no, creamyfish@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I want to report that I recently implemented a support for
arbitrary number of parities that could be useful also for Linux
RAID and Btrfs, both currently limited to double parity.

In short, to generate the parity I use a Cauchy matrix specifically
built to be compatible with the existing Linux parity computation,
and extensible to an arbitrary number of parities. This without
limitations on the number of data disks.

The Cauchy matrix for six parities is:

01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01...
01 02 04 08 10 20 40 80 1d 3a 74 e8 cd 87 13 26 4c 98 2d 5a b4 75...
01 f5 d2 c4 9a 71 f1 7f fc 87 c1 c6 19 2f 40 55 3d ba 53 04 9c 61...
01 bb a6 d7 c7 07 ce 82 4a 2f a5 9b b6 60 f1 ad e7 f4 06 d2 df 2e...
01 97 7f 9c 7c 18 bd a2 58 1a da 74 70 a3 e5 47 29 07 f5 80 23 e9...
01 2b 3f cf 73 2c d6 ed cb 74 15 78 8a c1 17 c9 89 68 21 ab 76 3b...

You can easily recognize the first row as RAID5 based on a simple
XOR, and the second row as RAID6 based on multiplications by powers
of 2. The other rows are for additional parity levels and they
require multiplications by arbitrary values that can be implemented
using the PSHUFB instruction.

The performance of triple parity with PSHUFB is comparable at an
alternate triple parity implementation with the third row of
coefficients set as powers of 2^-1. This alternate implementation is
likely the fastest possible for CPUs without PSHUFB or similar
instruction, but it has the limitation of not supporting beyond triple
parity.

The Cauchy matrix is instead working for any number of parities and
at the same time it's compatible with the existing first two parity
levels. As far as I know, this is a kind of new result, never
appeared in this list or somewhere else.

You can see more details, performance results and fast
implementations for up to six parity levels at:
https://sourceforge.net/p/snapraid/code/ci/master/tree/raid.c

This was developed as part of my hobby project SnapRAID,
downloadable with full source at:
http://snapraid.sourceforge.net/

Please let me know if you are interested in a potential Linux
integration. I can surely help on whatever is needed.

For reference, past discussions about triple parity in the
linux-raid list can be found at:

http://thread.gmane.org/gmane.linux.raid/34195
http://thread.gmane.org/gmane.linux.raid/37904

Ciao,
Andrea
