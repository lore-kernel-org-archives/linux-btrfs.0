Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33744 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932898AbeAIQNk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 11:13:40 -0500
Received: by mail-qt0-f194.google.com with SMTP id e2so18440941qti.0
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 08:13:40 -0800 (PST)
Date: Tue, 9 Jan 2018 11:13:38 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] btrfs: get device pointer from device_list_add()
Message-ID: <20180109161338.mz7qtwfzbzv5jon6@destiny>
References: <20180109144625.28381-1-anand.jain@oracle.com>
 <20180109144625.28381-4-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109144625.28381-4-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 10:46:23PM +0800, Anand Jain wrote:
> Instead of pointer to btrfs_fs_devices from device_list_add() its
> better to get pointer to btrfs_device, then we have both, pointer
> to btrfs_device and btrfs_fs_devices. This is needed in preparation
> to add handling reappearing missing device feature.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Can we just change device_list_add to return struct btrfs_device * instead, and
just do PTR_ERR() if there's a problem?  Thanks,

Josef
