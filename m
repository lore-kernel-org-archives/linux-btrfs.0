Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:42831 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbeAIRfl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 12:35:41 -0500
Received: by mail-qk0-f195.google.com with SMTP id q1so2475139qkb.9
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 09:35:41 -0800 (PST)
Date: Tue, 9 Jan 2018 12:35:40 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 10/10] Btrfs: noinline merge_extent_mapping
Message-ID: <20180109173539.mgeitocd3xiwmftx@destiny>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
 <20180105195117.5131-11-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180105195117.5131-11-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 05, 2018 at 12:51:17PM -0700, Liu Bo wrote:
> In order to debug subtle bugs around merge_extent_mapping(), perf probe
> can be used to check the arguments, but sometimes merge_extent_mapping()
> got inlined by compiler and couldn't be probed.
> 
> This is adding noinline attribute to merge_extent_mapping().
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
