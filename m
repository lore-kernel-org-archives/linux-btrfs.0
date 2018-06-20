Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59222 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752951AbeFTObF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 10:31:05 -0400
Date: Wed, 20 Jun 2018 16:28:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: delayed-ref: simplify btrfs_add_delayed_tree_ref()
Message-ID: <20180620142813.GC24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180523080650.28286-1-suy.fnst@cn.fujitsu.com>
 <ca6309fc-e925-f33f-1352-d13cf2a1c710@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ca6309fc-e925-f33f-1352-d13cf2a1c710@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2018 at 11:22:20AM +0300, Nikolay Borisov wrote:
> 
> 
> On 23.05.2018 11:06, Su Yue wrote:
> > Commit 5a5003df98d5 ("btrfs: delayed-ref: double free in
> > btrfs_add_delayed_tree_ref()") fixed double free problem by creating
> > an unnessesary label to jump.
> > The elegant way is just to change "ref" to "head_ref" and keep
> > btrfs_add_delayed_tree_ref() and btrfs_add_delayed_data_ref() in
> > similar structure.
> 
> I agree, personally I'm a fan of multiple returns rather than jump
> labels, because at this point you know the function terminates and
> that's it.

Ok, let's do the freeing in-place, but it would be better to put them
before any other code, which is init_delayed_ref_common() in this case.
