Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58110 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751668AbdF3IKX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 04:10:23 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1BF51AE42
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Jun 2017 08:10:17 +0000 (UTC)
Date: Fri, 30 Jun 2017 10:09:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: convert while loop to list_for_each_entry
Message-ID: <20170630080907.GR2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1498546946-6853-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1498546946-6853-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 27, 2017 at 10:02:24AM +0300, Nikolay Borisov wrote:
> No functional changes, just make the loop a bit more readable
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

1-3 reviewed and added.
