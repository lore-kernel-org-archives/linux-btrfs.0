Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:45625 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757833Ab3EOM3x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 08:29:53 -0400
Message-ID: <51937FDB.2090906@sgi.com>
Date: Wed, 15 May 2013 07:30:19 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: xfs-oss <xfs@oss.sgi.com>, Liu Bo <liubo2009@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests btrfs/284: shorten duration, fix output
References: <517ACB41.2030002@redhat.com>
In-Reply-To: <517ACB41.2030002@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/26/2013 01:45 PM, Eric Sandeen wrote:
> test 284 had... some issues.
>

> diff --git a/tests/btrfs/284 b/tests/btrfs/284
> old mode 100644
> new mode 100755
> index d952977..67161a3
> --- a/tests/btrfs/284
> +++ b/tests/btrfs/284

>
This patch has been committed:

commit 91f87e3b89c0f7350a56d397ba7255d0e3d6b486
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed May 15 07:18:07 2013 -0500

     xfstests btrfs/284: shorten duration, fix output

     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: Josef Bacik <jbacik@fusionio.com>
     Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks
--Rich
