From: jim owens <owens6336@gmail.com>
Subject: [RFC 0/2] removing hard coded 512 byte size from direct I/O.
Date: Fri, 05 Mar 2010 14:42:12 -0500
Message-ID: <4B915E94.9090602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The following patches add the field for tracking the smallest
device block size in the filesystem and using it instead of
the hard coded 512 byte values in dio.c.

I also implemented a simpler test for user misalignment on
devices with larger block sizes.

It passes fsx, but I have not tested mixed device block sizes
or user vector edge cases.  If this code is acceptable, I'll
do edge tests before I send the merged V3 dio.c.

jim
