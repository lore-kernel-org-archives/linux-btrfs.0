Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46371 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756076AbeEILYl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 07:24:41 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 43F67ACC2
        for <linux-btrfs@vger.kernel.org>; Wed,  9 May 2018 11:24:40 +0000 (UTC)
Date: Wed, 9 May 2018 13:22:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Fix DIR_ITEM checking in lowmem
Message-ID: <20180509112202.GQ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1521816494-22947-1-git-send-email-nborisov@suse.com>
 <2df584b7-508d-1274-baf8-c6aefdd04c82@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2df584b7-508d-1274-baf8-c6aefdd04c82@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 02, 2018 at 08:50:38AM +0300, Nikolay Borisov wrote:
> > correctly.
> > 
> > Fixes: 564901eac7a4 ("btrfs-progs: check: introduce print_dir_item_err()")
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> > ---
> 
> Ping

Applied, thanks.
