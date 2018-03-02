Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35172 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165155AbeCBSdg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 13:33:36 -0500
Received: by mail-qk0-f195.google.com with SMTP id s188so13128687qkb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Mar 2018 10:33:36 -0800 (PST)
Date: Fri, 2 Mar 2018 13:33:34 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Howard McLauchlan <hmclauchlan@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: Add nossd_spread mount option
Message-ID: <20180302183333.t3fe7rasr26kzlsj@destiny>
References: <20180221233140.23196-1-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180221233140.23196-1-hmclauchlan@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 21, 2018 at 03:31:40PM -0800, Howard McLauchlan wrote:
> Btrfs has two mount options for SSD optimizations: ssd and ssd_spread.
> Presently there is an option to disable all SSD optimizations, but there
> isn't an option to disable just ssd_spread.
> 
> This patch adds a mount option nossd_spread that disables ssd_spread
> only.
> 
> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
