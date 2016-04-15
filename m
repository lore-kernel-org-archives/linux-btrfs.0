Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbcDOLRa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 07:17:30 -0400
Date: Fri, 15 Apr 2016 13:17:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Restrict e2fsprogs version for new convert
Message-ID: <20160415111726.GD28775@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460615074-2492-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460615074-2492-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 14, 2016 at 02:24:34PM +0800, Qu Wenruo wrote:
> New btrfs-convert is using a lot of new macro in e2fsprogs 1.42.
> Unfortunately the new compatible layer for older e2fsprogs is still
> under development.

It hasn't been released yet so it's not really a big problem, although
it makes testing on my side a bit harder. The configure-time check
should be 1.41 and until it's fixed we can print a warning.
