Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbaLDRlu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 12:41:50 -0500
Date: Thu, 4 Dec 2014 18:41:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: Add inode item rebuild function.
Message-ID: <20141204174150.GJ9754@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1417661565-14595-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1417661565-14595-4-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417661565-14595-4-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 04, 2014 at 10:52:45AM +0800, Qu Wenruo wrote:
> +		namelen = (u16)log10(rec->ino) + 1;

Please get rid of log10 and count the digits without the math library.
