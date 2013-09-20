Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab3ITJZz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 05:25:55 -0400
Date: Fri, 20 Sep 2013 11:25:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: chris.mason@fusionio.com, Stefan Behrens <sbehrens@giantdisaster.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allocate the free space by the existed max extent
 size when ENOSPC
Message-ID: <20130920092552.GJ6810@suse.cz>
Reply-To: dsterba@suse.cz
References: <1377858934-17187-1-git-send-email-miaox@cn.fujitsu.com>
 <5229DCDC.9080901@giantdisaster.de>
 <522D6906.5040404@cn.fujitsu.com>
 <20130917131312.GY6810@twin.jikos.cz>
 <5239264E.9080904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5239264E.9080904@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 18, 2013 at 12:04:30PM +0800, Miao Xie wrote:
> On Tue, 17 Sep 2013 15:13:12 +0200, David Sterba wrote:
> > On Mon, Sep 09, 2013 at 02:21:58PM +0800, Miao Xie wrote:
> >> On fri, 06 Sep 2013 15:47:08 +0200, Stefan Behrens wrote:
> > The massive slowdown is present in current 3.12-rc code, which means V3
> > did not make it into the pull.
> > 
> > Miao please send an incremental fix for rc2.
> 
> This patch has not been merged into 3.12-rc, so the above problem should be
> introduced by other patch.

Sorry, my oversight.
