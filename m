Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57853 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751236AbdIFOYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 10:24:39 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D145AC93
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Sep 2017 14:24:38 +0000 (UTC)
Date: Wed, 6 Sep 2017 16:23:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: Remove redundant forward declarations
Message-ID: <20170906142309.GO31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1504169331-24953-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1504169331-24953-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 31, 2017 at 11:48:51AM +0300, Nikolay Borisov wrote:
> Some static functions are needlessly forward declared. Let's remove those
> declarations since they add no value.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Here is a less invasive version of my previous patch removing the fwd 
> declarations in extent-tree. This time I've limited myself to only those 
> declarations which can be removed without moving code around and creating
> needless noise. 

I can't find the previous patches, but this one is ok. This kind of
cleanup can be done in one big patch, if you are going to send more.

Reviewed-by: David Sterba <dsterba@suse.com>
