Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51015 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750755AbdGMAv2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 20:51:28 -0400
Date: Thu, 13 Jul 2017 02:50:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, ahferroin7@gmail.com, kilobyte@angband.pl
Subject: Re: [PATCH v4 0/6] Chunk level degradable check
Message-ID: <20170713005010.GA2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
 <20170710211150.7210ac36@fire>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170710211150.7210ac36@fire>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 10, 2017 at 09:11:50PM +0300, Dmitrii Tcvetkov wrote:
> Tested on top of current mainline master (commit
> af3c8d98508d37541d4bf57f13a984a7f73a328c). Didn't find any
> regressions.

Thanks for testing.

If anybody wants to get their Tested-by in the patches, please let me
know, I'll add the tags (can be done until rc6). Your efforts are
appreciated so you get the credit in the undying history log of linux
kernel.
