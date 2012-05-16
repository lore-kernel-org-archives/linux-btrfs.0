Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65091 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab2EPRD4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 May 2012 13:03:56 -0400
Received: by bkcji2 with SMTP id ji2so824836bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2012 10:03:55 -0700 (PDT)
Message-ID: <1337187784.1525.6.camel@ierdnac-hp>
Subject: Re: [PATCH v3 0/3] Btrfs-progs: support get/reset device stats via
 ioctl
From: Andrei Popa <ierdnah@gmail.com>
Reply-To: ierdnah@gmail.com
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Date: Wed, 16 May 2012 20:03:04 +0300
In-Reply-To: <1337187058-560-1-git-send-email-sbehrens@giantdisaster.de>
References: <1337187058-560-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

It would be nice if this function could show the file names affected by
errors, in case of a single, non-redundant drive, btrfs-progs should
show what files are affected by errors.
Then, an admin could restore only those files from backup.

On Wed, 2012-05-16 at 18:50 +0200, Stefan Behrens wrote:
> "btrfs device stats" is used to retrieve and print the device stats.
> "btrfs device stats -z" is used to atomically retrieve, reset and
> print the stats.
> 
> In order to share two utility functions between scrub and the dev stats
> code, these two functions are moved to utils.c and renamed.
> Since these functions are using open_file_or_dir(), and since the linking
> against utils.o and common.o was different, open_file_or_dir() was moved
> from common.c to utils.c. And since that function makes use of the
> function dirfd(3), the required XOPEN version was raised from 6 to 7.
> 
> Changes v1->v2:
> - Remove a verbose printf()
> - Cast u64 to unsigned long long for printf()
> - Update the man page
> 
> Changes v2->v3:
> - Rebase on Chris' current master branch
> - Split the patch into three seperate patches because after rebasing,
>   open_file_or_dir() was moved and additional changes had been necessary
> 
> Stefan Behrens (3):
>   Btrfs-progs: move open_file_or_dir() to utils.c
>   Btrfs-progs: make two utility functions globally available
>   Btrfs-progs: add command to get/reset device stats via ioctl
> 
>  Makefile         |    4 +-
>  btrfsctl.c       |   28 --------------
>  cmds-balance.c   |    1 +
>  cmds-device.c    |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  cmds-inspect.c   |    1 +
>  cmds-scrub.c     |   72 +---------------------------------
>  cmds-subvolume.c |    1 +
>  commands.h       |    3 --
>  common.c         |   46 ----------------------
>  ctree.h          |    6 +++
>  ioctl.h          |   27 +++++++++++++
>  man/btrfs.8.in   |   14 +++++++
>  print-tree.c     |    6 +++
>  utils.c          |   97 +++++++++++++++++++++++++++++++++++++++++++++-
>  utils.h          |    7 ++++
>  15 files changed, 275 insertions(+), 151 deletions(-)
>  delete mode 100644 common.c
> 


