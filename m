Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52107 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752609AbdLDQRV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 11:17:21 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2F2B3AEB0
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Dec 2017 16:17:20 +0000 (UTC)
Subject: Re: [PATCH 2/5] btrfs: Remove dead code
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
 <1512119984-12708-3-git-send-email-nborisov@suse.com>
 <20171204135016.GW3553@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5e3e8782-dc62-1a5a-b569-474ad2357b39@suse.com>
Date: Mon, 4 Dec 2017 18:17:17 +0200
MIME-Version: 1.0
In-Reply-To: <20171204135016.GW3553@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  4.12.2017 15:50, David Sterba wrote:
> On Fri, Dec 01, 2017 at 11:19:41AM +0200, Nikolay Borisov wrote:
>> 'clear' is always set to 0 (BTRFS_FEATURE_COMPAT_SAFE_CLEAR,
>> BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR and BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR are
>> all defined to 0). So remove the code that logically can never execute.
> 
> The point of the macros is to wrap all values that can mean
> "compatibility, safe to clear", similar to BTRFS_FEATURE_COMPAT_RO_SUPP
> etc. So when we have such feature, we'll modify the defines and the rest
> of the code will work.

Fair enough feel free to drop it.

> 
> But with your change the 'safe clear' would have to be patched again. The
> macros provide complete interface, though some of the bits are not used.
> A single line of unused code is IMHO not that significant that we have
> to remove it and silently break the implementation.
> 
