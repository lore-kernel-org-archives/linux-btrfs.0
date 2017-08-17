Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53609 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752612AbdHQLsD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 07:48:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0B03BABB1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 11:48:02 +0000 (UTC)
Date: Thu, 17 Aug 2017 13:46:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: Remove unused sectorsize variable from struct
 map_lookup
Message-ID: <20170817114639.GP2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1502898104-4920-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1502898104-4920-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 16, 2017 at 06:41:44PM +0300, Nikolay Borisov wrote:
> This variable was added in 1abe9b8a138c ("Btrfs: add initial tracepointi
> support for btrfs"), yet it never really got used, only assigned to. So let's
> remove it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
