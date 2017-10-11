Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50027 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752929AbdJKJ2Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 05:28:24 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2B005ABB4
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 09:28:23 +0000 (UTC)
Subject: Re: [PATCH] Remove unused dedupe argument btrfs_set_extent_delalloc()
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20171011022900.21486-1-rgoldwyn@suse.de>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6b050c9a-e81c-9ed0-682f-8c702b2e17b0@suse.com>
Date: Wed, 11 Oct 2017 12:28:22 +0300
MIME-Version: 1.0
In-Reply-To: <20171011022900.21486-1-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11.10.2017 05:29, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> 

I had already sent similar patch and David said he is not removing the
in-band dedup prep for now.
