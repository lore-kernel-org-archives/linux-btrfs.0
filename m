Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54107 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753714AbcJLQr0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 12:47:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 88667ABF4
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 16:45:51 +0000 (UTC)
Date: Wed, 12 Oct 2016 18:45:51 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <DSterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: kill unused writepage_io_hook callback
Message-ID: <20161012164551.GU11398@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161012164009.22940-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161012164009.22940-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 06:40:09PM +0200, David Sterba wrote:
> It seems to be long time unused, since 2008 and
> 6885f308b5570 ("Btrfs: Misc 2.6.25 updates").
> 
> Propagating the removal touches some code but has no functional effect.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Please ignore, sent a long time ago already.
