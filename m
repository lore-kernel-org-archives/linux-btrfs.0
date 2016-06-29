Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27651 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752417AbcF2Od0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 10:33:26 -0400
Subject: Re: [PATCH] btrfs: Handle uninitialised inode eviction
To: Nikolay Borisov <kernel@kyup.com>, <clm@fb.com>, <dsterba@suse.com>
References: <1467182801-16948-1-git-send-email-kernel@kyup.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <operations@siteground.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <107fec56-cd51-257d-771b-5aa00bd0ebb1@fb.com>
Date: Wed, 29 Jun 2016 10:00:23 -0400
MIME-Version: 1.0
In-Reply-To: <1467182801-16948-1-git-send-email-kernel@kyup.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/29/2016 02:46 AM, Nikolay Borisov wrote:
> The code flow in btrfs_new_inode allows for btrfs_evict_inode to be
> called with not fully initialised inode (e.g. ->root member not
> being set). This can happen when btrfs_set_inode_index in
> btrfs_new_inode fails, which in turn would call iput for the newly
> allocated inode. This in turn leads to vfs calling into btrfs_evict_inode.
> This leads to null pointer dereference. To handle this situation check whether
> the passed inode has root set and just free it in case it doesn't.
>
> Signed-off-by: Nikolay Borisov <kernel@kyup.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
