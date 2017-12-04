Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36046 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752540AbdLDNwP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 08:52:15 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 86F17ADFC
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Dec 2017 13:52:14 +0000 (UTC)
Date: Mon, 4 Dec 2017 14:50:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/5] btrfs: Remove dead code
Message-ID: <20171204135016.GW3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
 <1512119984-12708-3-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512119984-12708-3-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 01, 2017 at 11:19:41AM +0200, Nikolay Borisov wrote:
> 'clear' is always set to 0 (BTRFS_FEATURE_COMPAT_SAFE_CLEAR,
> BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR and BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR are
> all defined to 0). So remove the code that logically can never execute.

The point of the macros is to wrap all values that can mean
"compatibility, safe to clear", similar to BTRFS_FEATURE_COMPAT_RO_SUPP
etc. So when we have such feature, we'll modify the defines and the rest
of the code will work.

But with your change the 'safe clear' would have to be patched again. The
macros provide complete interface, though some of the bits are not used.
A single line of unused code is IMHO not that significant that we have
to remove it and silently break the implementation.
