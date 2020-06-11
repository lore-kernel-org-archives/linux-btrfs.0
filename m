Return-Path: <SRS0=xGl5=7Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3D1C433E0
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 13:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B73320801
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 13:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgFKNoQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 09:44:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:52752 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgFKNoP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jun 2020 09:44:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CE494AE2C;
        Thu, 11 Jun 2020 13:44:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 86AB4DA82A; Thu, 11 Jun 2020 15:44:07 +0200 (CEST)
Date:   Thu, 11 Jun 2020 15:44:07 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/15] btrfs-progs: simplify chunk allocation a bit
Message-ID: <20200611134407.GO27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org
References: <20200610123258.12382-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610123258.12382-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 10, 2020 at 09:32:43PM +0900, Johannes Thumshirn wrote:
> While playing a bit with the RAID code, I've come up with some cleanups for
> the chunk allocatin in progs. It's not aligned to what we're doing in the
> kernel, but the code has diverged so much it is a daunting task to converge it
> again.

Thanks, converging the code would take time and smaller steps are fine.
> 
> Johannes Thumshirn (15):
>   btrfs-progs: simplify minimal stripe number checking
>   btrfs-progs: simplify assignment of number of RAID stripes
>   btrfs-progs: introduce alloc_chunk_ctl structure
>   btrfs-progs: cache number of devices for chunk allocation
>   btrfs-progs: pass alloc_chunk_ctl to chunk_bytes_by_type
>   btrfs-progs: introduce raid profile table for chunk allocation
>   btrfs-progs: consolidate assignment of minimal stripe number
>   btrfs-progs: consolidate assignment of sub_stripes
>   btrfs-progs: consolidate setting of RAID1 stripes
>   btrfs-progs: do table lookup for simple RAID profiles' num_stripes
>   btrfs-progs: consolidate num_stripes sanity check
>   btrfs-progs: compactify num_stripe setting in btrfs_alloc_chunk
>   btrfs-progs: introduce init_alloc_chunk_ctl
>   btrfs-progs: don't pretend RAID56 has a different stripe length
>   btrfs-progs: consolidate num_stripes setting for striping RAID levels

Added to devel.
