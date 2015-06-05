Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422846AbbFEQgf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Jun 2015 12:36:35 -0400
Date: Fri, 5 Jun 2015 18:36:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: qgroup: show 'none' when we did not
 limit it on this qgroup
Message-ID: <20150605163633.GT6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433314653-548-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433314653-548-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 03, 2015 at 02:57:31PM +0800, Dongsheng Yang wrote:
> There are two understanding of the '0' value in btrfs qgroup show.
> (1) is no-limitation on this qgroup. (2) is the max-limitation is 0.
> 
> This patch make it showing in different way.
> 
> (1). max-limitation for 0 is still showing '0'.
> (2). no-limitation will show 'none'.
> 
> qgroupid         rfer         excl     max_rfer     max_excl parent
> --------         ----         ----     --------     -------- ------
> 0/5           2.19GiB      2.19GiB         none         none ---
> 0/257       100.02MiB    100.02MiB         none         none ---
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Applied, thanks.
