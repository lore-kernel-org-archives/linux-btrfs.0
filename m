Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9235 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbaAZSSQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jan 2014 13:18:16 -0500
Message-ID: <52E5515C.20907@fb.com>
Date: Sun, 26 Jan 2014 13:18:04 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, <linux-btrfs@vger.kernel.org>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Liu Bo <bo.li.liu@oracle.com>,
        Zach Brown <zab@redhat.com>
Subject: Re: [PATCH RFC v2 1/2] Btrfs: rework ulist with list+rb_tree
References: <1390633178-2104-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1390633178-2104-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/25/2014 01:59 AM, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> We are really suffering from now ulist's implementation, some developers
> gave their try, and i just gave some of my ideas for things:
>
>   1. use list+rb_tree instead of arrary+rb_tree
>
>   2. add cur_list to iterator rather than ulist structure.
>
>   3. add seqnum into every node when they are added, this is
>   used to do selfcheck when iterating node.
>
> I noticed Zach Brown's comments before, long term is to kick off
> ulist implementation, however, for now, we need at least avoid
> arrary from ulist.
>
> Cc: Liu Bo <bo.li.liu@oracle.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: Zach Brown <zab@redhat.com>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---

I like it, can we use CONFIG_BTRFS_DEBUG or whatever it's called for the 
seqnum check to make the struct a bit smaller in the normal case?  Thanks,

Josef
