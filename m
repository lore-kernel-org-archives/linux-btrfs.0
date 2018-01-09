Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33951 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933705AbeAIQS1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 11:18:27 -0500
Received: by mail-qt0-f194.google.com with SMTP id 33so18449752qtv.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 08:18:26 -0800 (PST)
Date: Tue, 9 Jan 2018 11:18:25 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/6] btrfs: cleanup btrfs_free_stale_device() usage
Message-ID: <20180109161824.7xb2r3fo6vi2636l@destiny>
References: <20180109141314.23795-1-anand.jain@oracle.com>
 <20180109141314.23795-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109141314.23795-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 10:13:09PM +0800, Anand Jain wrote:
> We call btrfs_free_stale_device() only when we alloc a new
> struct btrfs_device (ret=1), so move it closer to where we
> alloc the new device. Also drop the comments.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
