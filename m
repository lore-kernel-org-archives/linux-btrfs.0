Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39408 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755806AbcJLRWE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 13:22:04 -0400
Subject: Re: [PATCH 2/2] btrfs: try to satisfy metadata requests if wen can
 overcommit
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1476263029-11879-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1476263029-11879-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <0777d7c7-3ddd-1fd1-2635-0d9dabd3d7e7@fb.com>
Date: Wed, 12 Oct 2016 13:21:33 -0400
MIME-Version: 1.0
In-Reply-To: <1476263029-11879-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/12/2016 05:03 AM, Wang Xiaoguang wrote:
> In shrink_delalloc(), if can_overcommit() returns true, shrink_delalloc()
> will give up shrinking delalloc bytes, in this case we should check whether
> some tickcts' requests can overcommit, if some can, we can satisfy them
> timely and directly.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

I think I said this elsewhere but just in case you can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

to this, thanks,

Josef
