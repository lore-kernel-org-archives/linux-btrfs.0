Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422708AbbFEQoL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Jun 2015 12:44:11 -0400
Date: Fri, 5 Jun 2015 18:44:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: qgroup limit: error out if input value
 is negative
Message-ID: <20150605164409.GV6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433323624-2194-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433323624-2194-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 03, 2015 at 05:27:03PM +0800, Dongsheng Yang wrote:
> If we pass a negative value to command qgroup limit, btrfs-progs
> would convert it to unsigned long long silently. That's a little
> confusing to user, why I can limit my quota to a negative value.
> 
> This patch add a check in parse_limit, if the input value is negative,
> error out to user.
> 
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Applied, thanks.
