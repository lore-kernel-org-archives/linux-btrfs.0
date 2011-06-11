From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: cannot remove files: No space left on device
Date: Sun, 12 Jun 2011 01:32:37 +0200
Message-ID: <4DF3FB15.1040108@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to remove some files on a btrfs filesystem which has 26 GB free:

/dev/sdb4             336G  310G   26G  93% /mnt/btrfs


Unfortunately, removing some of the files fails, due to "No space left on device":

root@dom:/mnt/btrfs# rm -rfv postgresql-noindex
removed `postgresql-noindex/postgresql/8.4/main/base/16384/16508.6'
removed `postgresql-noindex/postgresql/8.4/main/base/16384/16508.7'
rm: cannot remove `postgresql-noindex/postgresql/8.4/main/base/16384/16508.8': No space left on device
removed `postgresql-noindex/postgresql/8.4/main/base/16384/16508.9'
removed `postgresql-noindex/postgresql/8.4/main/base/16384/16508_fsm'
removed `postgresql-noindex/postgresql/8.4/main/base/16384/16511'
removed `postgresql-noindex/postgresql/8.4/main/base/16384/16513'
removed `postgresql-noindex/postgresql/8.4/main/base/16384/16516'
removed `postgresql-noindex/postgresql/8.4/main/base/16384/16516_fsm'
removed `postgresql-noindex/postgresql/8.4/main/base/16384/16521'

This is a snapshot of a different directory (with some changes).

Is it expected? I'm running 2.6.39.1 kernel.

-- 
Tomasz Chmielewski
http://wpkg.org
