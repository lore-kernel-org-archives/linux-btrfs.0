Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751258AbeAORgK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 12:36:10 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BADDDAC43
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jan 2018 17:36:09 +0000 (UTC)
Date: Mon, 15 Jan 2018 18:34:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.de>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove btrfs_inode::delayed_iput_count
Message-ID: <20180115173401.GE13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1516019494-24210-1-git-send-email-nborisov@suse.com>
 <3188dc79-0fc7-9fc9-b5e9-bc5c2f55d1af@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3188dc79-0fc7-9fc9-b5e9-bc5c2f55d1af@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 15, 2018 at 10:16:54AM -0700, Edmund Nadolski wrote:
> 
> 
> On 01/15/2018 05:31 AM, Nikolay Borisov wrote:
> > delayed_iput_count wa supposed to be used to implement, well, delayed
> > iput. The idea is that we keep accumulating the number of iputs we do
> > until eventually the inode is deleted. Turns out we never really
> > switched the delayed_iput_count from 0 to 1, hence all conditional
> > code relying on the value of that member being different than 0 was
> > never executed. This, as it turns out, didn't cause any problem due
> > to the simple fact that the generic inode's i_count member was always
> > used to count the number of iputs. So let's just remove the unused
> > member and all unused code. This patch essentially provides no
> > functional changes.
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Since the 8089fe62c6 changelog mentions the need for a count, it might
> be nice to include a brief code comment about the i_count effect.

Agreed.

> Reviewed-by: Edmund Nadolski <enadolski@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
