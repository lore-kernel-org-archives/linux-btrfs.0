Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34273 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751780AbdDRLJA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 07:09:00 -0400
Date: Tue, 18 Apr 2017 13:08:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v6 1/2] btrfs: scrub: Introduce full stripe lock for
 RAID56
Message-ID: <20170418110856.GQ4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170414003555.4319-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170414003555.4319-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 14, 2017 at 08:35:54AM +0800, Qu Wenruo wrote:
> Unlike mirror based profiles, RAID5/6 recovery needs to read out the
> whole full stripe.
> 
> And if we don't do proper protect, it can easily cause race condition.
> 
> Introduce 2 new functions: lock_full_stripe() and unlock_full_stripe()
> for RAID5/6.
> Which stores a rb_tree of mutex for full stripes, so scrub callers can
> use them to lock a full stripe to avoid race.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
