Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34124 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933255AbeAIQOP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 11:14:15 -0500
Received: by mail-qk0-f195.google.com with SMTP id b76so6300416qkc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 08:14:14 -0800 (PST)
Date: Tue, 9 Jan 2018 11:14:13 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/5] btrfs: drop devid as device_list_add() arg
Message-ID: <20180109161412.mja2dtbpegbw4gt6@destiny>
References: <20180109144625.28381-1-anand.jain@oracle.com>
 <20180109144625.28381-5-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109144625.28381-5-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 10:46:24PM +0800, Anand Jain wrote:
> As struct btrfs_disk_super is being passed, so it can get devid
> the same way its parent does.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
