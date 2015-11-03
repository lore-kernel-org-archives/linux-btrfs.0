Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbbKCMNd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Nov 2015 07:13:33 -0500
Date: Tue, 3 Nov 2015 13:12:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: print-tree: Output stripe dev uuid
Message-ID: <20151103121203.GK13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1446533289-30373-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446533289-30373-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 03, 2015 at 02:48:09PM +0800, Qu Wenruo wrote:
> Add output for dev uuid for print_chunk().
> 
> Quite useful to debug temporary btrfs in btrfs-convert.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
