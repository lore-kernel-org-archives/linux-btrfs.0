Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbbCMNsa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 09:48:30 -0400
Date: Fri, 13 Mar 2015 14:48:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Cleanup open-coded old/new_refcnt update
 and read.
Message-ID: <20150313134828.GL20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1426149207-7534-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150312134539.GA15352@localhost.localdomain>
 <55023167.1090904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55023167.1090904@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 08:37:59AM +0800, Qu Wenruo wrote:
> > On Thu, Mar 12, 2015 at 04:33:27PM +0800, Qu Wenruo wrote:
> >> Use inline functions to do such things, to improve readability.
> >
> > This has actually hiden informations behind the helper function and
> > old_refcnt and new_refcnt can explain themselves, I don't see any benefit.
> Old/new_refcnt won't explain themselves.

I find the helpers useful, just please name them
btrfs_qgroup_get_new_refcnt, btrfs_qgroup_get_old_refcnt etc.

> In fact, it's a combination of sequence and reference number, which is 
> very confusing if you don't read qgroup_shared_accouting().
> 
> This patch will hides the confusing detail, caller will only need to 
> care the number to increase.
> 
> Also, I'm considering split old/new_refcnt into seq and change them to 
> the delta to seq.
> Current implement makes qgroup oper->seq completely meaningless.
> Based on this patch, we only need some minor change to do this.

Acked-by: David Sterba <dsterba@suse.cz>

I haven't really checked it's correct & working.
