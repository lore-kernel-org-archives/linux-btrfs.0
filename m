Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40379 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754155AbdGUQDS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 12:03:18 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6B0EDAD1F
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 16:03:17 +0000 (UTC)
Date: Fri, 21 Jul 2017 18:02:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Remove never reached error handling code in
 __add_reloc_root
Message-ID: <20170721160202.GL2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712145000.GD2866@twin.jikos.cz>
 <1499944267-31130-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1499944267-31130-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 02:11:07PM +0300, Nikolay Borisov wrote:
> One of the error handling paths in __add_reloc_root contains btrfs_panic()
> followed by some other code. As the name implies what it does is print
> some error message and call BUG, naturally what follow afterwards is not
> invoked. So remove this extra code.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
