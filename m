Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbcHRMsI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Aug 2016 08:48:08 -0400
Date: Thu, 18 Aug 2016 14:46:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: do not background blkdev_put()
Message-ID: <20160818124629.GD16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1469138693-810-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1469138693-810-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 22, 2016 at 06:04:53AM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> At the end of unmount/dev-delete, if the device exclusive open is not
> actually closed, then there might be a race with another program in
> the userland who is trying to open the device in exclusive mode and
> it may fail for eg:
>       unmount /btrfs; fsck /dev/x
>       btrfs dev del /dev/x /btrfs; fsck /dev/x
> so here background blkdev_put() is not a choice

missing signed-off, I'll add it

Reviewed-by: David Sterba <dsterba@suse.com>
