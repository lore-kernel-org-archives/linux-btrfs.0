From: Chris Mason <chris.mason@oracle.com>
Subject: Btrfs v0.14 Released
Date: Tue, 29 Apr 2008 16:01:32 -0400
Message-ID: <200804291601.32945.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Btrfs v0.14 is now available for download.  Please note the disk format has 
changed, and it is not compatible with older versions of Btrfs.

For downloads and documention, please see the Btrfs project page:

http://btrfs.wiki.kernel.org

The oss.oracle.com Btrfs project page will soon start redirecting here.

v0.14 has a few performance fixes and closes some races that could have 
allowed corrupted metadata in v0.13.  The major new feature is the ability to 
manage multiple devices under a single Btrfs mount.  Raid0, raid1 and raid10 
are supported.

Even for single device filesystems, metadata is now duplicated by default. 

Checksums are verified after reads finish and duplicate copies are used if the 
checksums don't match.

Multi-device design details can be found here:

http://btrfs.wiki.kernel.org/index.php/Multiple_Device_Support

And sample usage to create and add volumes can be found here:

http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices

I'm putting up some benchmarks of the new multi-device code as the runs 
finish:

http://btrfs.wiki.kernel.org/index.php/Multi-device_Benchmarks

Next up on the Btrfs todo list is finishing off the device removal and IO 
error handling code.  After that I'll add more fine grained locking to the 
btrees.

Thanks to everyone who has helped contribute to and test this release.

-chris
