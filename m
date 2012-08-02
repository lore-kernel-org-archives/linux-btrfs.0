Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61269 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2HBKJH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 06:09:07 -0400
Received: by yhmm54 with SMTP id m54so8486849yhm.19
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2012 03:09:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB9VWqBk9CMHhJKq1rOeDXwDmoEVW7LiLCdbb+rbxmM--LOUKA@mail.gmail.com>
References: <CAB9VWqBk9CMHhJKq1rOeDXwDmoEVW7LiLCdbb+rbxmM--LOUKA@mail.gmail.com>
Date: Thu, 2 Aug 2012 12:09:06 +0200
Message-ID: <CAB9VWqC0xF5za8N_jwmEpf_WZjdORarYyCfbCQpaJ-9WO5J_kA@mail.gmail.com>
Subject: Re: Btrfs send/receive fixes and PULL request
From: Alexander Block <ablock84@googlemail.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 2, 2012 at 11:55 AM, Alexander Block
<ablock84@googlemail.com> wrote:
> Hello Chris,
>
> You can find and pull a lot of fixes for btrfs send/receive in my git repo:
>
>         git://github.com/ablock84/linux-btrfs.git for-chris
>
> These fixes are mostly the results of the reviews from Arne and Alex
> that I got here on the list. I'm not posting the patches to the list
> at the moment as they got quite a lot (23 patches). If anyone thinks I
> should still post them, please tell me. The branch is based on current
> master of Linus repo. As I already announced, I won't have time to
> work on btrfs starting from now.
>
> Alex.
>
> ----------------------------------------------------------------
> Alexander Block (23):
>       Btrfs: add rdev to get_inode_info in send/receive
>       Btrfs: fix cur_ino < parent_ino case for send/receive
>       Btrfs: add missing check for dir != tmp_dir to is_first_ref
>       Btrfs: remove unused code with #if 0
>       Btrfs: add correct parent to check_dirs when dir got moved
>       Btrfs: remove unused use_list from send/receive code
>       Btrfs: rename backref_ctx::found_in_send_root to found_itself
>       Btrfs: use kmalloc instead of stack for backref_ctx
>       Btrfs: use normal return path for root == send_root case
>       Btrfs: don't break in the final loop of find_extent_clone
>       Btrfs: fix memory leak for name_cache in send/receive
>       Btrfs: fix use of radix_tree for name_cache in send/receive
>       Btrfs: make aux field of ulist 64 bit
>       Btrfs: update send_progress at correct places
>       Btrfs: add/fix comments/documentation for send/receive
>       Btrfs: code cleanups for send/receive
>       Btrfs: remove unused tmp_path from iterate_dir_item
>       Btrfs: free nce and nce_head on error in name_cache_insert
>       Btrfs: fix check for changed extent in is_extent_unchanged
>       Btrfs: use <= instead of < in is_extent_unchanged
>       Btrfs: pass root instead of parent_root to iterate_inode_ref
>       Btrfs: ignore non-FS inodes for send/receive
>       Btrfs: don't treat top/root directory inode as deleted/reused
>
> Dan Carpenter (1):
>       Btrfs: fix some endian bugs handling the root times
>
>  fs/btrfs/backref.c     |    8 +-
>  fs/btrfs/ioctl.c       |    2 +-
>  fs/btrfs/qgroup.c      |   20 +-
>  fs/btrfs/root-tree.c   |    4 +-
>  fs/btrfs/send.c        |  851 ++++++++++++++++++++++++++----------------------
>  fs/btrfs/transaction.c |    2 +-
>  fs/btrfs/ulist.c       |    7 +-
>  fs/btrfs/ulist.h       |    9 +-
>  8 files changed, 483 insertions(+), 420 deletions(-)

I forgot to write where to find the btrfs-progs fixes:
        git://github.com/ablock84/btrfs-progs.git for-chris
