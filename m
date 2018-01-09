Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36447 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756854AbeAIQYW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 11:24:22 -0500
Received: by mail-qk0-f194.google.com with SMTP id d21so8223432qkj.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 08:24:22 -0800 (PST)
Date: Tue, 9 Jan 2018 11:24:20 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] btrfs: cleanup to make btrfs_free_stale_device()
 readable
Message-ID: <20180109162419.jncvp5gmvitmfqxp@destiny>
References: <20180109141314.23795-1-anand.jain@oracle.com>
 <20180109141314.23795-7-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109141314.23795-7-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 10:13:14PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> Now as the there is path in arg, so instead of reading the path from
> cur_device just get it from the caller, and so the purpose of cur_device
> is to skip the device, so rename it to skip_dev. Also drop the comment
> about different path being used for the same device, since now we will
> have cli to clean any device that's not a concern any more.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Wait you added char *path, and then changed it to device here?  Just drop the
previous patch and do this one.  Thanks,

Josef
