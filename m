Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34321 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760090AbeAIR15 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 12:27:57 -0500
Received: by mail-qt0-f195.google.com with SMTP id 33so18740286qtv.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 09:27:57 -0800 (PST)
Date: Tue, 9 Jan 2018 12:27:56 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 03/10] Btrfs: add helper for em merge logic
Message-ID: <20180109172755.c564qqnlresbrvi6@destiny>
References: <20180105195117.5131-1-bo.li.liu@oracle.com>
 <20180105195117.5131-4-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180105195117.5131-4-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 05, 2018 at 12:51:10PM -0700, Liu Bo wrote:
> This is a prepare work for the following extent map selftest, which
> runs tests against em merge logic.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
