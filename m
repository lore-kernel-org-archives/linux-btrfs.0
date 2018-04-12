Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46095 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752432AbeDLOw6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Apr 2018 10:52:58 -0400
Date: Thu, 12 Apr 2018 16:50:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Sasha Levin <Alexander.Levin@microsoft.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix loss of prealloc extents past i_size after
 fsync log replay
Message-ID: <20180412145025.GM21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180405215512.513-1-fdmanana@kernel.org>
 <DM5PR2101MB103293C63B8465C6B91284C2FBBE0@DM5PR2101MB1032.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <DM5PR2101MB103293C63B8465C6B91284C2FBBE0@DM5PR2101MB1032.namprd21.prod.outlook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2018 at 01:50:21PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: c71bf099abdd Btrfs: Avoid orphan inodes cleanup while replaying log.
> 
> The bot has also determined it's probably a bug fixing patch. (score: 6.2138)
> 
> The bot has tested the following trees: v4.16.1, v4.15.16, v4.14.33, v4.9.93, v4.4.127.
> 
> v4.16.1: Build OK!
> v4.15.16: Build OK!
> v4.14.33: Build OK!
> v4.9.93: Build failed! Errors:
>     tree-log.c:2367:24: error: ‘struct btrfs_fs_info’ has no member named ‘sectorsize’
>     tree-log.c:2367:24: error: ‘struct btrfs_fs_info’ has no member named ‘sectorsize’
>     tree-log.c:4224:13: error: ‘struct inode’ has no member named ‘flags’; did you mean ‘i_flags’?
>     tree-log.c:4229:38: error: ‘struct inode’ has no member named ‘vfs_inode’
>     tree-log.c:4239:4: error: implicit declaration of function ‘refcount_inc’; did you mean ‘i_readcount_inc’? [-Werror=implicit-function-declaration]

4.9 and older would need manual fixes to the patch. There are a few
refactorings but that should be easy to resolve if somebody wants to
backport port that.

> 
> v4.4.127: Failed to apply! Possible dependencies:
>     0132761017e0 ("btrfs: fix string and comment grammatical issues and typos")
> 
> 
> --
> Thanks,
> Sasha????{.n?+???????+%?????ݶ??w??{.n?+????{???k~????^n?r???z???h?????&???z??z?ޗ?+??+zf???h???~????i?????????z_???j:+v???)ߣ?m
