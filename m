Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36751 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965424AbeAJPru (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 10:47:50 -0500
Received: by mail-qt0-f194.google.com with SMTP id a16so22535641qtj.3
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 07:47:49 -0800 (PST)
Date: Wed, 10 Jan 2018 10:47:48 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Finally remove userspace transaction support
Message-ID: <20180110154747.hvylciftq2pzt2go@destiny>
References: <1515590477-22878-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515590477-22878-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 10, 2018 at 03:21:13PM +0200, Nikolay Borisov wrote:
> Userspace transaction were initially added to he benefit of Ceph, however 
> in recent times it became clear that btrfs is not suitable for Ceph's workload
> and has even been actively discoured. Additionaly, the userspace transaction
> mechanism has always been a sort of a hack, which could easily lead to a 
> deadlock unless care is taken. 
> 
> All things considered there is no point in keeping the code around. Userspace
> transaction interface was deprecated in kernel version 4.14. Now it's time to 
> completely remove it in 4.17. 
> 
> The first patch removes the ioctl-related code. Following patches just deal 
> with unused functions/values following ioctl removal. 
> 

Reviewed-by: Josef Bacik <jbacik@fb.com>

for the whole series.  Thanks,

Josef
