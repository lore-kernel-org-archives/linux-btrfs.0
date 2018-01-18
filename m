Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34188 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754916AbeARRt1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 12:49:27 -0500
Date: Thu, 18 Jan 2018 18:47:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND v4 0/4] device_list_add() peparation to add
 reappearing missing device
Message-ID: <20180118174717.GT13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180118140236.25349-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180118140236.25349-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 18, 2018 at 10:02:32PM +0800, Anand Jain wrote:
> (Apply on top of my patchset
>    [PATCH v4 0/6] preparatory work to add device forget
>  for conflict free apply. They don't actually depend on
>  each other though).

> Cleanup of device_list_add(), mainly in preparation to handle
> reappearing missing device which its next reroll will be sent
> separately.

I'm adding the two patchsets to the 4.16 queue but will push the updated
branch after the current tests finish and I also test the updated branch
as well.
