Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbcFBRIN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 13:08:13 -0400
Date: Thu, 2 Jun 2016 19:07:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs: fix check_shared for fiemap ioctl
Message-ID: <20160602170732.GJ29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464760085-12078-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160601211522.GI7633@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160601211522.GI7633@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 01, 2016 at 02:15:22PM -0700, Mark Fasheh wrote:
> > +/* dynamically allocate and initialize a ref_root */
> > +static struct ref_root *ref_root_alloc(void)
> > +{
> > +	struct ref_root *ref_tree;
> > +
> > +	ref_tree = kmalloc(sizeof(*ref_tree), GFP_KERNEL);
> 
> I'm pretty sure we want GFP_NOFS here.

Then please explain to me why/where the reasoning below is wrong:

> > Because there's no need to narrow the allocation constraints. GFP_NOFS
> > is necessary when the caller is on a critical path that must not recurse
> > back to the filesystem through the allocation (ie. if the allocator
> > decides to free some memory and tries tro write dirty data). FIEMAP is
> > called from an ioctl.
