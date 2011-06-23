From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Using compression on SSD
Date: Thu, 23 Jun 2011 10:31:43 +0200
Message-ID: <201106231031.43579.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I scanned for relevant topics in the last two years but except for putt=
ing=20
a swap file on compress=3Dlzo this march I didn=B4t found anything.

Does compression make sense on SSD? Or more specifically:

1) In what chunk sizes does BTRFS compress? How much data is affected w=
hen=20
a byte is changed in a 2 GB file or so? Can compression cause more writ=
es=20
to the SSD in extreme circumstances?

2) It also seems to depend on the SSD. I found mention that the SandFor=
ce=20
controller does on-thy-fly compression under the hood and that compress=
ing=20
the files in Linux could cause more harm than good then[1].

3) Finally would zlib or lzo compression be better? I bet that at least=
=20
mostly depends on the CPU speed.


My current conclusion for the root filesystem on the Intel SSD 320 300 =
GB=20
on a ThinkPad T520 with Intel i5 Dual Core Sandybridge is this:

Use compression, since

1) The Intel SSD 320 is said not to use internal compression.[2]

2) In the root filesystem files are mostly either completely rewritten =
on=20
upgrades. That log files for example are also regulary appended to and =
here=20
it depends whether the chunk sizes for compression does not exceed the=20
erase block size.

I am not sure on lzo version zlib, but would tend to lzo to have minima=
l=20
CPU usage and probably less frequency upscaling.

On /home I still use Ext4 until the full featured fsck becomes availabl=
e.

What are your oppinions?


[1] http://www.techenclave.com/open-source-and-linux/ssds-and-btrfs-mat=
ch-
made-heaven-183940.html

[2] http://www.anandtech.com/show/4244/intel-ssd-320-review

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
