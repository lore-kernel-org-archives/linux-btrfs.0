Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38880 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751156AbdAWRkg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 12:40:36 -0500
Date: Mon, 23 Jan 2017 18:40:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 2/6] btrfs-progs: utils: Introduce basic set
 operations for range
Message-ID: <20170123174017.GP11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
 <20161219065642.25078-3-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161219065642.25078-3-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 19, 2016 at 02:56:38PM +0800, Qu Wenruo wrote:
> +static u64 reserved_range_starts[3] = { 0, BTRFS_SB_MIRROR_OFFSET(1),
> +					BTRFS_SB_MIRROR_OFFSET(2) };
> +static u64 reserved_range_lens[3] = { 1024 * 1024, 64 * 1024, 64 * 1024 };

Also anywhere in the relevant code, the 3 should be better a named
constant and not either 3 or the ARRAY_SIZE, or 2 in some backward going
for loop I've seen.
