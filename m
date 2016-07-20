Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49528 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754145AbcGTNV2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jul 2016 09:21:28 -0400
Subject: Re: [PATCH 2/4] btrfs: divide btrfs_update_reserved_bytes() into two
 functions
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <20160720055637.7275-1-wangxg.fnst@cn.fujitsu.com>
 <20160720055637.7275-3-wangxg.fnst@cn.fujitsu.com>
CC: <dsterba@suse.cz>, <holger@applied-asynchrony.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <2fb41a9f-c074-f9f3-78a7-5ea5510d67db@fb.com>
Date: Wed, 20 Jul 2016 09:21:04 -0400
MIME-Version: 1.0
In-Reply-To: <20160720055637.7275-3-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/2016 01:56 AM, Wang Xiaoguang wrote:
> This patch divides btrfs_update_reserved_bytes() into
> btrfs_add_reserved_bytes() and btrfs_free_reserved_bytes(), and
> next patch will extend btrfs_add_reserved_bytes（）to fix some
> false ENOSPC error, please see later patch for detailed info.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

This appears to be functionally the same

Signed-off-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
