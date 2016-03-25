Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:34501 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbcCYL6z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 07:58:55 -0400
Subject: Re: [PATCH] fstests: add btrfs test for fsync after snapshot deletion
To: Eryu Guan <eguan@redhat.com>
References: <1458839241-12379-1-git-send-email-fdmanana@kernel.org>
 <20160325035306.GX11419@eguan.usersys.redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56F527FC.9020007@googlemail.com>
Date: Fri, 25 Mar 2016 12:58:52 +0100
MIME-Version: 1.0
In-Reply-To: <20160325035306.GX11419@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/25/16 04:53, Eryu Guan wrote:
> Test fails on v4.5 kernel as expected, but I failed to compile btrfs
> after applying this patch, seems btrfs_must_commit_transaction was not
> defined anywhere (I did grep it through the kernel tree, nothing showed
> up), did I miss anything?
> 
> fs/btrfs/tree-log.c: In function ‘check_parent_dirs_for_sync’:
> fs/btrfs/tree-log.c:4836:4: error: implicit declaration of function ‘btrfs_must_commit_transaction’ [-Werror=implicit-function-declaration]
>     if (btrfs_must_commit_transaction(trans, inode))
>     ^
> cc1: some warnings being treated as errors
> make[1]: *** [fs/btrfs/tree-log.o] Error 1
> make: *** [_module_fs/btrfs] Error 2

It was defined in a previous patch for 4.6:

https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=for-linus-4.6&id=2be63d5ce929603d4e7cedabd9e992eb34a0ff95

-h

