Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59059 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753155AbeCFKi7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Mar 2018 05:38:59 -0500
Date: Tue, 6 Mar 2018 11:36:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: scrub: remove unnecessary variable set
Message-ID: <20180306103638.GL5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180302231041.10442-4-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180302231041.10442-4-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 02, 2018 at 04:10:40PM -0700, Liu Bo wrote:
> Variable "success" is only checked when !sctx->is_dev_replace.

Though it's right, the code becomes less obvious at least to me that
it's not missing something. There are several conditions and branches,
one more explicit variable setting will not kill the performance but
helps to understand the code flow.
