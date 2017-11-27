Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753147AbdK0Xad (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 18:30:33 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3C893ADDE
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Nov 2017 23:30:32 +0000 (UTC)
Date: Tue, 28 Nov 2017 00:28:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4 2/4] btrfs-progs: test/common: Introduce
 run_mustfail_stdout
Message-ID: <20171127232835.GL3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171101013043.19294-1-wqu@suse.com>
 <20171101013043.19294-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171101013043.19294-3-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 01, 2017 at 09:30:41AM +0800, Qu Wenruo wrote:
> For later test case which needs info from stderr.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
