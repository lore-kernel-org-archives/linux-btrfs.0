From: Tomas Thiemel <tomas.thiemel@tieto.com>
Subject: RE: btrfs balance failed and kernel oops'd
Date: Thu, 29 Apr 2010 10:41:24 +0200
Message-ID: <201004291041.24662.tomas.thiemel@tieto.com>
Reply-To: tomas.thiemel@tieto.com
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: yoosty69@netzero.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Justin,
I use Gentoo and I had Kernel OOPS, too (with 2.6.33), until I upgraded to the 
lastest "not stable" kernel - 2.6.34-rc5. Now (almost) everything works OK. I 
also had to re-format partition because there is one small problem:
When you add disk (in single mode) and then you "rebalance" partition, it 
changes data mode from "single" to RAID0 so you cannot remove added disk any 
more :-(

I also use latest unstable btrfs-progs (Btrfs v0.19-16-g075587c-dirty) to 
enable "all the bells and whistles".

Tomas Thiemel
