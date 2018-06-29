Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60266 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932280AbeF2OFm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 10:05:42 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 87214AE4F
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 14:05:41 +0000 (UTC)
Date: Fri, 29 Jun 2018 16:05:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove warnings superseded by refcount_t usage
Message-ID: <20180629140540.GT2287@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180625163822.25681-1-dsterba@suse.com>
 <fae25e89-52c5-25ea-65ad-7405fedb0a68@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fae25e89-52c5-25ea-65ad-7405fedb0a68@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2018 at 05:00:46PM +0300, Nikolay Borisov wrote:
> On 25.06.2018 19:38, David Sterba wrote:
> > There are several WARN_ON calls that catch incrorrect reference counter
> > updates, but this is what the refcount_t does already:
> > 
> > * refcount_inc from 0 will warn
> > * refcount_dec_and_test from 0 will warn
> > 
> 
> But these warnings are only going to be triggered in the case of
> CONFIG_REFCOUNT_FULL otherwise refcount falls back to plain atomic
> operations.

Right, I'm for REFCOUNT_FULL on by default obviously, but we need to
take handle the case where it's not. And there isn't a refcount type
with the full semantics.
