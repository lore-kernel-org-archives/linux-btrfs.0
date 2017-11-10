Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753141AbdKJQnj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 11:43:39 -0500
Subject: Re: [PATCH v4] Btrfs: add support for fallocate's zero range
 operation
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20171103172037.7107-1-fdmanana@kernel.org>
 <20171104040747.8737-1-fdmanana@kernel.org>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3e4ec321-816c-63ad-f991-fa111357f830@suse.com>
Date: Fri, 10 Nov 2017 18:43:37 +0200
MIME-Version: 1.0
In-Reply-To: <20171104040747.8737-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  4.11.2017 06:07, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> This implements support the zero range operation of fallocate. For now
> at least it's as simple as possible while reusing most of the existing
> fallocate and hole punching infrastructure.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Removed double inode unlock on error path from failure to lock range.
> V3: Factored common code to update isize and inode item into a helper
>     function, plus some minor cleanup.
> V4: Removed no longer lock_inode parameter as of V3.
> 

When this gets merged into Linus' tree we'd need to update fallocate's
man page as well
