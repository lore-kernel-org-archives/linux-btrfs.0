From: Christian Hesse <mail@earthworm.de>
Subject: sysreccd with btrfs support
Date: Sun, 18 Jan 2009 17:48:10 +0100
Message-ID: <200901181748.13203.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: =?iso-8859-1?q?Fran=E7ois_Dupoux?= <fd@dupoux.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,

we have a live cd with up to date btrfs support now! I mailed Francois and 
prepared some packages, he included it in the beta6 of his sysreccd. So go 
and get it:
http://sysresccd.org/Beta-x86

Thanks a lot to Francois for his work!

If anybody is interested in testing btrfs with kernels other than 2.6.29-rc 
take a look at my tarball:
http://www.eworm.de/tmp/btrfs-0.18.tar.bz2

This is v0.17 with these additions:
* the two commits included in kernel 2.6.29-rc2
* the compat code needed to compile on older kernels (so you can use this one 
with 2.6.27 for example) 
-- 
Regards,
Chris
