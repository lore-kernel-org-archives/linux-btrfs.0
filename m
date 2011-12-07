From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Yet Another Newb Question...
Date: Wed, 07 Dec 2011 16:14:46 -0500
Message-ID: <bf38f96107f723d7471ad1d46a0403d7@www.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=fixed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

(Asking this question on this list kinda makes me wonder if there shouldn't be
a btrfs-users list where folks could ask questions just like this without
pestering developers...)

Anyway -- I had a root partition with a /snapshots directory, in which I placed
a bunch of snapshots.  At one point, I goofed stuff up, and decided to revert
my root (using "btrfs sub set-default") to one of the snapshots.  Rebooted, and
it worked great -- just like I'd hoped.

But where'd the snapshots in /snapshots go?

I mean, I still see them if I do a "btrfs sub list", but how do I *get* to them
for, say, deleting?  (I can still mount them via "-o subvolid", but that's not
quite the same thing.)

Suggestions?

Thanks kindly!

-Ken





