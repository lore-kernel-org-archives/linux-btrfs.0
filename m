Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60309 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752019AbdKFPXu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 10:23:50 -0500
Date: Mon, 6 Nov 2017 16:21:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: move volume_mutex into the btrfs_rm_device()
Message-ID: <20171106152158.GI28789@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171106022800.9473-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171106022800.9473-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 10:28:00AM +0800, Anand Jain wrote:
> A cleanup patch no functional change, we hold volume_mutex before
> calling btrfs_rm_device, so move it into the function itself.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> David, This patch is based on your workspace/for-next plus your
> recent patchset '[PATCH 00/11] Device fixes and cleanups'.

Ok. Added to the queue.

Reviewed-by: David Sterba <dsterba@suse.com>
