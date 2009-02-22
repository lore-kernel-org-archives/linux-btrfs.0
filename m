From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: SSDs and filesystem alignment...
Date: Sun, 22 Feb 2009 14:31:37 +0000
Message-ID: <6278d2220902220631r3d89fbcbgc3eef9570c452df3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Does BTRFS perform any journal and/or filesystem structure alignment
(for benefit to SSD longevity and SSD, RAID array and large-sector
device performance) at present?

ext4's Ted Tso will deliver 128KB alignment with the next release of
e2fsprogs (ie 1.41.4) [1], so perhaps it's a good idea for btrfsprogs
also, if not already available?

Daniel

--- [1]
http://thunk.org/tytso/blog/2009/02/20/aligning-filesystems-to-an-ssds-erase-block-size/
-- 
Daniel J Blueman
