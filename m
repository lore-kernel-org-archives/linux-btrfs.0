Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44191 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752221AbaEKAHX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 20:07:23 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: 3.15-rc5 btrfs send/receive corruption errors?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140510224249.GA15909@merlins.org>
Date: Sat, 10 May 2014 18:06:46 -0600
Message-Id: <D55BDA6A-5DFA-4981-AC69-3156317ED169@colorremedies.com>
References: <20140510220710.GA6772@merlins.org> <20140510224249.GA15909@merlins.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 10, 2014, at 4:42 PM, Marc MERLIN <marc@merlins.org> wrote:

> On Sat, May 10, 2014 at 03:07:10PM -0700, Marc MERLIN wrote:
>> Howdy,
>> 
>> While moving data back to a brand new btrfs FS I had just created (with
>> 3.14 tools and under 3.15), I got this:
>> 
>> legolas:/mnt/btrfs_pool2# for i in tmp_ro.20140507_09:00:31 root_ro.20140507_10:00:20 usr_ro.20140507_09:00:41 var_ro.20140507_09:00:58 home_ro.20140507_10:00:01; do btrfs send $i | btrfs receive /mnt/btrfs_pool1/; done
>> At subvol tmp_ro.20140507_09:00:31
>> At subvol tmp_ro.20140507_09:00:31
>> At subvol root_ro.20140507_10:00:20
>> At subvol root_ro.20140507_10:00:20
>> At subvol usr_ro.20140507_09:00:41
>> At subvol usr_ro.20140507_09:00:41
>> At subvol var_ro.20140507_09:00:58
>> At subvol var_ro.20140507_09:00:58
>> ERROR: chown www/Q����Q��� failed. No such file or directory
>> At subvol home_ro.20140507_10:00:01
>> At subvol home_ro.20140507_10:00:01
>> ERROR: chmod merlin/.config/google-chrome-mysetup/���� failed. No such file or directory
>> legolas:/mnt/btrfs_pool2#
>> 
>> legolas:/mnt/btrfs_pool2/var_ro.20140507_09:00:58/www# ls
>> shows no file that looks like Q^W^F^D����Q^W^F^D��� 
>> 
>> Same deal with merlin/.config/google-chrome-mysetup/
>> 
>> However, I see:
>> legolas:/mnt/btrfs_pool1/home_ro.20140507_10:00:01# l
>> total 16
>> drwxr-xr-x 1 root   root    20 May 10 09:09 ./
>> drwxr-xr-x 1 root   root   244 May 10 07:50 ../
>> drwx------ 1 root   root     0 May 10 09:09 ?0$?/
>> drwxr-xr-x 1 merlin merlin 198 May  7 06:21 merlin/
>> => corruption
> 
> I tried with 3.14.3 and it went further, however it died with
> legolas:/mnt/btrfs_pool2# btrfs send  home_ro.20140507_10:00:01 | btrfs receive /mnt/btrfs_pool1/
> At subvol home_ro.20140507_10:00:01
> At subvol home_ro.20140507_10:00:01
> ERROR: send ioctl failed with -5: Input/output error
> ERROR: unexpected EOF in stream.
> 
> I'll look up -5 later when I have time, but I guess there is a problem
> on the source that is causing copies to fail with both kernels?\

I think the issue might be there are still problems and changing code on the receive side (btrfs-progs). The kernel side code responsible for send is probably working correctly.


Chris Murphy