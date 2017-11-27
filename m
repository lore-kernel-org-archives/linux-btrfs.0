Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39422 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752244AbdK0Xcg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 18:32:36 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B82A8ADDE
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Nov 2017 23:32:34 +0000 (UTC)
Date: Tue, 28 Nov 2017 00:30:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4 3/4] btrfs-progs: test/common: Enhance
 prepare_test_dev to reset device size
Message-ID: <20171127233038.GM3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171101013043.19294-1-wqu@suse.com>
 <20171101013043.19294-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171101013043.19294-4-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 01, 2017 at 09:30:42AM +0800, Qu Wenruo wrote:
> So prepare_test_dev() can be called several times in one test case, to
> test different device sizes.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
