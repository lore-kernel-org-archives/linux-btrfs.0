Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30380 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752095AbbFIHRb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 03:17:31 -0400
Message-ID: <55769308.1070803@cn.fujitsu.com>
Date: Tue, 9 Jun 2015 15:17:28 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <clm@fb.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Send fixes for 4.2
References: <1433301319-515-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1433301319-515-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris and Filipe.

Would you consider the patch from Filipe to be merged into 4.2?

[PATCH] Btrfs: avoid syncing log in the fast fsync path when not necessary

https://patchwork.kernel.org/patch/6138811/


The performance regression is already in 4.1, and I really don't like to
see the performance regression be there for 4.2.

So please consider include this patch in 4.2 merge window.

Thanks,
Qu

> Hi Chris,
>
> Please pull 2 fixes for the send feature from my branch send_fixes_4.2.
> Both have been around in the mailing list/patchwork before the 4.1 merge
> window opened but were not picked for 4.1. They both have tests merged
> in xfstests (btrfs/087 and btrfs/092), which as expected, fail without
> this fixes applied and pass with them applied.
>
> The following changes since commit c65b99f046843d2455aa231747b5a07a999a9f3d:
>
>    Linux 4.1-rc6 (2015-05-31 19:01:07 -0700)
>
> are available in the git repository at:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git send_fixes_4.2
>
> for you to fetch changes up to 8b191a684968e24b34c9894024b37532c68e6ae8:
>
>    Btrfs: incremental send, check if orphanized dir inode needs delayed rename (2015-06-03 03:10:40 +0100)
>
> ----------------------------------------------------------------
> Filipe Manana (2):
>        Btrfs: incremental send, don't delay directory renames unnecessarily
>        Btrfs: incremental send, check if orphanized dir inode needs delayed rename
>
>   fs/btrfs/send.c | 104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
>   1 file changed, 83 insertions(+), 21 deletions(-)
>
