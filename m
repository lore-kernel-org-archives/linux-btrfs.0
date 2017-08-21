Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:37181 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753843AbdHURig (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 13:38:36 -0400
Received: by mail-qt0-f196.google.com with SMTP id g13so4457231qta.4
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 10:38:35 -0700 (PDT)
Date: Mon, 21 Aug 2017 13:38:34 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not async submit for nodatacsum inodes
Message-ID: <20170821173833.GE23807@destiny>
References: <20170818175402.27633-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818175402.27633-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 11:54:02AM -0600, Liu Bo wrote:
> While we submit direct writes, if the inode is flagged with nodatasum,
> there's no benefit to submit asynchronously, because
> 
> a) we don't have to calculate checksum across processors,
> 
> b) and direct IO has started a plug, but async submit makes us queue
> IO on each device's scheduled IO list instead of DIO's plug list, so
> that IOs get much less merges in general.
> 
> Lets use sync submit for nodatasum inodes.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
