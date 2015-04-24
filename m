Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45808 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754885AbbDXSLQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 14:11:16 -0400
Message-ID: <553A8737.8030600@fb.com>
Date: Fri, 24 Apr 2015 14:11:03 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] fstests: test btrfs send after swapping directory names
 differently
References: <1428591389-3668-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1428591389-3668-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/09/2015 10:56 AM, Filipe Manana wrote:
> Test btrfs incremental send after renaming and moving directories around in a
> way that ends up making a directory have different dentries with the same name
> but pointing to different inodes in the parent and send snapshots, and also
> inverting the ancestor-descendent relationship between one of those inodes and
> some other inode.
>
> Cases like this made an incremental send enter an infinite lopp when building
> path strings, leading to -ENOMEM errors when the path string reached a length
> of PATH_MAX.
> This issue was fixed by the following linux kernel btrfs patch:
>
>    Btrfs: incremental send, check if orphanized dir inode needs delayed rename
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Verified it passed with the patches applied and failed without them. 
Test looks straightforward and good to me, you can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

