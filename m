From: Jon Nelson <jnelson@jamponi.net>
Subject: weird ENOSPC with defragment directory
Date: Mon, 16 Aug 2010 22:15:52 -0500
Message-ID: <AANLkTikgGCOfZo1A-R6bX+XXcAfCz48SDwX_0yhvUeJx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Most other directories on /var/cache, *except* those created by squid,
can be defragmented.
The filesystem was converted from ext3/4.

turnip:~ # uname -a
Linux turnip 2.6.34-12-default #1 SMP 2010-06-29 02:39:08 +0200 x86_64
x86_64 x86_64 GNU/Linux

(stock openSUSE 11.3 kernel)

turnip:~ btrfsctl -d /var/cache/squid/01/93
ioctl:: No space left on device
turnip:~ # find !$
find /var/cache/squid/01/93
/var/cache/squid/01/93
/var/cache/squid/01/93/00019321
/var/cache/squid/01/93/00019378
turnip:~ # ls -la !$
ls -la /var/cache/squid/01/93
total 2
drwxr-x--- 1 squid nogroup   32 Aug 13 17:13 .
drwxr-x--- 1 squid nogroup 1024 Jun  4 18:35 ..
-rw-r----- 1 squid nogroup 1777 Jul 13 22:31 00019321
-rw-r----- 1 squid nogroup  537 Jul 13 22:31 00019378
turnip:~ #

That seems... strange.

-- 
Jon
