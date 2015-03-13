Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbbCMMhg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 08:37:36 -0400
Date: Fri, 13 Mar 2015 13:37:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH] Btrfs: fix comp_oper to get right order
Message-ID: <20150313123734.GI20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1426227878-29928-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426227878-29928-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 02:24:38PM +0800, Liu Bo wrote:
> Case (oper1->seq > oper2->seq) should differ with case (oper1->seq < oper2->seq).
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

and should go to stable@ if not to 4.1-rc as it's a bug in the core of
qgroups. Waiting for the next merge window would not buy us anything.

> ---
> This typo was hiden in a big patch, so we need to work harder on review.

Of course, lack of reviews that come from non-maintainers is a perpetual
problem. There are never too many and each is highly appreciated.
