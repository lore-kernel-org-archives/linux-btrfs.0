Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53140 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbeCINWv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 08:22:51 -0500
Date: Fri, 9 Mar 2018 14:20:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Howard McLauchlan <hmclauchlan@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v2] btrfs: Add nossd_spread mount option
Message-ID: <20180309132028.GQ23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180308184848.12877-1-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180308184848.12877-1-hmclauchlan@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2018 at 10:48:48AM -0800, Howard McLauchlan wrote:
> Btrfs has two mount options for SSD optimizations: ssd and ssd_spread.
> Presently there is an option to disable all SSD optimizations, but there
> isn't an option to disable just ssd_spread.
> 
> This patch adds a mount option nossd_spread that disables ssd_spread
> only.
> 
> Reviewed-by: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
> ---
> V2:remove duplicate code with fallthrough
> Based on 4.16-rc4

Added to next, thanks.
