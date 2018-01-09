Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:36805 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932862AbeAIQMr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 11:12:47 -0500
Received: by mail-qt0-f175.google.com with SMTP id a16so18413691qtj.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 08:12:47 -0800 (PST)
Date: Tue, 9 Jan 2018 11:12:45 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/5] btrfs: set the total_devices in device_list_add()
Message-ID: <20180109161244.3fi7zjngusrgci5n@destiny>
References: <20180109144625.28381-1-anand.jain@oracle.com>
 <20180109144625.28381-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109144625.28381-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 10:46:22PM +0800, Anand Jain wrote:
> There is no other parent for device_list_add() except for
> btrfs_scan_one_device(), which would set btrfs_fs_devices::total_devices
> if device_list_add is successful and this can be done with in
> device_list_add() itself.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
