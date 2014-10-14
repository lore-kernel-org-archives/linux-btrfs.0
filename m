Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbaJNJcg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 05:32:36 -0400
Date: Tue, 14 Oct 2014 11:32:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH v4] btrfs-progs: fix page align issue for lzo compress in
 restore
Message-ID: <20141014093234.GP22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140922134115.GP9715@twin.jikos.cz>
 <1411461294-24093-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1929724.Hf7kupaGA7@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1929724.Hf7kupaGA7@fb07-iapwap2>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 14, 2014 at 10:06:16AM +0200, Marc Dietrich wrote:
> This hasn't landed in an btrfs-progs branch I found. Any update?

I had it tagged for review and found something that needs fixing. The
PAGE_CACHE_SIZE is hardcoded to 4k, this will break on filesystems with
larger sectors (eg. the powerpc machines). I'll scheudule the patch post
3.17, with a fix.
