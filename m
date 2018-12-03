Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726F9C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 17:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41ECF20850
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 17:25:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41ECF20850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbeLCRZg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 12:25:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:34972 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725868AbeLCRZf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Dec 2018 12:25:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3C14FAC96;
        Mon,  3 Dec 2018 17:25:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EC431DAF63; Mon,  3 Dec 2018 18:25:11 +0100 (CET)
Date:   Mon, 3 Dec 2018 18:25:11 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/5] btrfs: Refactor btrfs_can_relocate
Message-ID: <20181203172511.GB17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-3-git-send-email-nborisov@suse.com>
 <eb2690a3-7a47-af8f-a7cc-3d0cee98a1da@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb2690a3-7a47-af8f-a7cc-3d0cee98a1da@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Nov 17, 2018 at 09:29:27AM +0800, Anand Jain wrote:
> > -			ret = find_free_dev_extent(trans, device, min_free,
> > -						   &dev_offset, NULL);
> > -			if (!ret)
> > +			if (!find_free_dev_extent(trans, device, min_free,
> > +						   &dev_offset, NULL))
> 
>   This can return -ENOMEM;
> 
> > @@ -2856,8 +2856,7 @@ static int btrfs_relocate_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
> >   	 */
> >   	lockdep_assert_held(&fs_info->delete_unused_bgs_mutex);
> >   
> > -	ret = btrfs_can_relocate(fs_info, chunk_offset);
> > -	if (ret)
> > +	if (!btrfs_can_relocate(fs_info, chunk_offset))
> >   		return -ENOSPC;
> 
>   And ends up converting -ENOMEM to -ENOSPC.
> 
>   Its better to propagate the accurate error.

Right, converting to bool is obscuring the reason why the functions
fail. Making the code simpler at this cost does not look like a good
idea to me. I'll remove the patch from misc-next for now.
