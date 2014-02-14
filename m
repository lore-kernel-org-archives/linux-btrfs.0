Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36349 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751630AbaBNEsJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 23:48:09 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: errors 400, nbytes wrong, was: Help repairing corrupt btrfs -- btrfsck --repair doesn't change anything
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAKCAbMjTHxCQ_rHa2+jV6eEGAGLhYeTWf-9a9y9gp6knzw-xcg@mail.gmail.com>
Date: Thu, 13 Feb 2014 21:48:05 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <0CB1F05D-28F2-4497-A5F9-F9F84FA4712B@colorremedies.com>
References: <CAKCAbMjTHxCQ_rHa2+jV6eEGAGLhYeTWf-9a9y9gp6knzw-xcg@mail.gmail.com>
To: Zack Weinberg <zackw@panix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 9, 2014, at 3:47 PM, Zack Weinberg <zackw@panix.com> wrote:

> I have a btrfs partition with what *sounds* like minor damage; btrfsck
> --repair prints

For what it's worth, repair occasionally makes things worse so it's better to just run 'btrfs check' and post the results and get some advice before resorting to --repair.

> 
> | enabling repair mode
> | Checking filesystem on /dev/sda
> | UUID: ec93d2c2-7937-40f8-aaa6-
> c20c9775d93a
> | checking extents
> | checking free space cache
> | cache and super generation don't match, space cache will be invalidated
> | checking fs roots
> | root 258 inode 4493802 errors 400, nbytes wrong
> | root 258 inode 4509858 errors 400, nbytes wrong
> | root 258 inode 4510014 errors 400, nbytes wrong
> | root 258 inode 4838894 errors 400, nbytes wrong
> | root 258 inode 4838895 errors 400, nbytes wrong
> | found 41852229430 bytes used err is 1
> | total csum bytes: 619630328
> | total tree bytes: 3216027648
> | total fs tree bytes: 2342981632
> | total extent tree bytes: 135536640
> | btree space waste bytes: 767795634
> | file data blocks allocated: 1744289230848
> |  referenced 631766474752
> | Btrfs v3.12

I think this is benign, but I'm not sure. I have three Btrfs file systems and one of them also has these same kinds of errors. In some cases mounting with clear_cache option and leaving the system alone to rebuild the space cache will fix it. In my case it's not.

I also get only the normal messages when mounting this Btrfs volume, no errors. And no apparent problems. So the btrfs check is a bit confusing that it says there are errors but then apparently doesn't fix them.

# btrfs check /dev/sdc
Checking filesystem on /dev/sdc
UUID: e7cd9159-9c4e-4ddd-9887-85758dbc97af
checking extents
checking free space cache
checking fs roots
root 256 inode 37895 errors 400, nbytes wrong
root 266 inode 37895 errors 400, nbytes wrong
found 1201615306 bytes used err is 1
total csum bytes: 4344024
total tree bytes: 328122368
total fs tree bytes: 306774016
total extent tree bytes: 15695872
btree space waste bytes: 61398268
file data blocks allocated: 9117638656
 referenced 9929928704
Btrfs v3.12

The file system was created with kernel 3.11.10 running, and has variably had 3.12.x, 3.13.x, and 3.14-rc2 running and the results are the same. I'm not sure when these errors first started as I don't often run btrfs check, but it's quite a young file system, maybe only two weeks old. There have been some unclean shutdowns, with the only reported mount errors being about unlinked orphans but those messages didn't occur again on subsequent mounts.

In any case, I'm confused also if there's a real problem or not. I guess confusion about the state of a file system itself isn't good. But I figure it's probably not a serious error or there'd be mount error messages, and would maybe only mount ro.

Chris Murphy