Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44754 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaEJWHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 18:07:14 -0400
Date: Sat, 10 May 2014 15:07:10 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Filipe David Manana <fdmanana@gmail.com>
Subject: 3.15-rc5 btrfs send/receive corruption errors?
Message-ID: <20140510220710.GA6772@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Howdy,

While moving data back to a brand new btrfs FS I had just created (with
3.14 tools and under 3.15), I got this:

legolas:/mnt/btrfs_pool2# for i in tmp_ro.20140507_09:00:31 root_ro.20140507_10:00:20 usr_ro.20140507_09:00:41 var_ro.20140507_09:00:58 home_ro.20140507_10:00:01; do btrfs send $i | btrfs receive /mnt/btrfs_pool1/; done
At subvol tmp_ro.20140507_09:00:31
At subvol tmp_ro.20140507_09:00:31
At subvol root_ro.20140507_10:00:20
At subvol root_ro.20140507_10:00:20
At subvol usr_ro.20140507_09:00:41
At subvol usr_ro.20140507_09:00:41
At subvol var_ro.20140507_09:00:58
At subvol var_ro.20140507_09:00:58
ERROR: chown www/Q����Q��� failed. No such file or directory
At subvol home_ro.20140507_10:00:01
At subvol home_ro.20140507_10:00:01
ERROR: chmod merlin/.config/google-chrome-mysetup/���� failed. No such file or directory
legolas:/mnt/btrfs_pool2#

legolas:/mnt/btrfs_pool2/var_ro.20140507_09:00:58/www# ls
shows no file that looks like Q^W^F^D����Q^W^F^D��� 

Same deal with merlin/.config/google-chrome-mysetup/

However, I see:
legolas:/mnt/btrfs_pool1/home_ro.20140507_10:00:01# l
total 16
drwxr-xr-x 1 root   root    20 May 10 09:09 ./
drwxr-xr-x 1 root   root   244 May 10 07:50 ../
drwx------ 1 root   root     0 May 10 09:09 ?0$?/
drwxr-xr-x 1 merlin merlin 198 May  7 06:21 merlin/
=> corruption

and
legolas:/mnt/btrfs_pool1/var_ro.20140507_09:00:58# l
total 24
(...)
drwx------ 1 root root  276 May 10 09:07 o1346374-23116-0/
drwx------ 1 root root   38 May 10 09:07 o671296-2268-0/
drwx------ 1 root root   48 May 10 09:07 o676276-2269-0/
drwx------ 1 root root   24 May 10 09:07 o676661-2269-0/
drwx------ 1 root root   72 May 10 09:07 o677466-2270-0/
drwx------ 1 root root  278 May 10 09:07 o718029-2271-0/
drwx------ 1 root root   96 May 10 09:07 o952662-7468-0/
drwxr-xr-x 1 root root    0 Jan 29  2012 opt/
drwx------ 1 root root    0 May 10 09:08 ?Q???????Q???????Q???????/
=> corruption too

I could believe that btrfs has an issue on the source drive, but 
ls -l looks clean on the source, and clearly looks corrupted on the
destination after send/receive.

Any clues?

I'll try reverting to 3.14 if I have enough time this morning to see
if the error happens again.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
