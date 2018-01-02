Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750749AbeABQ0H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 11:26:07 -0500
Date: Tue, 2 Jan 2018 17:24:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: Add new 'limit' test group for btrfs
Message-ID: <20180102162400.GV3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171226055744.27697-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171226055744.27697-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 26, 2017 at 01:57:44PM +0800, Qu Wenruo wrote:
> Btrfs qgroup also supports to limit the usage of specified qgroups.
> 
> It's possible to enable qgroup but doesn't enable limit.
> (Most user won't use qgroup limit for various problems)
> 
> So add a new test group 'limit' for btrfs, as a subset of existing
> 'qgroup' group.

The term 'limit' is IMHO too generic, qglimit or qg_limit would be more
descriptive.
