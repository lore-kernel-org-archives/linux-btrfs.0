Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41632 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753900AbdIFPoI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 11:44:08 -0400
Date: Wed, 6 Sep 2017 17:42:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: test/mkfs: Add test case for rootdir
 parameter
Message-ID: <20170906154240.GX31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170905012415.26687-1-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170905012415.26687-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 05, 2017 at 10:24:15AM +0900, Qu Wenruo wrote:
> Add test case which checks if -r|--rootdir mount option can handle
> softlink/char/block/fifo files.
> 
> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Applied fix some fixups, thanks.
