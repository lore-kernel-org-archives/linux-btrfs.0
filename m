Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:45265 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933629AbeAIQTP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 11:19:15 -0500
Received: by mail-qk0-f178.google.com with SMTP id o126so19166184qke.12
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 08:19:14 -0800 (PST)
Date: Tue, 9 Jan 2018 11:19:13 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] btrfs: no need to check for btrfs_fs_devices::seeding
Message-ID: <20180109161912.aj4qjh2av5nuekdu@destiny>
References: <20180109141314.23795-1-anand.jain@oracle.com>
 <20180109141314.23795-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109141314.23795-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 10:13:10PM +0800, Anand Jain wrote:
> There is no need to check for btrfs_fs_devices::seeding when we
> have checked for btrfs_fs_devices::opened, because we can't sprout
> without its seed FS being opened.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
