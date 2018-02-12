Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57913 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750992AbeBLRPa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 12:15:30 -0500
Date: Mon, 12 Feb 2018 18:13:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: verify max_inline mount parameter
Message-ID: <20180212171314.GM3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180212153546.19443-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180212153546.19443-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 12, 2018 at 11:35:46PM +0800, Anand Jain wrote:
> We aren't verifying the parameter passed to the max_inline mount option,
> so we won't report and fail the mount if a junk value is specified for
> example, -o max_inline=abc.
> This patch converts the max_inline option to %d and checks if it's a
> number >= 0.

Oh right, the parser can verify that for us. As the %d gets stored to
int, there's no reason to store fs_info::max_inline as u64.

Looking at the parser capabilities, it accepts %u and matches an
unsigned type, which we use for all our options. It would be good to
unify that too.

Please update this patch and possibly send more cleaning up the rest of
the match strings, and the max_inline type. Thanks.
