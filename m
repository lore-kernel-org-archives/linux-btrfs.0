From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: cannot resize (grow) fs
Date: Fri, 24 Sep 2010 05:41:10 +0000 (UTC)
Message-ID: <i7hdlm$13j$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I added disk to raid5 array on one of the backup hosts, running btrfs.

So on /dev/md2 I have plenty of space now.

However when I run

btrfs filesystem resize max  /dev/md2

I get 

Resize '/dev/md2' of 'max'
ERROR: unable to resize '/dev/md2'

The same result when I try resize +1g.

strace gives me http://paste.pocoo.org/show/266523/

Any ideas why and how can I extend the filesystem to fill the whole
volume?

Thank you

Lubos

