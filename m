Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36403 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752093AbeCHP6r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 10:58:47 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 17F2AAD5E
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 15:58:46 +0000 (UTC)
Date: Thu, 8 Mar 2018 16:56:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 14/22] btrfs: remove trivial locking wrappers of tree mod
 log
Message-ID: <20180308155625.GO23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1520518876.git.dsterba@suse.com>
 <4888ae25fe8e1f1f87f3187dc199eed4799a3a99.1520518876.git.dsterba@suse.com>
 <4a72bdae-2a5a-e4e4-1cb0-086b3ddd9857@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4a72bdae-2a5a-e4e4-1cb0-086b3ddd9857@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2018 at 05:37:33PM +0200, Nikolay Borisov wrote:
> 
> 
> On  8.03.2018 16:33, David Sterba wrote:
> > The wrappers are trivial and do bring any extra value on top of the
> 
> nit: s/do/don't/ ?

Right, fixed.

> > plain locking primitives.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> 
> Just 2 minor nits, otherwise LGTM:
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
> > - * Note: must be called with write lock (tree_mod_log_write_lock).
> > + * Note: must be called with write lock for fs_info_;;tree_mod_log_lock.
> nit: s/;;/::/

Fixed, thanks.
