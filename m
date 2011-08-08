From: Andy Lutomirski <luto@MIT.EDU>
Subject: Re: [PATCH] Btrfs: fix an oops of log replay
Date: Mon, 08 Aug 2011 11:13:06 -0400
Message-ID: <4E3FFD02.6010000@mit.edu>
References: <1312619723-31094-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312619723-31094-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/06/2011 04:35 AM, Liu Bo wrote:
> When btrfs recovers from a crash, it may hit the oops below:
>
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/inode.c:4580!
> [...]
> RIP: 0010:[<ffffffffa03df251>]  [<ffffffffa03df251>] btrfs_add_link+0x161/0x1c0 [btrfs]
> [...]
> Call Trace:
>   [<ffffffffa03e7b31>] ? btrfs_inode_ref_index+0x31/0x80 [btrfs]
>   [<ffffffffa04054e9>] add_inode_ref+0x319/0x3f0 [btrfs]
>   [<ffffffffa0407087>] replay_one_buffer+0x2c7/0x390 [btrfs]
>   [<ffffffffa040444a>] walk_down_log_tree+0x32a/0x480 [btrfs]
>   [<ffffffffa0404695>] walk_log_tree+0xf5/0x240 [btrfs]
>   [<ffffffffa0406cc0>] btrfs_recover_log_trees+0x250/0x350 [btrfs]
>   [<ffffffffa0406dc0>] ? btrfs_recover_log_trees+0x350/0x350 [btrfs]
>   [<ffffffffa03d18b2>] open_ctree+0x1442/0x17d0 [btrfs]
> [...]
>
> This comes from that while replaying an inode ref item, we forget to
> check those old conflicting DIR_ITEM and DIR_INDEX items in fs/file tree,
> then we will come to conflict corners which lead to BUG_ON().
>
> Signed-off-by: Liu Bo<liubo2009@cn.fujitsu.com>
> ---
>   fs/btrfs/tree-log.c |   28 ++++++++++++++++++++++++----
>   1 files changed, 24 insertions(+), 4 deletions(-)

This fixes the oops for me.  The bug was a regression in 2.6.39, I believe.

Tested-by: Andy Lutomirski <luto@mit.edu>

--Andy
