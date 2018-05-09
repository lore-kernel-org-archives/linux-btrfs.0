Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37596 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934630AbeEIOib (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 10:38:31 -0400
Date: Wed, 9 May 2018 16:35:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: return original error code when failing from
 option parsing
Message-ID: <20180509143551.GA6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1525871303-87198-1-git-send-email-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525871303-87198-1-git-send-email-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 09, 2018 at 09:08:23PM +0800, Chengguang Xu wrote:
> It's no good to overwrite -ENOMEM using -EINVAL when failing
> from mount option parsing, so just return original error code.
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>

Reviewed-by: David Sterba <dsterba@suse.com>
