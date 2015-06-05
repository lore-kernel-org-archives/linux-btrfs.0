Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422745AbbFEQhs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Jun 2015 12:37:48 -0400
Date: Fri, 5 Jun 2015 18:37:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: qgroup: allow user to clear some
 limitation on qgroup.
Message-ID: <20150605163746.GU6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433314653-548-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <1433314653-548-3-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433314653-548-3-git-send-email-yangds.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 03, 2015 at 02:57:33PM +0800, Dongsheng Yang wrote:
> Currently, we can not clear a limitation on a qgroup. Although
> there is a 'none' choice provided to user to do it, it does not
> work well.
> 
...
> 
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Applied, thanks.
