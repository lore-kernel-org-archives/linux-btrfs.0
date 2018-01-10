Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:39632 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965845AbeAJPtU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 10:49:20 -0500
Received: by mail-qt0-f181.google.com with SMTP id k19so22568700qtj.6
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 07:49:19 -0800 (PST)
Date: Wed, 10 Jan 2018 10:49:18 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/6] btrfs: make btrfs_free_stale_device() to iterate all
 stales
Message-ID: <20180110154917.b2l7w4m3lsipmail@destiny>
References: <20180110051523.3681-1-anand.jain@oracle.com>
 <20180110051523.3681-4-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180110051523.3681-4-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 10, 2018 at 01:15:20PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> Let the list iterator iterate further and find other stale
> devices and delete it. This is in preparation to add support
> for user land request-able stale devices cleanup. Also rename
> btrfs_free_stale_device() to btrfs_free_stale_devices().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
