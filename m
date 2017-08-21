Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38839 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753899AbdHURHW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 13:07:22 -0400
Date: Mon, 21 Aug 2017 19:05:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Doc: Fix asciidoc grammar of btrfs-rescue
Message-ID: <20170821170558.GQ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170821065704.12119-1-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170821065704.12119-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 03:57:04PM +0900, Qu Wenruo wrote:
> Code block of kernel backtrace lacks leading change line, causing the
> following man page result:
> ------
>            One can determine whether zero-log is needed according to the
>            kernel backtrace:
> 
>            ? replay_one_dir_item+0xb5/0xb5 [btrfs]
>            ? walk_log_tree+0x9c/0x19d [btrfs]
>            ? btrfs_read_fs_root_no_radix+0x169/0x1a1 [btrfs]
>            ? btrfs_recover_log_trees+0x195/0x29c [btrfs]
>            ? replay_one_dir_item+0xb5/0xb5 [btrfs]
>            ? btree_read_extent_buffer_pages+0x76/0xbc [btrfs]
>            ? open_ctree+0xff6/0x132c [btrfs]
> 
>        + If the errors are like above, then zero-log should be used to clear
>        the log and the filesystem may be mounted normally again. The keywords
> ------
> 
> Not only "+" is rendered as is, but also wrong indent.
> 
> Fix it by adding change line before code block.
> 
> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Applied, thanks.
