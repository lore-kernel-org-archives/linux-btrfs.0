Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbaHSNiR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 09:38:17 -0400
Date: Tue, 19 Aug 2014 15:38:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: make close_ctree return void
Message-ID: <20140819133815.GS1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1407378959-23728-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1407378959-23728-3-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1407378959-23728-3-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 07, 2014 at 10:35:59AM +0800, Gui Hecheng wrote:
> The close_ctree always returns 0 and the stuff that depends on
> its return value is of no sense.
> Just make close_ctree return void.

You should not do that if the function contains BUG_ONs, this means the
error path is not handled, rather than trivial.
