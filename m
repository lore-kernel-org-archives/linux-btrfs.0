Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50833 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750997AbcKYJru (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 04:47:50 -0500
Date: Fri, 25 Nov 2016 10:46:14 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix qgroup rescan worker initialization
Message-ID: <20161125094614.GV12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1479953909-16332-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479953909-16332-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 24, 2016 at 02:18:29AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We were setting the qgroup_rescan_running flag to true only after the
> rescan worker started (which is a task run by a queue). So if a user
> space task starts a rescan and immediately after asks to wait for the
> rescan worker to finish, this second call might happen before the rescan
> worker task starts running, in which case the rescan wait ioctl returns
> immediatley, not waiting for the rescan worker to finish.
> 
> This was making the fstest btrfs/022 fail very often.
> 
> Fixes: d2c609b834d6 (btrfs: properly track when rescan worker is running)
> Cc: stable@vger.kernel.org # 4.4+
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
