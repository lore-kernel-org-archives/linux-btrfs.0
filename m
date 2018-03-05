Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60757 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752480AbeCEVWX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Mar 2018 16:22:23 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 946AFADC6
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Mar 2018 21:22:22 +0000 (UTC)
Date: Mon, 5 Mar 2018 22:20:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove root argument from cow_file_range_inline
Message-ID: <20180305212003.GF5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1519976595-19125-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1519976595-19125-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 02, 2018 at 09:43:15AM +0200, Nikolay Borisov wrote:
> This argument is always set to the root of the inode, which is also
> passed. So let's get a reference inside the function and simplify
> the arg list.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
