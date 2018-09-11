Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35268 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726563AbeIKR2u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 13:28:50 -0400
Date: Tue, 11 Sep 2018 16:29:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: docs: update document about option -R of
 btrfs-scrub
Message-ID: <20180911142927.GA2997@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180903030707.3542-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180903030707.3542-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 03, 2018 at 11:07:07AM +0800, Su Yue wrote:
> The option '-R' of btrfs-scrub was documented by mistake as
> 'print raw statistics per-device instead of a summary'.
> 
> Here change it to 'raw print mode, print full data instead of
> summary' which it works actually.
> 
> Fixes: 162257574a56 ("btrfs-progs: docs: update btrfs-scrub")
> Reported-by: Chris Murphy <chris@colorremedies.com>
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Applied, thanks.
