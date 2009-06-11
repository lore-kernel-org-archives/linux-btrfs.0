From: Michael Raskin <a0091f122@rambler.ru>
Subject: cleanup after a small data loss on incorrect shutdown.
Date: Thu, 11 Jun 2009 16:44:30 +0400
Message-ID: <4A30FC2E.3030804@rambler.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

	Hello.

	I am continuing my tests of BtrFS under a practical workload. Recently
an incorrect poweroff (or maybe a small bug in BtrFS) caused a small
data loss. The actual damage was non-existent.
	I used old branch, so maybe the relevant code is already improved.
	
	1. Why btrfsck says "bad block" on that partition? What does it mean?
My fist reaction was to use badblocks. It found no badblocks in its own
sense, so I assume btrfsck means something else. It would be nice to
explain that to user. Maybe "damaged FS data block" ?

	2. I found a file which is listed in the directory, but stat on it
returns "No such file or directory". Certainly, rm and unlink cannot
remove it. The partition has 14G in use. What can I do to provide a
useful piece of FS structure information? How can I remove the file
afterwards.
	
	3. On a 30G partition with 14G used btrfsck was left overnight. It has
neither finished nor printed any meaningful request for interaction. Is
it normal?

Michael Raskin
