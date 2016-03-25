Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbcCYOAN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 10:00:13 -0400
Date: Fri, 25 Mar 2016 22:00:11 +0800
From: Eryu Guan <eguan@redhat.com>
To: Holger =?utf-8?Q?Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: add btrfs test for fsync after snapshot deletion
Message-ID: <20160325140011.GA11419@eguan.usersys.redhat.com>
References: <1458839241-12379-1-git-send-email-fdmanana@kernel.org>
 <20160325035306.GX11419@eguan.usersys.redhat.com>
 <56F527FC.9020007@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56F527FC.9020007@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2016 at 12:58:52PM +0100, Holger Hoffstätte wrote:
> On 03/25/16 04:53, Eryu Guan wrote:
> > Test fails on v4.5 kernel as expected, but I failed to compile btrfs
> > after applying this patch, seems btrfs_must_commit_transaction was not
> > defined anywhere (I did grep it through the kernel tree, nothing showed
> > up), did I miss anything?
> > 
> > fs/btrfs/tree-log.c: In function ‘check_parent_dirs_for_sync’:
> > fs/btrfs/tree-log.c:4836:4: error: implicit declaration of function ‘btrfs_must_commit_transaction’ [-Werror=implicit-function-declaration]
> >     if (btrfs_must_commit_transaction(trans, inode))
> >     ^
> > cc1: some warnings being treated as errors
> > make[1]: *** [fs/btrfs/tree-log.o] Error 1
> > make: *** [_module_fs/btrfs] Error 2
> 
> It was defined in a previous patch for 4.6:
> 
> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=for-linus-4.6&id=2be63d5ce929603d4e7cedabd9e992eb34a0ff95

I was testing against 4.5 kernel. Thanks for pointing it out, it
compiles now!

Thanks,
Eryu
