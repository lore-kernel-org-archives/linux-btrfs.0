Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbcCINnM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 08:43:12 -0500
Date: Wed, 9 Mar 2016 14:42:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Add new option for specify chunk root bytenr
Message-ID: <20160309134251.GF738@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457326661-9646-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <1457326661-9646-2-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457326661-9646-2-git-send-email-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 07, 2016 at 12:57:41PM +0800, Lu Fengqi wrote:
> Add new btrfsck option, '--chunk-root', to specify chunk root bytenr.And
> allow open_ctree_fs_info() function accept chunk_root_bytenr to override
> the bytenr in superblock.This will be mainly used when chunk tree
> corruption.

Good idea. I'll remove the short option for now as this does not seem to
be frequently needed, we can reserve -c for something else.
