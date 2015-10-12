Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbbJLNf4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:35:56 -0400
Date: Mon, 12 Oct 2015 15:34:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Add all missing close_ctree and
 btrfs_close_all_devices
Message-ID: <20151012133446.GF27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <097939b7e85d73c1dc7ac82565b8683b5b0a2a8d.1444620452.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <097939b7e85d73c1dc7ac82565b8683b5b0a2a8d.1444620452.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 12, 2015 at 11:27:39AM +0800, Zhao Lei wrote:
> This patch add all missing close_ctree and btrfs_close_all_devices
> to several tools in btrfs progs, to avoid memory leak.

With that many missing callsites, I think it's better to put it right
after the command callback:

btrfs.c:
245         exit(cmd->fn(argc, argv));

so we don't need to add it everywhere manually. The standalone tools
need that though.
