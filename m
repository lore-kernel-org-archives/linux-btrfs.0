Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:39251 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753885AbeAIRfF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 12:35:05 -0500
Received: by mail-qk0-f193.google.com with SMTP id r8so15209422qke.6
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 09:35:05 -0800 (PST)
Date: Tue, 9 Jan 2018 12:35:03 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 09/10] Btrfs: add tracepoint for em's EEXIST case
Message-ID: <20180109173502.yqs36p6ub776bgbg@destiny>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
 <20180105195117.5131-10-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180105195117.5131-10-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 05, 2018 at 12:51:16PM -0700, Liu Bo wrote:
> This is adding a tracepoint 'btrfs_handle_em_exist' to help debug the
> subtle bugs around merge_extent_mapping.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
