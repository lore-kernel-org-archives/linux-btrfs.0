Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:33013 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760099AbeAIRYd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 12:24:33 -0500
Received: by mail-qt0-f180.google.com with SMTP id e2so18739224qti.0
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 09:24:32 -0800 (PST)
Date: Tue, 9 Jan 2018 12:24:31 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 01/10] Btrfs: fix incorrect block_len in
 merge_extent_mapping
Message-ID: <20180109172430.nt23fi6uvwj62jsv@destiny>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
 <20180105195117.5131-2-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180105195117.5131-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 05, 2018 at 12:51:08PM -0700, Liu Bo wrote:
> %block_len could be checked on deciding if two em are mergeable.
> 
> merge_extent_mapping() has only added the front pad if the front part
> of em gets truncated, but it's possible that the end part gets
> truncated.
> 
> For both compressed extent and inline extent, em->block_len is not
> adjusted accordingly, and for regular extent, em->block_len always
> equals to em->len, hence this sets em->block_len with em->len.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
