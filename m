From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Data Deduplication with the help of an online filesystem check
Date: Mon, 27 Apr 2009 05:33:32 +0200
Message-ID: <20090427033331.GC17677@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I would like to know if it would be possible to implement the following
feature in btrfs:

Have an online filesystem check which accounts for possible duplicated
data blocks (maybe with the help of already implemented checksums: Are
these checksums for the whole file or block based?) and de duplicate
these blocks?

        Thomas
