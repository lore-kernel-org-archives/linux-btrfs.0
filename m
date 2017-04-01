Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:58950 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751417AbdDALaU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 1 Apr 2017 07:30:20 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:59080)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cuHEX-000wzf-Bo
        for linux-btrfs@vger.kernel.org; Sat, 01 Apr 2017 12:30:17 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cuHET-0003AX-U0
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Apr 2017 12:30:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22751.36675.942455.136171@tree.ty.sabi.co.uk>
Date: Sat, 1 Apr 2017 12:30:11 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Shrinking a device - performance?
In-Reply-To: <CAP8EXU0TWqZZrDe6J0nRLEhgO7w2iUvSPh-H86JNPeYQqtA9fw@mail.gmail.com>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
        <43e29da2-1d1b-1680-f262-1c95575645d8@gmail.com>
        <22749.10893.729399.275210@tree.ty.sabi.co.uk>
        <d2f4af84-739e-d43c-0978-8bbe74e8a277@gmail.com>
        <22750.37100.788020.938846@tree.ty.sabi.co.uk>
        <CAP8EXU2cdtVP7+Qgy6mTJ1oqCmpW4JpaoUxAsf0RZ27WprvZ3g@mail.gmail.com>
        <22750.48060.805852.28370@tree.ty.sabi.co.uk>
        <CAP8EXU3YZLn1K6v8JLB_47Y1kVOb4uFgLmnn1Lr3iSsaHLkz6w@mail.gmail.com>
        <pan$581b5$d5a02cf0$e209a38b$95d5d134@cox.net>
        <CAP8EXU0TWqZZrDe6J0nRLEhgO7w2iUvSPh-H86JNPeYQqtA9fw@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

>>>   $  D='btrfs f2fs gfs2 hfsplus jfs nilfs2 reiserfs udf xfs'
>>>   $  find $D -name '*.ko' | xargs size | sed 's/^  *//;s/ .*\t//g'
>>>   text    filename
>>>   832719  btrfs/btrfs.ko
>>>   237952  f2fs/f2fs.ko
>>>   251805  gfs2/gfs2.ko
>>>   72731   hfsplus/hfsplus.ko
>>>   171623  jfs/jfs.ko
>>>   173540  nilfs2/nilfs2.ko
>>>   214655  reiserfs/reiserfs.ko
>>>   81628   udf/udf.ko
>>>   658637  xfs/xfs.ko

That was Linux AMD64.

> udf is 637K on Mac OS 10.6
> exfat is 75K on Mac OS 10.9
> msdosfs is 79K on Mac OS 10.9
> ntfs is 394K (That must be Paragon's ntfs for Mac)
...
> zfs is 1.7M (10.9)
> spl is 247K (10.9)

Similar on Linux AMD64 but smaller:

  $ size updates/dkms/*.ko | sed 's/^  *//;s/ .*\t//g'
  text    filename
  62005   updates/dkms/spl.ko
  184370  updates/dkms/splat.ko
  3879    updates/dkms/zavl.ko
  22688   updates/dkms/zcommon.ko
  1012212 updates/dkms/zfs.ko
  39874   updates/dkms/znvpair.ko
  18321   updates/dkms/zpios.ko
  319224  updates/dkms/zunicode.ko

> If they are somehow comparable even with the differences, 833K
> is not bad for btrfs compared to zfs. I did not look at the
> format of the file; it must be binary, but compression may be
> optional for third party kexts. So the kernel module sizes are
> large for both btrfs and zfs. Given the feature sets of both,
> is that surprising?

Not surprising and indeed I agree with the statement that
appeared earlier that "there are use cases that actually need
them". There are also use cases that need realtime translation
of file content from chinese to spanish, and one could add to
ZFS or Btrfs an extension to detect the language of text files
and invoke via HTTP Google Translate, for example with option
"translate=chinese-spanish" at mount time; or less flexibly
there are many use cases where B-Tree lookup of records in files
is useful, and it would be possible to add that to Btrfs or ZFS,
so that for example 'lseek(4,"Jane Smith",SEEK_KEY)' would be
possible, as in the ancient TSS/370 filesystem design.

But the question is about engineering, where best to implement
those "feature sets": in the kernel or higher levels. There is
no doubt for me that realtime language translation and seeking
by key can be added to a filesystem kernel module, and would
"work". The issue is a crudely technical one: "works" for an
engineer is not a binary state, but a statistical property over
a wide spectrum of cost/benefit tradeoffs.

Adding "feature sets" because "there are use cases that actually
need them" is fine, adding their implementation to the kernel
driver of a filesystem is quite a different proposition, which
may have downsides, as the implementations of those feature sets
may make code more complex and harder to understand and test,
never mind debug, even for the base features. But of course lots
of people know better :-).

Buit there is more; look again at some compiled code sizes as a
crude proxy for complexity, divided in two groups, both of
robust, full featured designs:

  1012212 updates/dkms/zfs.ko
  832719  btrfs/btrfs.ko
  658637  xfs/xfs.ko

  237952  f2fs/f2fs.ko
  173540  nilfs2/nilfs2.ko
  171623  jfs/jfs.ko
  81628   udf/udf.ko

The code size for JFS or NILFS2 or UDF is roughly 1/4 the code
size for XFS, yet there is little difference in functionality.
Compared to ZFS as to base functionality JFS lacks checksums and
snapshots (in theory it has subvolumes, but they are disabled),
but NILFS2 has snapshots and checksums (but does not verify them
on ordinary reads), and yet the code size is 1/6 that of ZFS.
ZFS has also RAID, but looking at the code size of the Linux MD
RAID modules I see rather smaller numbers. Even so ZFS has a
good reputation for reliability despire its amazing complexity,
but that is also because SUN invested big into massive release
engineering for it, and similarly for XFS.

Therefore my impression is that the filesystems in the first
group have a lot of cool features like compression or dedup
etc. that could have been implemented user-level, and having
them in the kernel is good "for "marketing" purposes, to win
box-ticking competitions".
