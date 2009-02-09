From: Gregory Maxwell <gmaxwell@gmail.com>
Subject: Compressor options and speed vs size tradeoff.
Date: Mon, 9 Feb 2009 03:23:31 -0500
Message-ID: <e692861c0902090023v42104857p47058f13829686be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I ran across an interesting page which reviews the performance of a
number of compressors which are already available for the Linux Kernel
(zlib, lzop, lzma) and which shows the highest performing compressor
choice given the authors test CPU for a variety of data transfer
rates, and read vs write ratio.

http://users.elis.ugent.be/~wheirman/compression/


It shows that for normal disk speeds (i.e. >200mbit/sec) LZOP of some
flavor will yield the greatest performance.

(LZMA, however, has considerably greater space savings; but isn't
likely to increase overall performance with normal disk)
