Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2974DC07EBF
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 18:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0455F20823
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 18:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbfARSI1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 13:08:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:42944 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728274AbfARSI1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 13:08:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 579A7AF09;
        Fri, 18 Jan 2019 18:08:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A6CA4DA773; Fri, 18 Jan 2019 19:07:55 +0100 (CET)
Date:   Fri, 18 Jan 2019 19:07:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: avoid deadlock with memory reclaim due to
 allocation of devices
Message-ID: <20190118180753.GF2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20181213211725.14832-1-fdmanana@kernel.org>
 <20190111171759.19920-1-fdmanana@kernel.org>
 <0cd4bdb0-9389-a8f0-9094-78b3ccd1d254@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cd4bdb0-9389-a8f0-9094-78b3ccd1d254@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 14, 2019 at 04:21:43PM +0800, Anand Jain wrote:
> 
> 
> On 01/12/2019 01:17 AM, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> > 
> > In a few places we are allocating a device using the GFP_KERNEL flag when
> > it is not safe to do so, because if reclaim is triggered it can cause a
> > transaction commit while we are holding the device list mutex. This mutex
> > is required in the transaction commit path (at write_all_supers() and
> > btrfs_update_commit_device_size()).
> > 
> > So fix this by setting up a nofs memory allocation context in those cases.
> > 
> > Fixes: 78f2c9e6dbb14 ("btrfs: device add and remove: use GFP_KERNEL")
> > Fixes: e0ae999414238 ("btrfs: preallocate device flush bio")
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> > 
> > V2: Change the approach to fix the problem by setting up nofs contextes
> >      where needed.
> > 
> >   fs/btrfs/volumes.c | 33 ++++++++++++++++++++++++++++++---
> >   1 file changed, 30 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 2576b1a379c9..663566baae78 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -14,6 +14,7 @@
> >   #include <linux/semaphore.h>
> >   #include <linux/uuid.h>
> >   #include <linux/list_sort.h>
> > +#include <linux/sched/mm.h>
> >   #include "ctree.h"
> >   #include "extent_map.h"
> >   #include "disk-io.h"
> > @@ -988,20 +989,29 @@ static noinline struct btrfs_device *device_list_add(const char *path,
> >   	}
> >   
> >   	if (!device) {
> > +		unsigned int nofs_flag;
> > +
> >   		if (fs_devices->opened) {
> >   			mutex_unlock(&fs_devices->device_list_mutex);
> >   			return ERR_PTR(-EBUSY);
> >   		}
> >   
> > +		/*
> > +		 * Setup nofs context because we are holding the device list
> > +		 * mutex, which is required for a transaction commit.
> > +		 */
> 
> I wonder if there is a bug due to GFP_KERNEL in device_list_add()?
> as device_list_add() can only be called only when the FSID is not yet
> mounted. OR if its done for the sake of consistency when calling\
> btrfs_alloc_device().

It still could be called but a new device will not be allocated, all is
done either via scan or during mount. A missing device has an entry in
fs_devices.

We can keep th NOFS protection around that to make it future-proof, as
it's not trivial to see if this is always called from safe context or
not.
