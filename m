Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143AbbCCQaL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Mar 2015 11:30:11 -0500
Date: Tue, 3 Mar 2015 17:30:09 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, zhaolei@cn.fujitsu.com
Subject: Re: [PULL] [PATCH 00/11] Cleanups for 4.1
Message-ID: <20150303163009.GD11093@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1424880058.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1424880058.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 25, 2015 at 07:24:31PM +0100, David Sterba wrote:
> Hi,
> 
> a few cleanups that accumulated over time. No real fixes but there are changes
> that may touch functionality (no fstests complaints though).
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanups-for-4.1

Fixups pointed out by Zhao Lei are now incorporated into

   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanups-for-4.1-v2

(top commit 258ece02126a67af263746e1ae5f8ddf0d492e14)
