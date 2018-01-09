Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:38674 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757892AbeAIRdz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 12:33:55 -0500
Received: by mail-qk0-f174.google.com with SMTP id j185so8695867qkc.5
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 09:33:55 -0800 (PST)
Date: Tue, 9 Jan 2018 12:33:50 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 08/10] Btrfs: add WARN_ONCE to detect unexpected error
 from merge_extent_mapping
Message-ID: <20180109173349.s3xtuaxqoy7outse@destiny>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
 <20180105195117.5131-9-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180105195117.5131-9-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 05, 2018 at 12:51:15PM -0700, Liu Bo wrote:
> This is a subtle case, so in order to understand the problem, it'd be good
> to know the content of existing and em when any error occurs.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
