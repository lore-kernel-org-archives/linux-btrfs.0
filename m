Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbcE3NoT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 09:44:19 -0400
Date: Mon, 30 May 2016 15:43:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: add 020-extent-ref-cases
Message-ID: <20160530134341.GZ29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464577093-12877-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464577093-12877-1-git-send-email-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 30, 2016 at 10:58:13AM +0800, Lu Fengqi wrote:
> In order to confirm that btrfsck supports to check a variety of
> refs, add the
> following cases:
> * keyed_block_ref
> * keyed_data_ref
> * shared_block_ref
> * shared_data_ref
> * no_inline_ref (a extent item without inline ref)
> * no_skinny_ref
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Applied, thanks. The tests currently fail even in 'devel', which patches
are supposed to address the errors?
