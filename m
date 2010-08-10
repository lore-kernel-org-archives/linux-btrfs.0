From: Jason Switzer <jswitzer@gmail.com>
Subject: Recover Corruption - verify_parent_transid
Date: Mon, 9 Aug 2010 21:43:05 -0500
Message-ID: <AANLkTimyd55iDWhqk3j2d1k_r+AhDCjOAL2+4=Gdiss4@mail.gmail.com>
References: <AANLkTi=ni92UexMf1xB7ODY3R0Om3K9LmaA_4967knRL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=ni92UexMf1xB7ODY3R0Om3K9LmaA_4967knRL@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs partition that is failing to mount and I was hoping I
could recover it somehow.
Mount returns immediately with a bad superblock error:

mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
=A0=A0 =A0 =A0 missing codepage or helper program, or other error
=A0=A0 =A0 =A0 In some cases useful info is found in syslog - try
=A0=A0 =A0 =A0 dmesg | tail =A0or so

Looking in the syslog, we see the following errors:

[ 4328.614123] device fsid d4838bde94c38c2-ac2179bda6fc3b8b devid 1
transid 1133 /dev/sdb1
[ 4328.618807] parent transid verify failed on 117069225984 wanted
1133 found 812
[ 4328.619570] parent transid verify failed on 117069225984 wanted
1133 found 812
[ 4328.619928] parent transid verify failed on 117069225984 wanted
1133 found 812
[ 4328.621323] btrfs: open_ctree failed

These are the same errors that btrfsck returns, which I learned in
retrospect will not fix errors. Here is what btrfs-show returns:

Label: none =A0uuid: c2384ce9-bd38-480d-8b3b-fca6bd7921ac
          Total devices 1 FS bytes used 82.52GB
          devid =A0 =A01 size 1.82TB used 112.04GB path /dev/sdb1

Btrfs Btrfs v0.19

This system is running the following kernel:

$ uname -a
Linux erebus 2.6.32-gentoo-r7 #7 Sun May 30 21:33:03 CDT 2010 i686
Pentium III (Coppermine) GenuineIntel GNU/Linux

The system was busy copying files to the partition when it died due to
a power failure. The partition/device was not renamed between reboots.
The partition is a 2TB partition (big media drive), so if I have to
lose the data associated with the errors, I'd be okay with that
(rollback the transaction for that object or just remove the data
outright).

-Jason "s1n" Switzer
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
