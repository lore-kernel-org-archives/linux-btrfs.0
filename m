Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbaKGRlq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 12:41:46 -0500
Date: Fri, 7 Nov 2014 18:41:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: skip fs with no seed when build seed/sprout
 mapping for fi show
Message-ID: <20141107174145.GD25615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1415326063-8838-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415326063-8838-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 07, 2014 at 10:07:41AM +0800, Gui Hecheng wrote:
> +static int no_seed_devices(struct btrfs_fs_devices *fs_devices)

Please reverse the meaning of the function, ie. something like
'has_seed_devices'. It's more natural to deal with negation operators
when they're explicit rather than hidden.

Thanks.
