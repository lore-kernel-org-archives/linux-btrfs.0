Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbaKNJ0s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 04:26:48 -0500
Date: Fri, 14 Nov 2014 10:26:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix dead lock while running replace and defrag
 concurrently
Message-ID: <20141114092646.GA30713@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1415604968-21916-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415604968-21916-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 10, 2014 at 03:36:08PM +0800, Gui Hecheng wrote:
> This can be reproduced by fstests: btrfs/070
[...]
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>

Tested-by: David Sterba <dsterba@suse.cz>
