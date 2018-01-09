Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:40092 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757736AbeAIRc7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 12:32:59 -0500
Received: by mail-qk0-f177.google.com with SMTP id d18so9114621qke.7
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 09:32:58 -0800 (PST)
Date: Tue, 9 Jan 2018 12:32:57 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 07/10] Btrfs: extent map selftest: dio write vs dio
 read
Message-ID: <20180109173248.45b3ungi2v4vxjiw@destiny>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
 <20180105195117.5131-8-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180105195117.5131-8-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 05, 2018 at 12:51:14PM -0700, Liu Bo wrote:
> This test case simulates the racy situation of dio write vs dio read,
> and see if btrfs_get_extent() would return -EEXIST.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
