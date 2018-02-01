Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55291 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751567AbeBAQHn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Feb 2018 11:07:43 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 524E1ACBB
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Feb 2018 16:07:42 +0000 (UTC)
Date: Thu, 1 Feb 2018 17:05:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 0/3] btrfs-progs: Split lowmem mode check to its own
Message-ID: <20180201160527.GL18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180201064541.14603-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180201064541.14603-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 01, 2018 at 02:45:38PM +0800, Qu Wenruo wrote:
> As usual, the main part is over 500K so the biggest patch won't reach
> mail list.
> Please fetch the whole branch from github:
> https://github.com/adam900710/btrfs-progs/tree/split_check

Thanks, patches added to devel, with some more adjustments.

> Despite the update, a new patch is introduced, to address the tons of
> BORING errors and warning from checkpatch.pl.

The checkpatch script can report lots of things to fix, but please note
that not all of them match the style we use. I've updated the patch 3/3
and undone some of the line splits, because it's the example where the
code looks worse after fixing.

We'd probably have to host our modified version of checkpatch so the
warnings don't get reported repeatedly.
