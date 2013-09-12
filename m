Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:42886 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab3ILUiv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 16:38:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130912153629.16487.88969@localhost.localdomain>
References: <20130912153629.16487.88969@localhost.localdomain>
Date: Thu, 12 Sep 2013 16:38:50 -0400
Message-ID: <CA+5PVA5GogJnewWvdmVo03oZRZDerE=H7BR49Xi1DZQyE_CG4Q@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Chris Mason <chris.mason@fusionio.com>, Mark Fasheh <mfasheh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 12, 2013 at 11:36 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> Mark Fasheh (4):
>       btrfs: offline dedupe

This commit adds calls to __put_user_unaligned, which causes build
failures on ARM if btrfs is configured:

+ make -s ARCH=arm V=1 -j4 modules
fs/btrfs/ioctl.c: In function 'btrfs_ioctl_file_extent_same':
fs/btrfs/ioctl.c:2802:3: error: implicit declaration of function
'__put_user_unaligned' [-Werror=implicit-function-declaration]
   if (__put_user_unaligned(info.status, &args->info[i].status) ||
   ^
cc1: some warnings being treated as errors
make[2]: *** [fs/btrfs/ioctl.o] Error 1
make[1]: *** [fs/btrfs] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [fs] Error 2
make: *** Waiting for unfinished jobs....

josh
