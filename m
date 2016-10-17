Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48015 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932970AbcJQOat (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 10:30:49 -0400
Date: Mon, 17 Oct 2016 16:30:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v13 00/15] Btrfs In-band De-duplication
Message-ID: <20161017143047.GL11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 08, 2016 at 03:12:49PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux.git wang_dedupe_20160907

Can you please publish the patchset in a branch that does not change
name and is not based on for-next? I'm' going to do less manual merge
tests with Chandan's patchset. A 'dedupe-latest' would work for me,
otherwise feel free to keep the timestamped branches for your needs. The
base branch should be chris' integration (not necessarily the latest
one). Thanks.
