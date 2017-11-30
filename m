Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54352 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751125AbdK3Pwx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 10:52:53 -0500
Date: Thu, 30 Nov 2017 16:50:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Colin King <colin.king@canonical.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: make function update_share_count static
Message-ID: <20171130155054.GL3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171130121447.5118-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171130121447.5118-1-colin.king@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 30, 2017 at 12:14:47PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The function update_share_count is local to the source and does
> not need to be in global scope, so make it static.
> 
> Cleans up sparse warning:
> fs/btrfs/backref.c:219:6: warning: symbol 'update_share_count' was not
> declared. Should it be static?
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: David Sterba <dsterba@suse.com>
