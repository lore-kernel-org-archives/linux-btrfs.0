Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753492AbeGEPzs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 11:55:48 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 84625AD65
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2018 15:55:47 +0000 (UTC)
Date: Thu, 5 Jul 2018 17:55:45 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove warnings superseded by refcount_t usage
Message-ID: <20180705155545.GK3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180625163822.25681-1-dsterba@suse.com>
 <fae25e89-52c5-25ea-65ad-7405fedb0a68@suse.com>
 <20180629140540.GT2287@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180629140540.GT2287@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 04:05:40PM +0200, David Sterba wrote:
> On Tue, Jun 26, 2018 at 05:00:46PM +0300, Nikolay Borisov wrote:
> > On 25.06.2018 19:38, David Sterba wrote:
> > > There are several WARN_ON calls that catch incrorrect reference counter
> > > updates, but this is what the refcount_t does already:
> > > 
> > > * refcount_inc from 0 will warn
> > > * refcount_dec_and_test from 0 will warn
> > > 
> > 
> > But these warnings are only going to be triggered in the case of
> > CONFIG_REFCOUNT_FULL otherwise refcount falls back to plain atomic
> > operations.
> 
> Right, I'm for REFCOUNT_FULL on by default obviously, but we need to
> take handle the case where it's not. And there isn't a refcount type
> with the full semantics.

There refcount helpers will be extended to allow the full check
semantics so I'll use them and drop the WARN_ONs once the patch gets
merged.

https://lore.kernel.org/lkml/20180703100102.16615-1-mark.rutland@arm.com/
