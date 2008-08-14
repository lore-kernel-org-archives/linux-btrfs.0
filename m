From: Stephen Hemminger <stephen.hemminger@vyatta.com>
Subject: btrfs day 1
Date: Thu, 14 Aug 2008 00:11:20 -0700
Message-ID: <20080814001120.4f1fea7a@speedy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Setup new 60G home partition on laptop as a real life test of 0.16.
Using Ubuntu standard kernel 2.6.24-19-generic on i386

I notice that during normal (busy time) everything seems fine, but after going away
for a while and coming back, it seems sluggish. Lots of errors in log:

 btrfs csum failed ino 139988 off 4583424 csum 3821684403 private 0
 btrfs csum failed ino 139988 off 4579328 csum 3233603900 private 0
 btrfs csum failed ino 139988 off 4575232 csum 306171610 private 0

Maybe it isn't handleing spindown properly? or something like that?
