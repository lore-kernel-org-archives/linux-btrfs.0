Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53305 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756132AbcLTQSY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 11:18:24 -0500
Date: Tue, 20 Dec 2016 17:18:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Seraphime Kirkovski <kirkseraph@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, jbacik@fb.com, clm@fb.com
Subject: Re: [PATCH 3/4] Btrfs: ACCESS_ONCE cleanup
Message-ID: <20161220161807.GL3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161215133816.25735-1-kirkseraph@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161215133816.25735-1-kirkseraph@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 15, 2016 at 02:38:16PM +0100, Seraphime Kirkovski wrote:
> This replaces ACCESS_ONCE macro with the corresponding
> READ|WRITE macros
> 
> Signed-off-by: Seraphime Kirkovski <kirkseraph@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>

Added to cleanups branch, thanks.
