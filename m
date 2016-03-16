Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbcCPJhO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 05:37:14 -0400
Date: Wed, 16 Mar 2016 10:36:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH] Btrfs-progs: use btrfs-debugfs to fetch block group
 information
Message-ID: <20160316093649.GG21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1452543022-9224-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452543022-9224-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 11, 2016 at 12:10:22PM -0800, Liu Bo wrote:
> From: liub.liubo@gmail.com <boliu23@localhost.localdomain>
> 
> This aims to decide whether a balance can reduce the number of
> data block groups and if it is, this shows the '-dvrange' block
> group's objectid.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Applied. I consider btrfs-debugfs as a debugging utility only, without
guarantees of a stable output or commandline arugments.
