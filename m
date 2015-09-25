Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:40906 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932340AbbIYWfw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 18:35:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sat, 26 Sep 2015 00:35:48 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Btrfs: Fix a insane extent_buffer copy behavior for
 qgroup
In-Reply-To: <1443148681-3015-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1443148681-3015-1-git-send-email-quwenruo@cn.fujitsu.com>
Message-ID: <eb99c836513f7d88542f078a1b095d83@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-25 04:37, Qu Wenruo a écrit :
> Stephane Lesimple reported an qgroup rescan bug:
> 
> [92098.841309] general protection fault: 0000 [#1] SMP
> [92098.841338] Modules linked in: ...
> [92098.841814] CPU: 1 PID: 24655 Comm: kworker/u4:12 Not tainted
> 4.3.0-rc1 #1
> [92098.841868] Workqueue: btrfs-qgroup-rescan 
> btrfs_qgroup_rescan_helper
> [btrfs]
> [92098.842261] Call Trace:
> [92098.842277]  [<ffffffffc035a5d8>] ? read_extent_buffer+0xb8/0x110
> [btrfs]
> [92098.842304]  [<ffffffffc0396d00>] ? btrfs_find_all_roots+0x60/0x70
> [btrfs]
> [92098.842329]  [<ffffffffc039af3d>]
> btrfs_qgroup_rescan_worker+0x28d/0x5a0 [btrfs]
> ...
> 
> The triggering function btrfs_disk_key_to_cpu(), which should never
> fail.
> But it turned out that the extent_buffere being called on is memcpied
> from an existing one.
> 
> Such behavior to copy a structure with page pointers and locks in it is
> never a sane thing.
> 
> Fix it by do it in memory other than extent_buffer.
> 
> Qu Wenruo (2):
>   btrfs: Add support to do stack item key operation
>   btrfs: qgroup: Don't copy extent buffer to do qgroup rescan
> 
>  fs/btrfs/ctree.h  | 20 ++++++++++++++++++++
>  fs/btrfs/qgroup.c | 22 ++++++++++++----------
>  2 files changed, 32 insertions(+), 10 deletions(-)

I applied this patch and ran 100+ rescans on my filesystem for several 
hours. No crash happened, where only a few rescans were enough to 
trigger the bug previously.

I'm confident this patch fixes the GPF, thanks Qu !

-- 
Stéphane.


