Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33598 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753258AbeGBWSw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 18:18:52 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0B50FAD52
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 22:18:51 +0000 (UTC)
Date: Tue, 3 Jul 2018 00:18:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Check factor out root parsing from
 check_chunks_and_extents
Message-ID: <20180702221845.GE3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1529320258-23095-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529320258-23095-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 18, 2018 at 02:10:58PM +0300, Nikolay Borisov wrote:
> check_chunks_and_extents does quite a number of distinct things. The
> first of those is going through all root items in the root tree and
> classify every root depending on whether they have a dropping operation
> in progress or not. Lets factor out this code and move the variables
> specific to this in a separate function so clean up check_chunks_and_extents
> a bit. Accidentally, this patch fixes some reference leaks since
> in error conditions in the loop the code does "goto out" but at that
> label we don't really release the path. Having this code extracted in a
> separate function which always releases the path avoids this problem
> entirely.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Applied, thanks.
