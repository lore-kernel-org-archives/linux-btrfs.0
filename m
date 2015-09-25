Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263AbbIYQZw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 12:25:52 -0400
Date: Fri, 25 Sep 2015 18:24:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, kreijack@inwind.it
Subject: Re: [PATCH] btrfs-progs: fix is_block_device() return checks
Message-ID: <20150925162453.GK11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1440771090-338-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440771090-338-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 28, 2015 at 10:11:30PM +0800, Anand Jain wrote:
> it was highlighted to me is_block_device(), returns
>  1 if the file is a block device,
>  < 0 in case of an error (eg: file not found)
>  0 otherwise
> 
> This patch makes proper return checks at all the places
> where is_block_device() is used. Thanks to Goffredo.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Suggested-by: Goffredo Baroncelli <kreijack@inwind.it>

Applied, thanks.
