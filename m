Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49126 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752732AbcG0Chw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 22:37:52 -0400
Subject: Re: [PATCH 0/3] Qgroup fixes for dirty hack routines
To: David Sterba <dsterba@suse.com>
References: <20160705093207.14983-1-quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <c4b5222a-7f67-ca1b-d385-36cfe7306cfd@cn.fujitsu.com>
Date: Wed, 27 Jul 2016 10:37:43 +0800
MIME-Version: 1.0
In-Reply-To: <20160705093207.14983-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

For your for-next-20160726 branch, I find that the old version of the 
2nd patch is merged.
Not the latest one in the patchset.

Just in case, if you would like to merge the second patch(fix leaking 
qgroups numbers on data extents), please use the the first 2 patches of 
the patchset.
As the code style and commit message is much better than old version.

Thanks,
Qu

At 07/05/2016 05:32 PM, Qu Wenruo wrote:
> This patchset introduce 2 fixes for data extent owner hacks.
>
> One can be triggered by balance, another one can be trigged by log replay
> after power loss.
>
> Root cause are all similar: EXTENT_DATA owner is changed by dirty
> hacks, from swapping tree blocks containing EXTENT_DATA to manually
> update extent backref without using inc/dec_extent_ref.
>
> The first patch introduces needed functions, then 2 fixes.
>
> The reproducer are all merged into xfstests, btrfs/123 and btrfs/119.
>
> The 2nd patch is sent to mail list weeks ago, only commit message and
> comment is updated.
>
> Qu Wenruo (3):
>   btrfs: qgroup: Refactor btrfs_qgroup_insert_dirty_extent()
>   btrfs: relocation: Fix leaking qgroups numbers on data extents
>   btrfs: qgroup: Fix qgroup incorrectness caused by log replay
>
>  fs/btrfs/delayed-ref.c |  5 +---
>  fs/btrfs/extent-tree.c | 36 ++++------------------
>  fs/btrfs/qgroup.c      | 39 ++++++++++++++++++++----
>  fs/btrfs/qgroup.h      | 44 +++++++++++++++++++++++++--
>  fs/btrfs/relocation.c  | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/tree-log.c    | 16 ++++++++++
>  6 files changed, 178 insertions(+), 43 deletions(-)
>


