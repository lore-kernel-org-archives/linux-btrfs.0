Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbbAWNYZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 08:24:25 -0500
Date: Fri, 23 Jan 2015 14:24:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs:qgroup:make large size aligned
Message-ID: <20150123132423.GM13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421977849-5822-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421977849-5822-1-git-send-email-fancn.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 23, 2015 at 09:50:49AM +0800, Fan Chengniang wrote:
> problem: when the size is too big, the output format will be unaligned.
> the __update__columns_max_len function has been updated to fix this
> problem
> 
> Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
> ---
> In my patch "[PATCH v3] make btrfs qgroups show human readable sizes"
> I forget to update the function __update__columns_max_len which may
> cause large size unaligned.

Thanks, applied.
