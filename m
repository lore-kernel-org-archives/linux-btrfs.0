Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33133 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934836AbdIZMO3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 08:14:29 -0400
Subject: Re: [PATCH v3 0/2] fix bug in btrfs_init_new_device()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <612a7520-a83d-9032-bbbb-7b13ab76f43f@suse.com>
Date: Tue, 26 Sep 2017 15:14:27 +0300
MIME-Version: 1.0
In-Reply-To: <20170926084738.3558-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170926084738.3558-1-anand.jain@oracle.com>



On 26.09.2017 11:47, Anand Jain wrote:
> 1/2 fixes a bug which failed to reset writable when sprouting failed
> 2/2 fixes BUG_ON in btrfs_init_new_device()
> 
> Anand Jain (2):
>   btrfs: undo writable when sprouting fails
>   btrfs: fix BUG_ON in btrfs_init_new_device()

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
>  fs/btrfs/volumes.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
