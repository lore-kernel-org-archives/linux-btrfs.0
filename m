Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42862 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751292AbeAaHDn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 02:03:43 -0500
Subject: Re: [PATCH v3 0/2] fix device orders consistency
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180131022856.16791-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5e2dd88c-4eea-d2a7-4876-7a3b89ec7e9d@suse.com>
Date: Wed, 31 Jan 2018 09:03:40 +0200
MIME-Version: 1.0
In-Reply-To: <20180131022856.16791-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 31.01.2018 04:28, Anand Jain wrote:
> v3->v2:
>  rename device_sort() to device_cmp().
> v1->v2:
>  No code change. Change log updated to include the type
>  of problem that this consistency would help. And
>  I don't see patch 2/2 in the ML. So trying to resend.
> 
> By maintaining the device order (some) consistency it makes reproducing
> the missing chunk related problems more consistent. (More fixes of this
> sort is coming up).
> 
> Anand Jain (2):
>   btrfs: fix device order consistency
>   btrfs: fix alloc device order consistency
> 
>  fs/btrfs/volumes.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 

For the whole series:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
