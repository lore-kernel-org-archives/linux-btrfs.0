From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Another checksum error bugreport
Date: Wed, 29 Sep 2010 12:48:56 +0200
Message-ID: <AANLkTi=vHyE+epYixXgu5ju_JfjWdU+xghL-PLo60ktu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey guys,

Today I experienced my first checksum error just out of the blue - and
it's not just the 'csum + 1 = private' issue, it's a completely
different one. Because of this, I am unable to retrieve the data off
the drive, even with nodatasum enabled - I simply get an I/O error.
Here's the dmesg output:

[149423.845177] btrfs: setting nodatasum
[149423.850339] Btrfs detected SSD devices, enabling SSD mode
[149432.094728] btrfs csum failed ino 259 off 26701824 csum 3875867041
private 371726550
[149432.117938] btrfs csum failed ino 259 off 26701824 csum 3875867041
private 371726550
[149432.118340] btrfs csum failed ino 259 off 26701824 csum 3875867041
private 371726550
[149432.125671] btrfs csum failed ino 259 off 26701824 csum 3875867041
private 371726550
[149432.126075] btrfs csum failed ino 259 off 26701824 csum 3875867041
private 371726550
[149432.135671] btrfs csum failed ino 259 off 26701824 csum 3875867041
private 371726550

I would really like to have the files on the drive retrieved in their
entirety, but if that is not possible then that is also OK. Consider
this a bugreport and a question on how to retrieve the data now.

Thanks,
Sebastian J.
