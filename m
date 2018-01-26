Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:46800 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752558AbeAZOA1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:00:27 -0500
Received: by mail-qt0-f179.google.com with SMTP id o35so1387874qtj.13
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:00:26 -0800 (PST)
Date: Fri, 26 Jan 2018 09:00:24 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: enhance leak debug checker for extent state and
 extent buffer
Message-ID: <20180126140023.uarjugpuqddbczps@destiny>
References: <20180125180256.10844-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125180256.10844-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 25, 2018 at 11:02:48AM -0700, Liu Bo wrote:
> This prints out eb->bflags since it contains some useful information,
> e.g. whether eb is dirty.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
