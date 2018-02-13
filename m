Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39098 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934766AbeBMQaj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 11:30:39 -0500
Date: Tue, 13 Feb 2018 17:28:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs: verify max_inline mount parameter
Message-ID: <20180213162822.GW3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180213094950.9412-1-anand.jain@oracle.com>
 <20180213094950.9412-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180213094950.9412-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 13, 2018 at 05:49:50PM +0800, Anand Jain wrote:
> We aren't verifying the parameter passed to the max_inline mount option,
> so we won't report and fail the mount if a junk value is specified for
> example, -o max_inline=abc.
> This patch converts the max_inline option to %d and checks if it's a
> number >= 0.

As the max_inline is a size, the suffixes are allowed here and this is
documented in the btrfs(5) page. I've checked all current options and
max_inline should be the only one where we want the suffixes.
