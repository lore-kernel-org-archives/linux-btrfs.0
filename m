Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16214 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751086AbdEaC3z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 May 2017 22:29:55 -0400
Subject: Re: [PATCH 3/3] btrfs: check namelen before read/memcmp_extent_buffer
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20170525020908.25830-1-suy.fnst@cn.fujitsu.com>
 <20170525020908.25830-3-suy.fnst@cn.fujitsu.com>
 <20170529154329.GO14523@twin.jikos.cz>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <eb47ab68-5db2-5f57-5eb8-d29f599c56e5@cn.fujitsu.com>
Date: Wed, 31 May 2017 10:31:50 +0800
MIME-Version: 1.0
In-Reply-To: <20170529154329.GO14523@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/29/2017 11:43 PM, David Sterba wrote:
> This patch adds the name length verification to many places and in some
> of them it looks unnecessary, as the directory item passes sanity checks
> already. The verification should always happen when we read the input,
> ie from disk, after search_slot etc. Then, it can be considered valid
> and does not need the strict checks.
> 
I have realized the fact many checks in the patch are useless.
> I haven't gone through all, one example is __add_inode_ref. The caller
> add_inode_ref uses namelen before it reaches __add_inode_ref (and thus
> the sanity checks).
> 
> As the checks add error hanlind branch, the entire callgraph of the
> function should be verified, so I suggest to split the patch and group
> only hunks that touch the same codepaths.
> 
OK, I will update and split it.
> 


