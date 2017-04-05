Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755214AbdDENIJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Apr 2017 09:08:09 -0400
Date: Wed, 5 Apr 2017 15:07:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: switch to div64_u64 if with a u64 divisor
Message-ID: <20170405130724.GF4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1491252324-3544-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491252324-3544-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 03, 2017 at 01:45:24PM -0700, Liu Bo wrote:
> This is fixing code pieces where we use div_u64 when passing a u64 divisor.
> 
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
