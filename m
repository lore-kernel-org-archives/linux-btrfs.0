Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47546 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933072AbcIAPV3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 11:21:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 38452ABE2
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Sep 2016 15:21:11 +0000 (UTC)
Date: Thu, 1 Sep 2016 17:19:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: add dynamic debug support
Message-ID: <20160901151949.GQ16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <57C7A6B5.7040409@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57C7A6B5.7040409@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 31, 2016 at 11:55:33PM -0400, Jeff Mahoney wrote:
> We can re-use the dynamic debugging descriptor to make use of the dynamic
> debugging mechanism but still use our own printk interface.
> 
> Defining the DEBUG macro works as it did before.  When it's defined,
> all of the messages default to print.  We can also enable all debug
> messages at boot or module-load time using the 'dyndbg' and
> 'btrfs.dyndbg' options.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
