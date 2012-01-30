From: Marc MERLIN <marc@merlins.org>
Subject: brtfs on top of dmcrypt with SSD. No corruption iff write cache off?
Date: Sun, 29 Jan 2012 16:37:54 -0800
Message-ID: <20120130003754.GD4380@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Howdy,

I'm considering using brtfs for my new laptop install.

Encryption is however a requirement, and ecryptfs doesn't quite cut it for
me, so that leaves me with dmcrypt which is what I've been using with
ext3/ext4 for years.

https://btrfs.wiki.kernel.org/articles/g/o/t/Gotchas.html 
still states that 
'dm-crypt block devices require write-caching to be turned off on the
underlying HDD'
While the report was for 2.6.33, I'll assume it's still true.


I was considering migrating to a recent 256GB SSD and 3.2.x kernel.

First, I'd like to check if the 'turn off write cache' comment is still
accurate and if it does apply to SSDs too.

Second, I was wondering if anyone is running btrfs over dmcrypt on an SSD
and what the performance is like with write cache turned off (I'm actually
not too sure what the impact is for SSDs considering that writing to flash
can actually be slower than writing to a hard drive).

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
