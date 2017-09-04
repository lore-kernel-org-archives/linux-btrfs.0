Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49622 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753871AbdIDSKY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 14:10:24 -0400
Date: Mon, 4 Sep 2017 20:08:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/5] Mkfs: Rework --rootdir to a more generic behavior
Message-ID: <20170904180856.GG31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 04, 2017 at 03:41:05PM +0900, Qu Wenruo wrote:
> mkfs.btrfs --rootdir provides user a method to generate btrfs with
> pre-written content while without the need of root privilege.
> 
> However the code is quite old and doesn't get much review or test.
> This makes some strange behavior, from customized chunk allocation
> (which uses the reserved 0~1M device space) to lack of special file
> handler (Fixed in previous 2 patches).

The cleanup in this area is most welcome. The patches look good after a
quick look, I'll do another review round.
