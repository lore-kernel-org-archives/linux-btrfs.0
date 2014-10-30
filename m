Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867AbaJ3QLA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 12:11:00 -0400
Date: Thu, 30 Oct 2014 17:10:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Fix the argument requirement for
 '--subvol-extents'
Message-ID: <20141030161059.GD21354@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1414650846-23767-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414650846-23767-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 30, 2014 at 02:34:06PM +0800, Qu Wenruo wrote:
> The following commit changed the argument requirement for
> '--subvol-extents', which causes it to call arg_strtou64() on NULL,
> resulting a segfault.
> d34cbe76 btrfs-progs: check: do not require argument for --subvol-extents

That was me, thanks for fixing it.
