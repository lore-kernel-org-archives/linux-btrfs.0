Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaG2MTF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 08:19:05 -0400
Date: Tue, 29 Jul 2014 14:19:03 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs-progs: replace a confusing raw number with a
 macro
Message-ID: <20140729121902.GP1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1405564839-28702-3-git-send-email-guihc.fnst@cn.fujitsu.com>
 <20140729121614.GO1553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140729121614.GO1553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 29, 2014 at 02:16:14PM +0200, David Sterba wrote:
> On Thu, Jul 17, 2014 at 10:40:38AM +0800, Gui Hecheng wrote:
> > The raw number 36 for the uuid string length is somewhat confusing,
> > use a macro to define replace it.
> 
> There's the BTRFS_UUID_UNPARSED_SIZE macro, please use it instead to
> avoid duplicate definitions.

Or I'll do that myself as it's a really a small change.
