From: Danny Piccirillo <danny.piccirillo@member.fsf.org>
Subject: Fractal Tree Indexing over B-Trees?
Date: Wed, 28 Mar 2012 14:25:39 +0000 (UTC)
Message-ID: <loom.20120328T160525-464@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The case has been made on Phoronix for F-Trees: They makes use hard
drive speeds, not (relatively slow) access times; beat SSD's; and scale 
perfectly across multiple cores with hundreds of millions of entries.

http://en.wikipedia.org/wiki/TokuDB#Fractal_tree_indexes

How TokuDB Fractal Tree Databases Work

Via: http://www.phoronix.com/scan.php?page=news_item&px=MTA3NjM

Time for someone to get started on ftrfs? Or can it be implemented 
in Btrfs? 
https://bugzilla.kernel.org/show_bug.cgi?id=43004

