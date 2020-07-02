Return-Path: <SRS0=RJN2=AN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0CDC433DF
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jul 2020 13:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF132207CD
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jul 2020 13:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgGBNgh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 09:36:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:40700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729199AbgGBNgg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Jul 2020 09:36:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AB8C2AC6E;
        Thu,  2 Jul 2020 13:36:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 367CFDA781; Thu,  2 Jul 2020 15:36:19 +0200 (CEST)
Date:   Thu, 2 Jul 2020 15:36:18 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 8/8] btrfs: sysfs: Add bdi link to the fsid dir
Message-ID: <20200702133618.GN27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20200702122335.9117-1-nborisov@suse.com>
 <20200702122335.9117-9-nborisov@suse.com>
 <8469fe54-2641-9873-c845-8355932fccef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8469fe54-2641-9873-c845-8355932fccef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jul 02, 2020 at 09:25:30AM -0400, Josef Bacik wrote:
> On 7/2/20 8:23 AM, Nikolay Borisov wrote:
> > Since BTRFS uses a private bdi it makes sense to create a link to this
> > bdi under /sys/fs/btrfs/<UUID>/bdi. This allows size of read ahead to
> > be controlled. Without this patch it's not possible to uniquely identify
> > which bdi pertains to which btrfs filesystem in the fase of multiple
> > btrfs filesystem.
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Was confused why we needed to make sure the link existed before removing it, 
> since other things sysfs is smart enough to figure out.  Apparently it has a 
> WARN_ON() if the parent isn't initialized, so the check is necessary, albeit 
> annoying.

There must be a better way, this is just too weird. We can check if
objects have been initialized by peeking to kobject::state_initialized
and we use that already for fsid_kobj in __btrfs_sysfs_remove_fsid or
btrfs_sysfs_feature_update.
