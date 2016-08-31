Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57776 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935371AbcHaPly (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 11:41:54 -0400
Subject: Re: [PATCH] btrfs: fix one bug that process may endlessly wait for
 ticket in wait_reserve_ticket()
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <20160831114616.2053-1-wangxg.fnst@cn.fujitsu.com>
CC: <dsterba@suse.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <2c6713aa-6560-62ee-5a0d-c26942ff7390@fb.com>
Date: Wed, 31 Aug 2016 11:41:06 -0400
MIME-Version: 1.0
In-Reply-To: <20160831114616.2053-1-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/31/2016 07:46 AM, Wang Xiaoguang wrote:
> If can_overcommit() in btrfs_calc_reclaim_metadata_size() returns true,
> btrfs_async_reclaim_metadata_space() will not reclaim metadata space, just
> return directly and also forget to wake up process which are waiting for
> their tickets, so these processes will wait endlessly.
>
> Fstests case generic/172 with mount option "-o compress=lzo" have revealed
> this bug in my test machine. Here if we have tickets to handle, we must
> handle them first.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Yup good catch, you can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
