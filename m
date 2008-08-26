From: seriv@parkheights.dyndns.org
Subject: 1 of 2 fetures I like in zfs
Date: Tue, 26 Aug 2008 11:55:35 -0400 (EDT)
Message-ID: <966396367.791219766135858.JavaMail.root@parkheights.dyndns.org>
References: <744323790.671219733451692.JavaMail.root@parkheights.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <744323790.671219733451692.JavaMail.root@parkheights.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I've tried btrfs from stable mercurial repository, and I'd like to thank for one of 2 zfs features I missed in linux.
Now I can make snapshot before doing something risky and revert back to the snapshot if needed. Easily and quickly.
I can mount this snapshot on the mountpoint where the original filesystem was mounted. 
One question: can I make this snapshot to have name 'default', replacing what was 'default' and screwed so that I've decided to rollback to the snapshot?

But one of the features I don't see and I don't see any plan to implement it is incremental snapshots. Example: I have btrfs volume on some computer and have created snapshot and have sent it to another computer as a backup. Then, the next day, after some files are changed/deleted/created, and snaphot differ from the active volume by some percent of blocks, I want to have it sent to another computer as incremental backup. Zfs can send only the blocks changed, no need to scan and compare all the files. If btrfs has this feature, then I would consider replacing solaris on many of our systems by linux with btrfs.

-- 
  Sergey Ivanov.
