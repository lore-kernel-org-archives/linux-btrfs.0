From: Bron Gondwana <brong@fastmail.fm>
Subject: Poor performance unlinking hard-linked files (repost)
Date: Tue, 16 Nov 2010 23:54:45 +1100
Message-ID: <20101116125445.GA3229@brong.net>
References: <1289618724.28645.1405062363@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Bron Gondwana <brong@fastmail.fm>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289618724.28645.1405062363@webmail.messagingengine.com>
List-ID: <linux-btrfs.vger.kernel.org>

Just posting this again more neatly formatted and just the
'meat':

a) program creates piles of small temporary files, hard
   links them out to different directories, unlinks the
   originals.

b) filesystem size: ~ 300Gb (backed by hardware RAID5)

c) as the filesystem grows (currently about 30% full) 
   the unlink performance becomes horrible.  Watching
   iostat, there's a lot of reading going on as well.

Is this expected?  Is there anything we can do about it?
(short of rewrite Cyrus replication)

Thanks,

Bron.
