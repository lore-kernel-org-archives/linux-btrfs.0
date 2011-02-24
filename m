From: "A. James Lewis" <james@fsck.co.uk>
Subject: subvolid=0, ls hangs.
Date: Thu, 24 Feb 2011 10:20:28 +0000
Message-ID: <1298542828.4315.474.camel@cheyenne>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been running BTRFS for a while testing out various stuff, and I've
found it to be quite stable (although reading this list makes me realize
how much activity there really is).. I just hit my first bump in the
road, and I wondered if someone could give me a hint how I can gather
enough information to be useful here.

Basically, the filesystem I'm running is a 2 disk stripe, with mirrored
metadata.. I have default subvolume set, and I'm using 2 subvolumes.  I
have created a few snapshots of those subvolumes by mounting with -o
subvolid=0 and creating snapshots of the mounted subvolumes.

Recently (I think it started when I updated from .38rc1 to .38rc5 but
that could be coincidental)... when I mount subvolid=0, if I do a 'ls'
of that mount point, the filesystem hangs, and the system becomes
unusable.  Otherwise mounting and using the subvolumes is not affected.
At one point I got a Segfault from ls, but I've not been able to repeat
that.

Any suggestions would be interesting... I tried updating to rc6, but as
expected, (since there didn't seem to be much in the way of BTRFS
changes in that release) not much difference.

James.


