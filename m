Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:50509 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab2HBNx5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 09:53:57 -0400
Date: Thu, 2 Aug 2012 15:53:54 +0200
From: David Sterba <dave@jikos.cz>
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:5038 (linux 3.4.7)
Message-ID: <20120802135354.GQ17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <501987FF.9080304@daevel.fr>
 <20120802132259.GO17430@twin.jikos.cz>
 <501A836F.90506@daevel.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <501A836F.90506@daevel.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2012 at 03:41:03PM +0200, Olivier Bonvalet wrote:
> Yes... it's a copy from my /var/log/kern.log. Is it really "disabled" ?

I was mistaken, it really is enabled unconditionally in ctree.h:55.
Josef says that the V0 extent refs are not used for a long time, so the
question is how did they appear in your filesystem. Did you switch to a
new kernel from a very old one?


david
