Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932540AbcGHONr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 10:13:47 -0400
Date: Fri, 8 Jul 2016 16:13:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        holger@applied-asynchrony.com, clm@fb.com, xiaolong.ye@intel.com
Subject: Re: [PATCH v3 2/2] btrfs: make sure device is synced before return
Message-ID: <20160708141359.GI13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1465901726-15490-2-git-send-email-anand.jain@oracle.com>
 <1466686447-7780-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466686447-7780-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 08:54:07PM +0800, Anand Jain wrote:
> An inconsistent behavior due to stale reads from the
> disk was reported
> 
>   mail-archive.com/linux-btrfs@vger.kernel.org/msg54188.html
> 
> This patch will make sure devices are synced before
> return in the unmount thread.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Added to for-next.
