Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbaGCSKZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jul 2014 14:10:25 -0400
Date: Thu, 3 Jul 2014 20:10:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH] btrfs-progs: prevent select invalid dev super after dev
 replace
Message-ID: <20140703181020.GL1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1404353196-10914-3-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404353196-10914-3-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 03, 2014 at 10:06:35AM +0800, Gui Hecheng wrote:
> After dev replace, we should not select the superblock of the
> replaced dev. Otherwise, all the superblokcs will be overwritten
> by this invalid superblock.
> 
> To prevent this case, let btrfs-select-super check the first
> superblock on the selected dev. If the magic doesn't match,
> then the dev is a replaced dev and error message will show up.

Is this patch needed if Qu's superblock checksum patches are applied?
Thanks.
