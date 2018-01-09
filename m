Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:39170 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759272AbeAIQW4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 11:22:56 -0500
Received: by mail-qk0-f193.google.com with SMTP id r8so14899450qke.6
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 08:22:56 -0800 (PST)
Date: Tue, 9 Jan 2018 11:22:54 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] btrfs: make btrfs_free_stale_device() to match the
 path
Message-ID: <20180109162253.sbl7fjwtjgfs7iaf@destiny>
References: <20180109141314.23795-1-anand.jain@oracle.com>
 <20180109141314.23795-6-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109141314.23795-6-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 10:13:13PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> The btrfs_free_stale_device() is updated to match for the given
> device path and delete it. (It searchs for only unmounted list of
> devices.)
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
