Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752014AbeBWXon (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 18:44:43 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 03A0AAB34
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 23:44:42 +0000 (UTC)
Date: Sat, 24 Feb 2018 00:42:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove redundant memory barriers
Message-ID: <20180223234223.GT1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1518598416-13069-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518598416-13069-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 14, 2018 at 10:53:36AM +0200, Nikolay Borisov wrote:
> Using any kind of memory barriers around atomic operations which have
> a return value is redundant, since those operations themselves are
> fully ordered. atomic_t.txt states:
> 
>     - RMW operations that have a return value are fully ordered;
> 
>     Fully ordered primitives are ordered against everything prior and
>     everything subsequent. Therefore a fully ordered primitive is like
>     having an smp_mb() before and an smp_mb() after the primitive.
> 
> Given this let's replace the extra memory barriers with comments.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
