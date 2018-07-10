Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37698 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751406AbeGJKY7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 06:24:59 -0400
Date: Tue, 10 Jul 2018 12:24:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove unused parameter
Message-ID: <20180710102455.GN3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1531118355-5953-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1531118355-5953-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 09, 2018 at 02:39:15PM +0800, Gu Jinxiang wrote:
> Since parameter flags is no more used since
> commit d7407606564c ("btrfs: split parse_early_options() in two"),
> remove it.

Please be more specific about the function whre you remove the argument,
something like

"remove unused parameter from btrfs_parse_subvol_options".

I'll fix that and add to misc-next, thanks.
