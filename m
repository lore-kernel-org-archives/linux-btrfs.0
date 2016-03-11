Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbcCKLn2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 06:43:28 -0500
Date: Fri, 11 Mar 2016 12:43:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: NeilBrown <neilb@suse.com>, linux-btrfs@vger.kernel.org, clm@fb.com,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v7 01/20] btrfs: dedup: Introduce dedup framework and its
 header
Message-ID: <20160311114305.GQ18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1455774178-3595-2-git-send-email-quwenruo@cn.fujitsu.com>
 <87io0vjq9x.fsf@notabene.neil.brown.name>
 <56E0C668.4020406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56E0C668.4020406@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 08:57:12AM +0800, Qu Wenruo wrote:
> > The ioctl FIDEDUPERANGE and the tool duperemove both use "dupe".
> > It would be nice if we could be consistent and all use the same
> > abbreviation.
> 
> Yes, current kernel VFS level offline dedup uses the name "dedupe".
> But on the other hand, ZFS uses the name "dedup" for their online dedup.
> 
> And personally speaking, I'd like some difference to distinguish inline 
> dedup and offline dedup.
> In that case, the extra "e" seems somewhat useful.
> With "e", it's intended for offline use. Without "e", it's intended for 
> online use.

Such difference is very subtle and I think we should stick to just one
spelling, which shall be 'dedupe'.
