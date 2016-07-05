Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22822 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbcGERsw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jul 2016 13:48:52 -0400
Date: Tue, 5 Jul 2016 10:51:55 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Peter Becker <floyd.net@gmail.com>
Subject: Re: [PATCH] Btrfs: fix read_node_slot to return errors
Message-ID: <20160705175155.GA16941@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1467165348-9931-1-git-send-email-bo.li.liu@oracle.com>
 <20160704170818.GK13336@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160704170818.GK13336@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 04, 2016 at 07:08:18PM +0200, David Sterba wrote:
> On Tue, Jun 28, 2016 at 06:55:48PM -0700, Liu Bo wrote:
> > @@ -5238,6 +5256,10 @@ static void tree_move_down(struct btrfs_root *root,
> >  					path->slots[*level]);
> >  	path->slots[*level - 1] = 0;
> >  	(*level)--;
> > +
> > +	if (IS_ERR(path->nodes[*level - 1]))
> > +		return PTR_ERR(path->nodes[*level - 1]);
> 
> Is this right? *level changes since the call to read_node_slot so I
> don't understand which value are we actually testing for error.

Uh, it should check the returned btree block, not after (*level)--;


> 
> Otherwise looks good.

Thanks for reviewing this.

Thanks,

-liubo
