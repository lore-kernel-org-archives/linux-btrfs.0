Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbbA3TRv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 14:17:51 -0500
Date: Fri, 30 Jan 2015 20:17:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 0/9] btrfs: Fix freeze/sysfs deadlock in better method.
Message-ID: <20150130191749.GZ3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 05:20:45PM +0800, Qu Wenruo wrote:
> [Use VFS protect for sysfs change]
> The 6th patch will introduce a new help function sb_want_write() to
> claim write permission to a superblock.
> With this, we are able to do write protection like mnt_want_write() but
> only needs to ensure that the superblock is writeable.
> This also keeps the same synchronized behavior using ioctl, which will
> block on frozen fs until it is unfrozen.

You know what I think abuot the commit inside sysfs, but it looks better
to me now with the sb_* protections so I give it a go.
