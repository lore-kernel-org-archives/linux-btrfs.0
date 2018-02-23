Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751707AbeBWWLS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 17:11:18 -0500
Date: Fri, 23 Feb 2018 23:08:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: verify subvolid mount parameter
Message-ID: <20180223220858.GM1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180213161042.GV3003@twin.jikos.cz>
 <20180214171137.5589-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180214171137.5589-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 15, 2018 at 01:11:37AM +0800, Anand Jain wrote:
> We aren't verifying the parameter passed to the subvolid mount option,
> so we won't report and fail the mount if a junk value is specified for
> example, -o subvolid=abc.
> This patch verifies the subvolid option with match_u64.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Changelog updated to mention the previous memparse effects.
