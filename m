Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44977 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaEJWrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 18:47:55 -0400
Date: Sat, 10 May 2014 15:42:49 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, Filipe David Manana <fdmanana@gmail.com>
Subject: Re: 3.15-rc5 btrfs send/receive corruption errors?
Message-ID: <20140510224249.GA15909@merlins.org>
References: <20140510220710.GA6772@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140510220710.GA6772@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 10, 2014 at 03:07:10PM -0700, Marc MERLIN wrote:
> Howdy,
> 
> While moving data back to a brand new btrfs FS I had just created (with
> 3.14 tools and under 3.15), I got this:
> 
> legolas:/mnt/btrfs_pool2# for i in tmp_ro.20140507_09:00:31 root_ro.20140507_10:00:20 usr_ro.20140507_09:00:41 var_ro.20140507_09:00:58 home_ro.20140507_10:00:01; do btrfs send $i | btrfs receive /mnt/btrfs_pool1/; done
> At subvol tmp_ro.20140507_09:00:31
> At subvol tmp_ro.20140507_09:00:31
> At subvol root_ro.20140507_10:00:20
> At subvol root_ro.20140507_10:00:20
> At subvol usr_ro.20140507_09:00:41
> At subvol usr_ro.20140507_09:00:41
> At subvol var_ro.20140507_09:00:58
> At subvol var_ro.20140507_09:00:58
> ERROR: chown www/Q����Q��� failed. No such file or directory
> At subvol home_ro.20140507_10:00:01
> At subvol home_ro.20140507_10:00:01
> ERROR: chmod merlin/.config/google-chrome-mysetup/���� failed. No such file or directory
> legolas:/mnt/btrfs_pool2#
> 
> legolas:/mnt/btrfs_pool2/var_ro.20140507_09:00:58/www# ls
> shows no file that looks like Q^W^F^D����Q^W^F^D��� 
> 
> Same deal with merlin/.config/google-chrome-mysetup/
> 
> However, I see:
> legolas:/mnt/btrfs_pool1/home_ro.20140507_10:00:01# l
> total 16
> drwxr-xr-x 1 root   root    20 May 10 09:09 ./
> drwxr-xr-x 1 root   root   244 May 10 07:50 ../
> drwx------ 1 root   root     0 May 10 09:09 ?0$?/
> drwxr-xr-x 1 merlin merlin 198 May  7 06:21 merlin/
> => corruption

I tried with 3.14.3 and it went further, however it died with
legolas:/mnt/btrfs_pool2# btrfs send  home_ro.20140507_10:00:01 | btrfs receive /mnt/btrfs_pool1/
At subvol home_ro.20140507_10:00:01
At subvol home_ro.20140507_10:00:01
ERROR: send ioctl failed with -5: Input/output error
ERROR: unexpected EOF in stream.

I'll look up -5 later when I have time, but I guess there is a problem
on the source that is causing copies to fail with both kernels?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
