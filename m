Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39687 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965961AbeFSNC2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 09:02:28 -0400
Date: Tue, 19 Jun 2018 14:59:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Allen Pais <allen.lkml@gmail.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbackik@fb.com, dsterba@suse.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: stop using get_seconds()
Message-ID: <20180619125934.GM24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1528804105-24100-1-git-send-email-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1528804105-24100-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 12, 2018 at 05:18:25PM +0530, Allen Pais wrote:
> The get_seconds() function is deprecated as it truncates
> the timestamp to 32 bits. Change to either ktime_get_seconds()
> or ktime_get_real_seconds()
> 
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>
