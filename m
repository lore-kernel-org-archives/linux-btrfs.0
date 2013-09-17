Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab3IQNNW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 09:13:22 -0400
Date: Tue, 17 Sep 2013 15:13:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: chris.mason@fusionio.com, Stefan Behrens <sbehrens@giantdisaster.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allocate the free space by the existed max extent
 size when ENOSPC
Message-ID: <20130917131312.GY6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377858934-17187-1-git-send-email-miaox@cn.fujitsu.com>
 <5229DCDC.9080901@giantdisaster.de>
 <522D6906.5040404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <522D6906.5040404@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 09, 2013 at 02:21:58PM +0800, Miao Xie wrote:
> On fri, 06 Sep 2013 15:47:08 +0200, Stefan Behrens wrote:
> > This patch makes the xfstest generic/256 lock up. It's quite
> > reliably reproducible on one of my test boxes, and not at all
> > visible on a second test box.
> > 
> > And yes, I'm using the V2 patch although you haven't tagged it as V2
> > in the subject line of the mail :)
> 
> According to my debug, the machine was not locked up, it seems the
> patch makes the test run very slow(90s ->850s on my machine).

The massive slowdown is present in current 3.12-rc code, which means V3
did not make it into the pull.

Miao please send an incremental fix for rc2.

thanks,
david
